//
//  ContentView.m
//  知古鉴今
//
//  Created by qingyun on 16/6/21.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "ContentView.h"
#import "Common.h"

@implementation ContentView

//+(instancetype)contentWithModel:(IdiomModel *)model{
//    return [[self alloc] initWithModel:model];
//}

-(void)viewWithModel:(IdiomModel *)model{
    //输出按钮options
    //从xib中加载
    //设置列数
    int contentColumn = 6;
    //设置Btn宽、高
    CGFloat BtnW = 40;
    CGFloat BtnH = 40;
    //设置间隔
    CGFloat speaceX = (ScreenW - 50 - (BtnW * contentColumn)) / (contentColumn + 1);
    CGFloat speaceY = speaceX;
    //将模型中的数组转换成全部字的数组
    NSMutableArray *arr = [self myArrayByModelArray:model.idioms];
    //转换随机数组,让答案选项随机
    NSString *str;
    for (NSInteger i = 0; i < arr.count; i++) {
        NSInteger j = i + arc4random() % (arr.count - i);
        str = arr[i];
        arr[i] = arr[j];
        arr[j] = str;
    }
    //设置Btn
    for (int i = 0; i < arr.count; i++) {
        //计算当前所在行列
        int row = i / contentColumn;
        int col = i % contentColumn;
        //计算位置
        CGFloat BtnX = speaceX * (col + 1) + BtnW * col;
        CGFloat BtnY = (speaceY + BtnH) * row;
        //添加Btn
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.frame = CGRectMake(BtnX, BtnY, BtnW, BtnH);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //添加事件监听
        [btn addTarget:self action:@selector(contentBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(NSMutableArray *)myArrayByModelArray:(NSArray *)modelArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in modelArray) {
        NSString *str1 = [str substringWithRange:NSMakeRange(0, 1)];
        NSString *str2 = [str substringWithRange:NSMakeRange(1, 1)];
        NSString *str3 = [str substringWithRange:NSMakeRange(2, 1)];
        NSString *str4 = [str substringWithRange:NSMakeRange(3, 1)];
        [array addObject:str1];
        [array addObject:str2];
        [array addObject:str3];
        [array addObject:str4];
    }
    return array;
}

-(void)contentBtn:(UIButton *)sender{
    //将当前的btn隐藏
    //将当前的btn的text传到对应的answerbtn上
    if (_optionBtnClick) {
        _optionBtnClick(sender);
    }
}

@end
