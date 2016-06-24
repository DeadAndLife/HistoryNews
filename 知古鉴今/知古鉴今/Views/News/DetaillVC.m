//
//  DetaillVC.m
//  知古鉴今
//
//  Created by qingyun on 16/6/22.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "DetaillVC.h"
#import "News.h"
#import "AFNetWorking.h"
#import "SVProgressHUD.h"

@interface DetaillVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DetaillVC

-(void)requestHomeList{
    //1.创建Manager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置参数
    //2.1设置响应接受类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/vnd.somevendor-v1+json",@"text/html", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //3.GET请求
    __weak DetaillVC *weakSelf = self;
    if (_model.url) {
        [manager GET:_model.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD showWithStatus:@"努力加载中..."];
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //解析时间数据
            NSRange rangeFirst = [str rangeOfString:@"<span style"];
            NSRange rangeSecond = [str rangeOfString:@"</span>"];
            NSString *strTime;
            if ((rangeFirst.length !=0)&&(rangeSecond.length != 0)) {
                NSString *strTime1 = [str substringWithRange:NSMakeRange(rangeFirst.location + 1, rangeSecond.location - rangeFirst.location)];
                NSRange rangeTime1 = [strTime1 rangeOfString:@">"];
                NSRange rangeTime2 = [strTime1 rangeOfString:@"<"];
                strTime = [strTime1 substringWithRange:NSMakeRange(rangeTime1.location + 1, rangeTime2.location - rangeTime1.location - 1)];
            }
            _timeLabel.text = strTime;
            //解析网页数据
            NSRange rangeWeb1 = [str rangeOfString:@"<div id=\"content\">"];
            NSRange rangeWeb2 = [str rangeOfString:@"<div id=\"recommend_bottom\">"];
            if ((rangeWeb1.length != 0)&&(rangeWeb2.length != 0)) {
                NSString *webStr = [[str substringWithRange:NSMakeRange(rangeWeb1.location, rangeWeb2.location - rangeWeb1.location)] stringByAppendingString:@"</div>"];
                [weakSelf.webView loadHTMLString:webStr baseURL:nil];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
                [SVProgressHUD dismissWithDelay:1.0];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"++error==%@++",error);
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
        [SVProgressHUD dismissWithDelay:1.0];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _titleLable.text = _model.title;
#if 1
    [self requestHomeList];
#else
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.url]]];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.scrollView.bounces = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
