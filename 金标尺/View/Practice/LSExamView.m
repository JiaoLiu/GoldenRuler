//
//  LSExamView.m
//  金标尺
//
//  Created by wzq on 14/6/12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSExamView.h"



@implementation LSExamView

- (instancetype)initWithFrame:(CGRect)frame withQuestion:(LSQuestion *)question
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        NSArray *answers = [question.answer ]
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        //抛弃nib 用手写😭
        UIView *ttView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        ttView.backgroundColor = RGB(220, 220, 220);
        _testType = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 61, 31)];
        _testType.font = [UIFont systemFontOfSize:14];
        _testType.textColor = [UIColor darkGrayColor];
        _testType.text = @"[单选题]";
        _testType.backgroundColor = [UIColor clearColor];
        
        _usedTime = [[UILabel alloc]initWithFrame:CGRectMake(108, 0, 100, 31)];
        _usedTime.textAlignment = NSTextAlignmentCenter;
        _usedTime.font = [UIFont systemFontOfSize:14];
        _usedTime.textColor = [UIColor darkGrayColor];
        _usedTime.text = @"已用时 12:33";
        
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(241, 0, 79, 31)];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"nx.9.png"] forState:UIControlStateNormal];
        [_selectBtn setTitle:@"0/0" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ttView addSubview:_testType];
//        [ttView addSubview:_usedTime];
        [ttView addSubview:_selectBtn];
        
        
        [_scrollView addSubview:ttView];
        
        
        CGRect frame = CGRectMake(10, 0, 0, 0);
        CGSize size = [question.title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        frame.size = size;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];//题目描述label
        label.text = question.title;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont systemFontOfSize:14];
        UIView *hv = [[UIView alloc]initWithFrame:frame];
        [hv addSubview:label];
        
        //考题view
        _questionView  = [[UITableView alloc]initWithFrame:CGRectMake(0, ttView.frame.origin.y + ttView.frame.size.height, SCREEN_WIDTH, 100) style:UITableViewStylePlain];
//        _questionView.delegate = self;
//        _questionView.dataSource = self;
        _questionView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _questionView.editing = YES;

        _questionView.tableHeaderView = hv;
        _questionView.frame = CGRectMake(0, 31, SCREEN_WIDTH, 35*4 + hv.frame.size.height > 210 ? 140+hv.frame.size.height : 210);
        [_scrollView addSubview:_questionView];
        
        
        _operView = [[UIView alloc]initWithFrame:CGRectMake(0, _questionView.frame.size.height + _questionView.frame.origin.y, SCREEN_WIDTH, 100)];
        _operView.backgroundColor = RGB(220, 220, 220);
        
        _operTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
//        operTop.backgroundColor = RGB(210, 210, 210);
        
        [_operView addSubview:_operTop];
        _rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nx_go.png"]];
        _rightImage.frame = CGRectMake(30, 6, 19, 18);
        _wrongImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nx_c.png"]];
        _wrongImage.frame = CGRectMake(30, 6, 19, 18);
        
        [_operTop addSubview:_rightImage];
        [_operTop addSubview:_wrongImage];
        _myAnswer = [[UILabel alloc]initWithFrame:CGRectMake(62, 4, 97, 21)];
        _myAnswer.textColor = [UIColor darkGrayColor];
        _myAnswer.font = [UIFont systemFontOfSize:14];
        _myAnswer.text = @"你的答案:A";
        _myAnswer.backgroundColor = [UIColor clearColor];
        [_operTop addSubview:_myAnswer];
        [_operTop setHidden:YES];
        
        UILabel *rtAnswer = [[UILabel alloc]initWithFrame:CGRectMake(198, 4, 110, 21)];
        rtAnswer.textColor = [UIColor darkGrayColor];
        rtAnswer.font = [UIFont systemFontOfSize:14];
        rtAnswer.text = [NSString stringWithFormat:@"正确答案:%@",question.right];
        rtAnswer.backgroundColor = [UIColor clearColor];
        [_operTop addSubview:rtAnswer];
        
        
        //操作按钮
        
        _preQuestion = [[UIButton alloc]initWithFrame:CGRectMake(13, 48, 76, 27)];
        [_preQuestion setBackgroundImage:[UIImage imageNamed:@"nx_btna.9.png"] forState:UIControlStateNormal];
        [_preQuestion setTitle:@"上一题" forState:UIControlStateNormal];
        [_preQuestion setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _preQuestion.titleLabel.font = [UIFont systemFontOfSize:14];
//        _preQuestion.layer.borderColor = [UIColor darkGrayColor].CGColor;
//        _preQuestion.layer.borderWidth = 0.5;
//        _preQuestion.layer.cornerRadius = 4;
        [_preQuestion addTarget:self action:@selector(prev) forControlEvents:UIControlEventTouchUpInside];
        
        _nextQuestion = [[UIButton alloc]initWithFrame:CGRectMake(224, 48, 76, 27)];
        [_nextQuestion setBackgroundImage:[UIImage imageNamed:@"nx_btna.9.png"] forState:UIControlStateNormal];
        [_nextQuestion setTitle:@"下一题" forState:UIControlStateNormal];
        [_nextQuestion setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _nextQuestion.titleLabel.font = [UIFont systemFontOfSize:14];
        [_nextQuestion addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
        _currBtn = [[UIButton alloc]initWithFrame:CGRectMake(122, 48, 76, 27)];
        [_currBtn setBackgroundImage:[UIImage imageNamed:@"nx_btnb.9.png"] forState:UIControlStateNormal];
        
        if ([_testType.text isEqualToString:@"单选"] || [_testType.text isEqualToString:@"判断"]) {
            [_currBtn setTitle:@"0/0" forState:UIControlStateNormal];
        }
        else {
            [_currBtn setTitle:@"提交" forState:UIControlStateNormal];
            [_currBtn addTarget:self action:@selector(smtAnswer) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_currBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _currBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_operView addSubview:_preQuestion];
        [_operView addSubview:_nextQuestion];
        [_operView addSubview:_currBtn];
        [_scrollView addSubview:_operView];
        
        
        _yellowBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, _operView.frame.origin.y + _operView.frame.size.height + 10, 76, 27)];
        [_yellowBtn setBackgroundImage:[UIImage imageNamed:@"nx_bg.9.png"] forState:UIControlStateNormal];
        [_yellowBtn setTitle:@"习题解析" forState:UIControlStateNormal];
        [_yellowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _yellowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_scrollView addSubview:_yellowBtn];
        
        
//        _textView = [[UITextView alloc]initWithFrame:CGRectMake(13, _yellowBtn.frame.origin.y + _yellowBtn.frame.size.height + 10, 280, 100)];
//        _textView.text = question.analysis;
        
        CGSize tsize = [question.analysis sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(290, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect tframe = CGRectMake(13, _yellowBtn.frame.origin.y + _yellowBtn.frame.size.height, 0, 0);
        tframe.size = tsize;
        _textLabel = [[UILabel alloc]initWithFrame:tframe];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.text = question.analysis;
        _textLabel.font = [UIFont systemFontOfSize:13];
        [_textLabel setHidden:YES];
        
        
        [_scrollView addSubview:_textLabel];
        
        CGRect rect = _scrollView.frame;
        rect.size.height = _textLabel.frame.origin.y + _textLabel.frame.size.height + 150;
        _scrollView.contentSize = rect.size;
        
        [self addSubview:_scrollView];
        
        
    }
    return self;
}

- (void)smtAnswer
{
    if ([_delegate respondsToSelector:@selector(smtAnswer)]) {
        [_delegate smtAnswer];
    }

}


- (void)prev
{
    if ([_delegate respondsToSelector:@selector(prevQuestion)]) {
        [_delegate prevQuestion];
    }
}

- (void)next
{
    if ([_delegate respondsToSelector:@selector(nextQuestion)]) {
        [_delegate nextQuestion];
    }
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
