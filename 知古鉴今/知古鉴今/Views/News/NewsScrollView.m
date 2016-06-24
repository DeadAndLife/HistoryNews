//
//  NewsScrollView.m
//  知古鉴今
//
//  Created by qingyun on 16/6/22.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "NewsScrollView.h"
#import "Masonry.h"

@implementation NewsScrollView

+(instancetype)titleScrollViewWithTitles:(NSArray *)titles{
    NewsScrollView *newsScrollView = [NewsScrollView new];
    newsScrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < titles.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [newsScrollView addSubview:titleBtn];
        //设置属性
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitle:titles[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        titleBtn.tag = 1000 +i;
        [titleBtn addTarget:newsScrollView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置约束
        if (i == 0) {
            [titleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.centerY.mas_equalTo(0);
            }];
        }else if (i == titles.count - 1){
            [titleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                UIButton *previousBtn = (UIButton *)[newsScrollView viewWithTag:titleBtn.tag - 1];
                make.left.equalTo(previousBtn.mas_right).with.offset(10);
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-10);
            }];
        }else{
            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                UIButton *previousBtn = (UIButton *)[newsScrollView viewWithTag:titleBtn.tag - 1];
                make.left.equalTo(previousBtn.mas_right).with.offset(10);
                make.centerY.mas_equalTo(0);
            }];
        }
    }
    newsScrollView.currentIndex = 0;
    return newsScrollView;
}

-(void)btnClick:(UIButton *)sender{
    if (self.currentIndex != sender.tag -1000) {
        self.currentIndex = sender.tag - 1000;
        
        if (_changeContentVC) {
            _changeContentVC(self.currentIndex);
        }
    }
}

-(void)setCurrentIndex:(NSUInteger)currentIndex{
    //1.根据_currentIndex设置之前选中的栏目的标题为黑色
    UIButton *previousBtn = [self viewWithTag:1000 + _currentIndex];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    previousBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    //2.根据currentIndex将要选中的栏目的标题为红色
    UIButton *willSelectedBtn = [self viewWithTag:1000 + currentIndex];
    [willSelectedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    willSelectedBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    //3.保存选中的栏目的索引
    _currentIndex = currentIndex;
    //4.计算偏移量
    CGFloat detalValue = willSelectedBtn.center.x - self.center.x;
    if ((detalValue < 0)||(self.contentSize.width <= [UIScreen mainScreen].bounds.size.width)) {
        detalValue = 0;
    }else if (detalValue > self.contentSize.width - self.frame.size.width){
        detalValue = self.contentSize.width - self.frame.size.width;
    }
    //5.设置偏移量
    
    [self setContentOffset:CGPointMake(detalValue, 0) animated:YES];
}

@end
