//
//  NSString+Path.h
//  知古鉴今
//
//  Created by qingyun on 16/6/22.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)
//游戏存储路径
+(NSString *)pathForGameLevel;
//新闻存储路径
+(NSString *)pathForNews;

@end
