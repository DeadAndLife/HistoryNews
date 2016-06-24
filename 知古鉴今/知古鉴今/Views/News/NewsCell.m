//
//  NewsCell.m
//  知古鉴今
//
//  Created by qingyun on 16/6/19.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"

@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;

@end

@implementation NewsCell

-(void)setNews:(News *)news{
    _news = news;
    _titleLabel.text = news.title;
    _sourceLabel.text = news.source;
    _timeLabel.text = news.date;
    [_firstImage sd_setImageWithURL:[NSURL URLWithString:news.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"ImageFailed"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
