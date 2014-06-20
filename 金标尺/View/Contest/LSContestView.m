//
//  LSContestView.m
//  金标尺
//
//  Created by wzq on 14/6/14.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSContestView.h"

@implementation LSContestView

- (id)initWithFrame:(CGRect)frame withQuestion:(LSQuestion *)question
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
        _usedTime.backgroundColor = [UIColor clearColor];
        
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(241, 0, 79, 31)];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"nx.9.png"] forState:UIControlStateNormal];
        [_selectBtn setTitle:@"2/100" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ttView addSubview:_testType];
        [ttView addSubview:_usedTime];
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
        _questionView.frame = CGRectMake(0, 31, SCREEN_WIDTH, 35*4 + hv.frame.size.height > 230 ? 140+hv.frame.size.height : 230);
        [_scrollView addSubview:_questionView];
        
        
        _operView = [[UIView alloc]initWithFrame:CGRectMake(0, _questionView.frame.size.height + _questionView.frame.origin.y, SCREEN_WIDTH, 100)];
        _operView.backgroundColor = [UIColor clearColor];
        
        UIView *operTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
        operTop.backgroundColor = RGB(210, 210, 210);
        
        [_operView addSubview:operTop];
        _rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nx_go.png"]];
        _rightImage.frame = CGRectMake(30, 6, 19, 18);
        _wrongImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nx_c.png"]];
        _wrongImage.frame = CGRectMake(30, 6, 19, 18);
        [_rightImage setHidden:YES];
        [_wrongImage setHidden:YES];
        
        [operTop addSubview:_rightImage];
        [operTop addSubview:_wrongImage];
        _myAnswer = [[UILabel alloc]initWithFrame:CGRectMake(62, 4, 97, 21)];
        _myAnswer.textColor = [UIColor darkGrayColor];
        _myAnswer.font = [UIFont systemFontOfSize:14];

        [operTop addSubview:_myAnswer];
    
        
        
        //操作按钮
        
        _preQuestion = [[UIButton alloc]initWithFrame:CGRectMake(13, 48, 76, 27)];
        [_preQuestion setBackgroundImage:[UIImage imageNamed:@"module_topic_nextbx.9.png"] forState:UIControlStateNormal];
        [_preQuestion setTitle:@"上一题" forState:UIControlStateNormal];
        [_preQuestion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _preQuestion.titleLabel.font = [UIFont systemFontOfSize:14];
        [_preQuestion addTarget:self action:@selector(prev) forControlEvents:UIControlEventTouchUpInside];
        
        _nextQuestion = [[UIButton alloc]initWithFrame:CGRectMake(224, 48, 76, 27)];
        [_nextQuestion setBackgroundImage:[UIImage imageNamed:@"module_topic_nextbx.9.png"] forState:UIControlStateNormal];
        [_nextQuestion setTitle:@"下一题" forState:UIControlStateNormal];
        [_nextQuestion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextQuestion.titleLabel.font = [UIFont systemFontOfSize:14];
        [_nextQuestion addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
        _smtBtn = [[UIButton alloc]initWithFrame:CGRectMake(122, 48, 76, 27)];
        [_smtBtn setBackgroundImage:[UIImage imageNamed:@"module_topic_midlebx.9.png"] forState:UIControlStateNormal];
        [_smtBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_smtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _smtBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_smtBtn addTarget:self action:@selector(smt) forControlEvents:UIControlEventTouchUpInside];
        
        [_operView addSubview:_preQuestion];
        [_operView addSubview:_nextQuestion];
        [_operView addSubview:_smtBtn];
        [_scrollView addSubview:_operView];
        [self addSubview:_scrollView];
    }
    return self;
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

- (void)smt
{
    if ([_delegate respondsToSelector:@selector(smtExam)]) {
        [_delegate smtExam];
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
