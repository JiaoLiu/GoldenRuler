//
//  LSTopTableViewCell.m
//  金标尺
//
//  Created by wzq on 14/7/1.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSTopTableViewCell.h"

@implementation LSTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 30, 25)];
        _placeLabel.textColor = [UIColor whiteColor];
        _placeLabel.font = [UIFont systemFontOfSize:14];
        _placeLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 100, 30)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = RGB(4, 121, 202);
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 10, 80, 30)];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor darkGrayColor];
        
        _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 10, 50, 30)];
        _scoreLabel.font = [UIFont systemFontOfSize:14];
        _scoreLabel.textColor = [UIColor darkGrayColor];
        
        [self addSubview:_placeLabel];
        [self addSubview:_nameLabel];
        [self addSubview:_timeLabel];
        [self addSubview:_scoreLabel];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
