//
//  IdiomModel.m
//  知古鉴今
//
//  Created by qingyun on 16/6/21.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "IdiomModel.h"

@implementation IdiomModel

+(instancetype)modelWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
