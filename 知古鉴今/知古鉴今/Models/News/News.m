//
//  News.m
//  知古鉴今
//
//  Created by qingyun on 16/6/19.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "News.h"
#import "NSDate+Time.h"
#import "AFNetWorking.h"

@implementation News

+(instancetype)newsWithJosn:(NSDictionary *)josn{
    return [[self alloc] initWithJosn:josn];
}

-(instancetype)initWithJosn:(NSDictionary *)josn{
    if (self = [super init]) {
        _date = [self dateStringForDate:[NSDate timeDateWithString:josn[@"date"]]];
        if (josn[@"thumbnail_pic"] != [NSNull null]) {
            _thumbnail_pic = josn[@"thumbnail_pic"];
        }
        _newsID = [josn[@"id"] integerValue];
        _source = josn[@"source"];
        _title = josn[@"title"];
        [self requestUrl:josn[@"url"]];
        _categoty = josn[@"categoty"];
    }
    return self;
}

-(void)requestUrl:(NSString *)url{
    //1.创建Manager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置参数
    //        NSDictionary *pars = @{@"cid":@([self cidForType:self.type]),@"page":@(_page)};
    //2.1设置响应接受类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/vnd.somevendor-v1+json",@"text/html", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //3.GET请求
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSRange rangeHeader = [str rangeOfString:@"<iframe"];
        NSRange rangeFooter = [str rangeOfString:@"</iframe>"];
        NSString *strFrame = [str substringWithRange:NSMakeRange(rangeHeader.location, rangeFooter.location + rangeFooter.length - rangeHeader.location)];
        NSRange rangeScrHeader = [strFrame rangeOfString:@"src=\""];
        NSRange rangeScrFooter = [strFrame rangeOfString:@"frameborder"];
        NSUInteger headerLocation = rangeScrHeader.location + rangeScrHeader.length;
        NSString *strScr = [strFrame substringWithRange:NSMakeRange(headerLocation , rangeScrFooter.location - 1 - headerLocation)];
        _url = [strScr componentsSeparatedByString:@"\""][0];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"++error==%@++",error);
    }];
}


//动态计算微博创建的时间(按照时间级别展示)
-(NSString *)dateStringForDate:(NSDate *)date{
    //1.计算时间差(单位:秒)
    NSTimeInterval interval = -[date timeIntervalSinceNow];
    //2.根据时间差确定时间级别
    if (interval < 60) {//秒级
        return [NSString stringWithFormat:@"%d 秒之前",(int)interval];
    }else if (interval < 60 * 60){//分级
        return [NSString stringWithFormat:@"%d 分之前",(int)(interval / 60)];
    }else if (interval < 60 * 60 * 24){//时级
        return [NSString stringWithFormat:@"%d 小时之前",(int)(interval / (60 * 60))];
    }else if (interval < 60 * 60 * 24 * 30){//天级
        return [NSString stringWithFormat:@"%d 天之前",(int)(interval / (60 * 60 * 24))];
    }else{//直接格式化时间
        /****NSDateFormatterStyle
         NSDateFormatterNoStyle
         如:(空白)
         NSDateFormatterShortStyle
         如:16/5/26   上午 11:41
         NSDateFormatterMediumStyle
         如:2016年5月26日  上午 11:42:00
         NSDateFormatterLongStyle
         如:2016年5月26日  GMT +8 上午 11:42:00
         NSDateFormatterFullStyle
         如:2016年5月26日 星期四    中国标准时间上午 上午 11:42:00
         ***/
        return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
}

@end
