//
//  AnswerView.h
//  知古鉴今
//
//  Created by qingyun on 16/6/22.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdiomModel.h"

@interface AnswerView : UIView
//添加事件动作的block
@property (nonatomic, strong) void (^answerBtnClick)(UIButton *answerBtn);

//+(instancetype)answerWithModel:(IdiomModel *)model;
-(void)viewWithModel;

@end
