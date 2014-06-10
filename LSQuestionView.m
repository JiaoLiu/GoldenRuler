//
//  LSQuestionView.m
//  金标尺
//
//  Created by wzq on 14/6/7.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSQuestionView.h"

@implementation LSQuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _questionTitle = [[UILabel alloc]init];
    }
    return self;
}




- (void)refresh
{
    CGRect rectSelf = CGRectMake(0, 0, 320, 100);
    
    
    CGSize size = [_question.title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = CGRectMake(10, 0, 300, 0);
    rect.size = size;
    _questionTitle = [[UILabel alloc]initWithFrame:rect];
    _questionTitle.text = _question.title;
    _questionTitle.font = [UIFont systemFontOfSize:14];
    _questionTitle.numberOfLines = 0;
    _questionTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_questionTitle];
    
    
    
    //答案选择
    NSArray *asrs = [_question.answer componentsSeparatedByString:@"|"];
    NSString *right = _question.right;
    float y = _questionTitle.frame.size.height +5;
    for (NSString *str in asrs) {
        LSAnswerView *asView = [[LSAnswerView alloc]initWithFrame:CGRectZero answer:str];
        if ([str hasPrefix:right]) {
            asView.checkBtn.tag = 1;
        }
        CGRect frame = asView.frame;
        frame.origin.y += y;
        asView.frame = frame;
        y += asView.frame.size.height;
        
        [self addSubview:asView];

    }
    
    rectSelf.size.height = _questionTitle.frame.size.height+y;
    self.frame = rectSelf;

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

@implementation LSAnswerView
- (id)initWithFrame:(CGRect)frame answer:(NSString *)answer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        [_checkBtn setImage:[UIImage imageNamed:@"nx_b"] forState:UIControlStateNormal];
        
        CGSize size = [answer sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(270, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect rect = CGRectMake(18, 0, 0, 0);
        rect.size = size;
        _contentLabel = [[UILabel alloc]initWithFrame:rect];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.text = answer;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        rect.size.width += 20;
        self.frame = rect;
        [self addSubview:_checkBtn];
        [self addSubview:_contentLabel];
        
    }
    return self;
}

@end