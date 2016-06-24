//
//  NSDate+Time.m
//  知古鉴今
//
//  Created by qingyun on 16/6/20.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "NSDate+Time.h"

@implementation NSDate (Time)
+(instancetype)timeDateWithString:(NSString *)dateString{
    //2016-06-20 20:59:44
    NSString *dateFormatter = @"yyyy-MM-dd hh:mm:ss";
    NSDateFormatter *formatter;
    formatter.dateFormat = dateFormatter;
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    //将字符串格式转化成NSDate
    return [formatter dateFromString:dateFormatter];
}
@end
