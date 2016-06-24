//
//  News.h
//  知古鉴今
//
//  Created by qingyun on 16/6/19.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, strong) NSString *date;//日期   2016-06-19 17:17:21
@property (nonatomic, strong) NSString *thumbnail_pic;//图片
@property (nonatomic, assign) NSInteger newsID;//id
@property (nonatomic, strong) NSString *source;//来源
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *url;//网址
@property (nonatomic, strong) NSString *categoty;//分类(是汉字用的UTF-8)

+(instancetype)newsWithJosn:(NSDictionary *)josn;
-(instancetype)initWithJosn:(NSDictionary *)josn;

@end
