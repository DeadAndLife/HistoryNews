//
//  IdiomModel.h
//  知古鉴今
//
//  Created by qingyun on 16/6/21.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdiomModel : NSObject

@property (nonatomic, strong) NSArray *idioms;
@property (nonatomic, strong) NSNumber *level;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
+(instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
