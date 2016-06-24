//
//  ContentView.h
//  知古鉴今
//
//  Created by qingyun on 16/6/21.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdiomModel.h"

@interface ContentView : UIView
//添加事件动作的block
@property (nonatomic, strong) void (^optionBtnClick)(UIButton *optionBtn);

-(void)viewWithModel:(IdiomModel *)model;
//+(instancetype)contentWithModel:(IdiomModel *)model;

@end
