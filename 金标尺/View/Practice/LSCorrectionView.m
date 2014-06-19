//
//  LSCorrectionView.m
//  金标尺
//
//  Created by wzq on 14/6/14.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSCorrectionView.h"

@implementation LSCorrectionView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
//        NSString *title = @"题目：题目内容是什么东西？恩阳古镇 ；雨中的恩阳古镇更显古朴宁静，到了恩阳古镇不可错过的当然就是“恩阳十大碗”，每一碗都是肉劲十足。";
        CGRect frame = CGRectMake(20, 0, 0, 0);
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        frame.size = size;
        
        _titleLabel = [[UILabel alloc]initWithFrame:frame];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = RGB(4, 121, 202);
        [self addSubview:_titleLabel];
        
        _textView = [[UITextViewWithPlaceholder alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height+10, SCREEN_WIDTH-40, 100)];
        _textView.placeholder = @"纠错内容，可输入0/200个字符";
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.cornerRadius = 5;
        [self addSubview:_textView];
        
        UIButton *cmtBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.origin.x, _textView.frame.origin.y+_textView.frame.size.height+10, SCREEN_WIDTH-40, 40)];
        
        cmtBtn.backgroundColor = RGB(3, 121, 202);
        [cmtBtn setTitle:@"提交" forState:UIControlStateNormal];
        [cmtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cmtBtn.layer.cornerRadius = 2;
        [cmtBtn addTarget:self action:@selector(commontsSmt:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cmtBtn];
        
        
        
        
        
        
    }
    return self;
}

- (void)commontsSmt:(id)button
{

    [_textView resignFirstResponder];
    [_delegate correctionBtnClick:_textView.text];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
