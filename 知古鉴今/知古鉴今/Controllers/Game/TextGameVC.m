//
//  TextGameVC.m
//  知古鉴今
//
//  Created by qingyun on 16/6/20.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "TextGameVC.h"
#import "Masonry.h"
#import "ContentView.h"
#import "AnswerView.h"
#import "IdiomModel.h"
#import "NSString+Path.h"

@interface TextGameVC ()
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet ContentView *contentView;
@property (weak, nonatomic) IBOutlet AnswerView *answerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IdiomModel *model;//当前的题目
@property (nonatomic, strong) NSArray *idiomArray;
@property (nonatomic) NSInteger currentLevel;//需要存储本地，关卡
@property (nonatomic, strong) NSTimer *timer;//时间
@property (nonatomic, copy) __block NSMutableString *mutableString;//用于判断所填写的文字
@property (nonatomic, strong) NSMutableArray *currentIdiom;//还剩下的成语的数组

@end

@implementation TextGameVC

-(NSArray *)idiomArray{
    if (_idiomArray == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TextGame" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            IdiomModel *model = [IdiomModel modelWithDictionary:dic];
            [models addObject:model];
        }
        _idiomArray = models;
    }
    return _idiomArray;
}

-(NSMutableString *)mutableString{
    if (!_mutableString) {
        _mutableString = [[NSMutableString alloc] init];
    }
    return _mutableString;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //取_currentLevel
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *pathLevel = [NSString pathForGameLevel];
    if ([manager fileExistsAtPath:pathLevel]) {
        _currentLevel = [[NSKeyedUnarchiver unarchiveObjectWithFile:pathLevel] integerValue];
        [self isFinish:_currentLevel];
    }else{
        _currentLevel = 0;
    }
    [self showInfo];
    // Do any additional setup after loading the view.
}

-(void)updateTime{
    NSString *str = _timeLabel.text;
    NSInteger milliSecond = [[str componentsSeparatedByString:@":"][1] integerValue];
    NSInteger second = [[str componentsSeparatedByString:@":"][0] integerValue];
    if (milliSecond == 0) {
        if (second>0) {
            second--;
        }
        milliSecond = 60;
    }
    milliSecond--;
    __weak TextGameVC *weakSelf = self;
    if (second==0&&milliSecond==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"时间到" message:@"时间结束，英雄请重新来过" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
        }];
    }
    _timeLabel.text = [NSString stringWithFormat:@"%ld:%02ld",(long)second,(long)milliSecond];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showInfo{
    _currentLevel = _currentLevel % self.idiomArray.count;
    _model = self.idiomArray[_currentLevel];
    _levelLabel.text = [NSString stringWithFormat:@"第 %@ 关",@(_currentLevel + 1)];
    _timeLabel.text = [NSString stringWithFormat:@"3:00"];
    _currentIdiom = [NSMutableArray arrayWithArray:_model.idioms];
    //点击optionBtn的传值事件
    __weak TextGameVC *weakSelf = self;
    _contentView.optionBtnClick = ^(UIButton *optionBtn){
        [weakSelf optionBtnClick:optionBtn];
    };
    //点击answerBtn的传值事件
    _answerView.answerBtnClick = ^(UIButton *answerBtn){
        [weakSelf answerBtnClick:answerBtn];
    };
    [_contentView viewWithModel:_model];
    [_answerView viewWithModel];
}

#pragma mark - optionBtn的点击处理
- (void)optionBtnClick:(UIButton *)optionBtn{
    //遍历答案区的Btn，对没有内容的Btn赋值后跳出循环
    __weak TextGameVC *weakSelf = self;
    [_answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *Btn = ((UIButton *)obj);
            if (!Btn.currentTitle) {
                [Btn setTitle:optionBtn.currentTitle forState:UIControlStateNormal];
                Btn.tag = optionBtn.tag = idx + 100;
                *stop = YES;
                //添加可变数组内容
                [weakSelf.mutableString insertString:optionBtn.currentTitle atIndex:idx];
                //隐藏视图
                optionBtn.hidden = YES;
            }
            if (weakSelf.mutableString.length == 4) {
                //表示题目答案填充完整
                for (int i = 0; i < _currentIdiom.count; i++) {
                    if ([_mutableString isEqualToString:_currentIdiom[i]]) {
                        //正确
                        [weakSelf answerBtnColor:[UIColor greenColor]];
                        [_currentIdiom removeObjectAtIndex:i];
                        [weakSelf performSelector:@selector(removeAnswer) withObject:nil afterDelay:1];
                        weakSelf.contentView.userInteractionEnabled = NO;
                        break;
                    }else{
                        //错误
                        [weakSelf answerBtnColor:[UIColor redColor]];
                    }
                }
            }
        }
    }];
}

-(void)removeAnswer{
    _mutableString = nil;
    for (UIView *obj in _answerView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *Btn = ((UIButton *)obj);
            UIButton *optionBtn = [_contentView viewWithTag:Btn.tag];
            [optionBtn removeFromSuperview];
            [Btn removeFromSuperview];
            optionBtn = nil;
            Btn = nil;
        }
    }
    self.contentView.userInteractionEnabled = YES;
    if (_currentIdiom.count == 0) {
        _currentLevel++;
        [self isFinish:_currentLevel];
        //存_currentLevel
        [NSKeyedArchiver archiveRootObject:@(_currentLevel) toFile:[NSString pathForGameLevel]];
        [self showInfo];
    }else{
        [_answerView viewWithModel];
    }
}

#pragma mark - answerBtn的点击处理
- (void)answerBtnClick:(UIButton *)answerBtn{
    if (answerBtn.currentTitle.length == 0) {
        return;
    }
    //1、清除answerBtn的标题
    [answerBtn setTitle:nil forState:UIControlStateNormal];
    //2、将optionView中对应的optionBtn显示
    UIButton *optionBtn = [_contentView viewWithTag:answerBtn.tag];
    optionBtn.hidden = NO;
    [self answerBtnColor:[UIColor blackColor]];
    //3、改变可遍数组的内容(取位置时应注意字符串的变化，应根据当前位置进行删除)
    
    [self.mutableString deleteCharactersInRange:[self.mutableString rangeOfString:optionBtn.titleLabel.text]];
    optionBtn.tag = answerBtn.tag = 0;
}

#pragma mark - 改变answerBtn的颜色
- (void)answerBtnColor:(UIColor *)color{
    [_answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [((UIButton *)obj) setTitleColor:color forState:UIControlStateNormal];
        }
    }];
}

-(void)isFinish:(NSInteger)index{
    if (index >= self.idiomArray.count) {
        __weak TextGameVC *weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通关" message:@"您已经通关了，是否再来一轮？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"重置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            _currentLevel = 0;
            [NSKeyedArchiver archiveRootObject:@(_currentLevel) toFile:[NSString pathForGameLevel]];
            [weakSelf showInfo];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

@end
