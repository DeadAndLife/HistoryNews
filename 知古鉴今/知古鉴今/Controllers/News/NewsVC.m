//
//  NewsVC.m
//  知古鉴今
//
//  Created by qingyun on 16/6/19.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "NewsVC.h"
#import "NewsCell.h"
#import "News.h"
#import "AFNetWorking.h"
#import "Common.h"
#import "NSString+Path.h"
#import "DetaillVC.h"
#import "QYDataBaseTool.h"
#import "NSMutableDictionary+SQLite.h"

@interface NewsVC ()
@property (nonatomic, strong) NSMutableArray *contentArray;//新闻数组
@property (nonatomic, assign) NSInteger page;//请求的页码
@property (nonatomic, strong) NSString *titleName;//所属类别
@property (nonatomic)BOOL isRefresh;//判断是否是下拉刷新
@property (nonatomic, strong) UIButton *footerBtn;
@end

@implementation NewsVC

-(NSInteger)cidForType:(NSString *)type{
    if ([type isEqualToString:@"新闻"]) {
        _titleName = @"News";
        return 7;
    }else if ([type isEqualToString:@"奇趣发现"]){
        _titleName =@"Find";
        return 8;
    }else if ([type isEqualToString:@"财经"]){
        _titleName = @"Money";
        return 10;
    }else if ([type isEqualToString:@"科技"]){
        _titleName = @"Science";
        return 11;
    }else if ([type isEqualToString:@"娱乐"]){
        _titleName = @"Funny";
        return 14;
    }else if ([type isEqualToString:@"时尚"]){
        _titleName = @"Fashion";
        return 15;
    }else if ([type isEqualToString:@"生活精选"]){
        _titleName = @"Life";
        return 17;
    }else{
        _titleName = @"News";
        return 7;
    }
}

-(void)requestHomeList{
    //1.创建Manager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置参数
    NSDictionary *pars = @{@"cid":@([self cidForType:self.type]),@"page":@(_page)};
    //2.1设置响应接受类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/vnd.somevendor-v1+json",@"text/html", nil];
    //3.GET请求
    __weak NewsVC *weakSelf = self;
    [manager GET:BASEURL parameters:pars progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *dataDict = responseObject[@"data"];
        if (_isRefresh) {
            //清空表里的数据
            [QYDataBaseTool updateStatementsSql:Delete_HOMELIST(_titleName) withParsmeters:nil block:^(BOOL isOk, NSString *errorMsg) {
                if (!isOk) {
                    NSLog(@"%@",errorMsg);
                }
            }];
        }
        NSArray *list = dataDict[@"list"];
        NSMutableArray *models = [NSMutableArray array];
        for (NSMutableDictionary *info in list) {
            [QYDataBaseTool updateStatementsSql:INSERT_HOMELIST_SQL(_titleName) withParsmeters:info block:^(BOOL isOk, NSString *errorMsg) {
                if (isOk) {
//                    NSLog(@"%@ is ok",_titleName);
                }else{
                    NSLog(@"%@",errorMsg);
                }
            }];
            News *news = [News newsWithJosn:info];
            [models addObject:news];
        }
        //2.判断当前请求是下拉刷新,还是上了加载更多
        if (_page == 1) {
            //下拉刷新
            weakSelf.contentArray=models;
            _isRefresh=NO;
            [weakSelf.refreshControl endRefreshing];
        }else{
            //上拉加载更多
            [weakSelf.contentArray addObjectsFromArray:models];
        }
        
        //3.刷新UI 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"++error==%@++",error);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self firstLoadRequest];
}

//首次加载配置,适用下拉刷新
-(void)firstLoadRequest{
    _isRefresh=YES;
    _page=1;
    [self requestHomeList];
}

-(void)notFirstLoadRequest{
    _isRefresh = NO;
    _page +=1;
    [self requestHomeList];
}

-(void)refreshControlAction:(UIRefreshControl*)refresh{
    //.下拉加载中
    refresh.attributedTitle=[[NSAttributedString alloc] initWithString:@"下拉加载中..."];
    //执行下拉刷新操作
    [self firstLoadRequest];
}

//添加下拉刷新
-(void)addsubView{
    self.refreshControl=[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    //添加上拉加载更多
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    [footBtn setBackgroundColor:[UIColor orangeColor]];
    footBtn.frame = CGRectMake(0, 0, 0, 44);
    self.tableView.tableFooterView = footBtn;
    
    _footerBtn = footBtn;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewsCell class]) bundle:nil] forCellReuseIdentifier:@"news"];
    self.tableView.rowHeight = 120;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString pathForNews]]) {
        __weak NewsVC *weakSelf=self;
        [QYDataBaseTool selectStatementsSql:SELECT_HOMELIST_ALL(@"News") withParsmeters:nil forMode:nil block:^(NSMutableArray *resposeOjbc, NSString *errorMsg) {
            //1.字典转mode
            NSMutableArray *modeArr=[NSMutableArray array];
            for (NSMutableDictionary *tempDic in resposeOjbc) {
                News *mode=[News newsWithJosn:tempDic];
                [modeArr addObject:mode];
            }
            weakSelf.contentArray = modeArr;
            //2.刷新UI
            [weakSelf.tableView reloadData];
        }];
    }
    [self addsubView];
    _page = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"news" forIndexPath:indexPath];
    
    News *myNews = self.contentArray[indexPath.row];
    cell.news = myNews;
    
    return cell;
}

//根据偏移量来更改UI界面
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        [_footerBtn setTitle:@"松开手之后,加载更多..." forState:UIControlStateNormal];
    }else{
        [_footerBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    }
}

//当停止拖动,将要减速的时候,判断是否需要加载更多
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        [self notFirstLoadRequest];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetaillVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailView"];
    detail.model = self.contentArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
