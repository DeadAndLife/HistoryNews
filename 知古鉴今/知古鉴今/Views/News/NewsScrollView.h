//
//  NewsScrollView.h
//  知古鉴今
//
//  Created by qingyun on 16/6/22.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsScrollView : UIScrollView
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic, copy) void (^changeContentVC)(NSUInteger index);

+(instancetype)titleScrollViewWithTitles:(NSArray *)titles;

@end
