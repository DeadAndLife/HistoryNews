//
//  NSMutableDictionary+SQLite.h
//  知古鉴今
//
//  Created by qingyun on 16/6/22.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SQLite)

//序列化数据
-(NSMutableDictionary *)serialization;
//反序列化数据
-(NSMutableDictionary *)deSerializaion;

@end
