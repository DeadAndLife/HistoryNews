//
//  AnswerView.m
//  知古鉴今
//
//  Created by qingyun on 16/6/22.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "AnswerView.h"
#import "Common.h"

@implementation AnswerView

//+(instancetype)answerWithModel:(IdiomModel *)model{
//    return [[self alloc] initWithModel:model];
//}

-(void)viewWithModel{
    //获取输出框列数
    NSInteger m = 4;
    //设置Btn宽、高
    CGFloat BtnW = 40;
    CGFloat BtnH = 40;
    //设置间隔
    CGFloat SpeaceX = 15;
    CGFloat leftAndRightX = (ScreenW - BtnW * m - SpeaceX * (m - 1)) / 2;
    //设置Btn
    for (int i = 0; i < m; i++) {
        //计算X
        CGFloat BtnX = leftAndRightX + (SpeaceX + BtnW) * i;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.frame = CGRectMake(BtnX, 0, BtnW, BtnH);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //添加事件监听
        [btn addTarget:self action:@selector(answerBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)answerBtn:(UIButton *)sender{
    //将当前的btn中的text清除
    //将当前的btn的对应的optionbtn显示
    if (_answerBtnClick) {
        _answerBtnClick(sender);
    }
}

@end
