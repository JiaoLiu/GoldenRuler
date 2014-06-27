//
//  LSCommentsView.m
//  金标尺
//
//  Created by wzq on 14/6/14.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSCommentsView.h"
#import "LSComments.h"

@implementation LSCommentsView

- (id)initWithFrame:(CGRect)frame withComments:(NSMutableArray *)comments withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

//        NSString *title = @"题目：题目内容是什么东西？恩阳古镇 ；雨中的恩阳古镇更显古朴宁静，到了恩阳古镇不可错过的当然就是“恩阳十大碗”，每一碗都是肉劲十足。";
        CGRect textFrame = CGRectMake(20, 0, 0, 0);
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        textFrame.size = size;
        
        _titleLabel = [[UILabel alloc]initWithFrame:textFrame];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = RGB(4, 121, 202);
        [self addSubview:_titleLabel];
        
        _textView = [[UITextViewWithPlaceholder alloc]initWithFrame:CGRectMake(textFrame.origin.x, textFrame.origin.y + textFrame.size.height+10, SCREEN_WIDTH-40, 60)];
        _textView.placeholder = @"评论内容，可输入0/200个字符";
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.cornerRadius = 5;
        [self addSubview:_textView];
        
        UIButton *cmtBtn = [[UIButton alloc]initWithFrame:CGRectMake(textFrame.origin.x, _textView.frame.origin.y+_textView.frame.size.height+10, SCREEN_WIDTH-40, 40)];
        
        cmtBtn.backgroundColor = RGB(3, 121, 202);
        [cmtBtn setTitle:@"提交" forState:UIControlStateNormal];
        [cmtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cmtBtn.layer.cornerRadius = 2;
        [cmtBtn addTarget:self action:@selector(commontsSmt:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cmtBtn];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, cmtBtn.frame.origin.y+cmtBtn.frame.size.height+5, SCREEN_WIDTH, 30)];
        UILabel *uc = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 30)];
        uc.text = @"用户评论";
        uc.font = [UIFont systemFontOfSize:14];
        uc.backgroundColor = [UIColor clearColor];
        [view addSubview:uc];
        
        UILabel *uc2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, 0, 100, 30)];
        self.numLabel = uc2;
        uc2.text = [NSString stringWithFormat:@"共%d条评论",comments.count];
        uc2.textColor = [UIColor grayColor];
        uc2.font = [UIFont systemFontOfSize:14];
        uc2.backgroundColor = [UIColor clearColor];
        uc2.textAlignment = NSTextAlignmentRight;
        [view addSubview:uc2];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        
        CGRect tFrame = CGRectMake(0,view.frame.origin.y + view.frame.size.height , SCREEN_WIDTH, frame.size.height -view.frame.origin.y - view.frame.size.height);
        _cTableView = [[UITableView alloc]initWithFrame:tFrame style:UITableViewStylePlain];
        _cTableView.tableFooterView = [UIView new];
        [self addSubview:_cTableView];
    }
    return self;
}

- (void)commontsSmt:(UIButton *)btn
{   [_textView resignFirstResponder];
    [_delegate commentsBtnClick:_textView.text];
    _textView.text = nil;
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
