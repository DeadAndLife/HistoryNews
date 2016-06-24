//
//  HomeNewsVC.m
//  知古鉴今
//
//  Created by qingyun on 16/6/22.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "HomeNewsVC.h"
#import "NewsScrollView.h"
#import "NewsVC.h"
#import "Masonry.h"
#import "Common.h"

@interface HomeNewsVC ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic, strong) NSArray *titles;//所有栏目的标题集合
@property (nonatomic, strong) NewsScrollView *titleScrollView;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@end

@implementation HomeNewsVC

-(NSArray *)titles{
    if (_titles == nil) {
        _titles = @[@"新闻",@"奇趣发现",@"财经",@"科技",@"娱乐",@"时尚",@"生活精选"];
    }
    return _titles;
}

-(NewsScrollView *)titleScrollView{
    if (_titleScrollView == nil) {
        //创建_titleScrollView
        _titleScrollView = [NewsScrollView titleScrollViewWithTitles:self.titles];
        __weak HomeNewsVC *weakSelf = self;
        _titleScrollView.changeContentVC = ^(NSUInteger index){
            [weakSelf changeContentViewControllerWithIndex:index];
        };
    }
    return _titleScrollView;
}

-(UIPageViewController *)pageViewController{
    if (_pageViewController == nil) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        //设置数据源和代理
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        //设置内容控制器
        NewsVC *contentVC = [self viewControllerWithIndex:0];
        [_pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageViewController;
}

-(NewsVC *)viewControllerWithIndex:(NSUInteger)index{
    if (self.titles.count == 0 || index >= self.titles.count) {
        return nil;
    }
    
    NewsVC *dataVC = [[NewsVC alloc] initWithStyle:UITableViewStylePlain];
    dataVC.type = self.titles[index];
    return dataVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleScrollView.frame = CGRectMake(0, 0, ScreenW, 64);
    //设置滚动栏目视图
    self.navigationItem.titleView = self.titleScrollView;
    //设置_titleScrollView的约束
//    [_titleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(@0);
//    }];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
}

//根据选中的栏目的索引来更改内容控制器
-(void)changeContentViewControllerWithIndex:(NSUInteger)index{
    //1.获取当前控制器的type在titles中的索引currentIndex
    NewsVC *currentDataVC = self.pageViewController.viewControllers.firstObject;
    NSUInteger currentIndex = [self indexOfViewController:currentDataVC];
    //2.currentIndex == index,return;
    if (currentIndex == index) {
        return;
    }
    //3.根据index获取对应的内容控制器,然后设置内容控制器
    NewsVC *willChangedVC = [self viewControllerWithIndex:index];
    [self.pageViewController setViewControllers:@[willChangedVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

//获取当前控制器的type在titles中的索引currentIndex
-(NSUInteger)indexOfViewController:(NewsVC *)vc{
    return [self.titles indexOfObject:vc.type];
}

#pragma mark  -UIPageViewControllerDataSource
//上一个内容控制器
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //1.获取当前控制器的type在titles中的索引currentIndex
    NSUInteger currentIndex = [self indexOfViewController:(NewsVC *)viewController];
    //2.假如currentIndex == 0 返回nil; currentIndex != 0,currentIndex -= 1
    if (currentIndex == 0) {
        return nil;
    }
    currentIndex -= 1;
    //3.根据currentIndex获取上一个内容控制器
    return [self viewControllerWithIndex:currentIndex];
}

//下一个内容控制器
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    //1.获取当前控制器的type在titles中的索引currentIndex
    NSUInteger currentIndex = [self indexOfViewController:(NewsVC *)viewController];
    //2.currentIndex++
    currentIndex++;
    //3.假如currentIndex >= self.titles.count,返回nil
    if (currentIndex >= self.titles.count) {
        return nil;
    }
    //4.根据currentIndex获取下一个内容控制器
    return [self viewControllerWithIndex:currentIndex];
}

#pragma mark -UIPageViewControllerDelegate
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    //1.获取当前控制器的type在titles中的索引currentIndex
    NewsVC *currentDataVC = self.pageViewController.viewControllers.firstObject;
    NSUInteger currentIndex = [self indexOfViewController:currentDataVC];
    
    //2.获取上一个内容控制器的type在titles中的索引previousIndex
    NSUInteger previousIndex = [self indexOfViewController:(NewsVC *)previousViewControllers.firstObject];
    //3.判断currentIndex != previousIndex,设置_titleScrollView的currentIndex等于currentIndex
    if (currentIndex != previousIndex) {
        _titleScrollView.currentIndex = currentIndex;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
