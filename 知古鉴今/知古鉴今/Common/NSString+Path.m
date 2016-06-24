//
//  NSString+Path.m
//  知古鉴今
//
//  Created by qingyun on 16/6/22.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

+(NSString *)pathForGameLevel{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documentsPath stringByAppendingPathComponent:@"GameLevel"];
}

+(NSString *)pathForNews{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"News.db"];
}

@end
