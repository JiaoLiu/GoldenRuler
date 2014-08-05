//
//  LSExamView.m
//  金标尺
//
//  Created by wzq on 14/6/12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSExamView.h"



@implementation LSExamView

- (instancetype)initWithFrame:(CGRect)frame withQuestion:(LSQuestion *)question withIndex:(int)index
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
        switch ([question.tid integerValue]) {
            case kSingleChoice:
                _testType.text = @"[单选题]";
                break;
            case kMultipleChoice:
                _testType.text = @"[多选题]";
                break;
            case kJudge:
                _testType.text = @"[判断题]";
                break;
            case kBlank:
                _testType.text = @"[填空题]";
                break;
            case kSimpleAnswer:
                _testType.text = @"[简答题]";
                break;
            case kDiscuss:
                _testType.text = @"[论述题]";
                break;
                
            default:
                break;
        }
        _testType.backgroundColor = [UIColor clearColor];
        
        _usedTime = [[UILabel alloc]initWithFrame:CGRectMake(108, 0, 100, 31)];
        _usedTime.textAlignment = NSTextAlignmentCenter;
        _usedTime.font = [UIFont systemFontOfSize:14];
        _usedTime.textColor = [UIColor darkGrayColor];
        _usedTime.text = @"已用时 12:33";
        
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(241, 0, 79, 31)];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"exercise_top_right_bg2.9.png"] forState:UIControlStateNormal];
        [_selectBtn setTitle:@"0/0" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(chooseQuestion) forControlEvents:UIControlEventTouchUpInside];
        [ttView addSubview:_testType];
        [ttView addSubview:_selectBtn];
        
        
        [_scrollView addSubview:ttView];
        
        
        CGRect frame = CGRectMake(10, 0, 0, 0);
        CGSize size = [question.title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        frame.size = size;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];//题目描述label
        label.text = [NSString stringWithFormat:@"%d.%@",index,question.title];
        
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont systemFontOfSize:14];
        UIView *hv = [[UIView alloc]initWithFrame:frame];
        [hv addSubview:label];
        
        NSArray *answers = [question.answer componentsSeparatedByString:@"|"];
        CGFloat height = 0;
        for (int i = 0 ; i < answers.count; i++) {
            NSString *asContent = [answers objectAtIndex:i];
            CGSize rect = [asContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            height += rect.height + 20;
        }
        
        //考题view
        _questionView  = [[UITableView alloc]initWithFrame:CGRectMake(0, ttView.frame.origin.y + ttView.frame.size.height, SCREEN_WIDTH, height + hv.frame.size.height+20) style:UITableViewStylePlain];
//        _questionView.delegate = self;
//        _questionView.dataSource = self;
        if ([question.tid integerValue] == kBlank) {
            _questionView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _questionView.frame = CGRectMake(0, 31, SCREEN_WIDTH, 35*4 + hv.frame.size.height > 210 ? 140+hv.frame.size.height : 210);
        }
        _questionView.editing = YES;
        _questionView.tableHeaderView = hv;
        _questionView.tableFooterView = [UIView new];
//        _questionView.frame = CGRectMake(0, 31, SCREEN_WIDTH, 35*4 + hv.frame.size.height > 210 ? 140+hv.frame.size.height : 210);
        [_scrollView addSubview:_questionView];
        
        
        
        
        _operView = [[UIView alloc]initWithFrame:CGRectMake(0, _questionView.frame.size.height + _questionView.frame.origin.y, SCREEN_WIDTH, 100)];
        _operView.backgroundColor = RGB(240, 240, 240);
        
        _operTop = [[UIView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 46)];
        _operTop.backgroundColor = [UIColor whiteColor];

        [_operView addSubview:_operTop];
        _rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nx_go.png"]];
        _rightImage.frame = CGRectMake(20, 6, 19, 18);
        _wrongImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nx_c.png"]];
        _wrongImage.frame = CGRectMake(20, 6, 19, 18);
        [_wrongImage setHidden:YES];
        [_rightImage setHidden:YES];
        
        [_operTop addSubview:_rightImage];
        [_operTop addSubview:_wrongImage];
        _operTop.clipsToBounds = YES;
        
        _myAnswer = [[UILabel alloc]initWithFrame:CGRectMake(42, 4, 210, 21)];
        _myAnswer.textColor = [UIColor darkGrayColor];
        _myAnswer.font = [UIFont systemFontOfSize:14];
        _myAnswer.text = @"你的答案:A";
        _myAnswer.backgroundColor = [UIColor clearColor];
        [_myAnswer setHidden:YES];
        [_operTop addSubview:_myAnswer];
//        [_operTop setHidden:YES];
        
        _rtAnswer = [[UILabel alloc]initWithFrame:CGRectMake(42, 24, 210, 21)];
        _rtAnswer.textColor = [UIColor darkGrayColor];
        _rtAnswer.font = [UIFont systemFontOfSize:14];
        _rtAnswer.text = [NSString stringWithFormat:@"正确答案:%@",question.right];
        _rtAnswer.backgroundColor = [UIColor clearColor];
        [_rtAnswer setHidden:YES];
        [_operTop addSubview:_rtAnswer];
        
        
        //操作按钮
        
        _preQuestion = [[UIButton alloc]initWithFrame:CGRectMake(13, 18, 76, 27)];
        [_preQuestion setBackgroundImage:[UIImage imageNamed:@"nx_btna.9.png"] forState:UIControlStateNormal];
        [_preQuestion setTitle:@"上一题" forState:UIControlStateNormal];
        [_preQuestion setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _preQuestion.titleLabel.font = [UIFont systemFontOfSize:14];
//        _preQuestion.layer.borderColor = [UIColor darkGrayColor].CGColor;
//        _preQuestion.layer.borderWidth = 0.5;
//        _preQuestion.layer.cornerRadius = 4;
        [_preQuestion addTarget:self action:@selector(prev) forControlEvents:UIControlEventTouchUpInside];
        
        _nextQuestion = [[UIButton alloc]initWithFrame:CGRectMake(224, 18, 76, 27)];
        [_nextQuestion setBackgroundImage:[UIImage imageNamed:@"nx_btna.9.png"] forState:UIControlStateNormal];
        [_nextQuestion setTitle:@"下一题" forState:UIControlStateNormal];
        [_nextQuestion setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _nextQuestion.titleLabel.font = [UIFont systemFontOfSize:14];
        [_nextQuestion addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
        _currBtn = [[UIButton alloc]initWithFrame:CGRectMake(122, 18, 76, 27)];
        [_currBtn setBackgroundImage:[UIImage imageNamed:@"nx_btnb.9.png"] forState:UIControlStateNormal];
        
//        if ([_testType.text isEqualToString:@"[单选题]"] || [_testType.text isEqualToString:@"[判断题]"] || [_testType.text isEqualToString:@"[简答题]"] || [_testType.text isEqualToString:@"[论述题]"])
//        {
//            [_currBtn setTitle:@"0/0" forState:UIControlStateNormal];
//        }
//        else if ([_testType.text isEqualToString:@"[多选题]"])
//        {
            if (question.myAser != nil && ![question.myAser isEqualToString:@""]) {
//                [_currBtn setHidden:YES];
                [_currBtn setEnabled:NO];
            }else
            {
                [_currBtn setEnabled:YES];
            }
            _currBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            [_currBtn setTitle:@"答案及解析" forState:UIControlStateNormal];
            [_currBtn setTitle:@"答案及解析" forState:UIControlStateDisabled];
            [_currBtn setTitleColor:RGB(4, 121, 202) forState:UIControlStateNormal];
            [_currBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            [_currBtn addTarget:self action:@selector(smtAnswer) forControlEvents:UIControlEventTouchUpInside];
//        }
        if ([_testType.text isEqualToString:@"[填空题]"])
        {
            if (question.myAser != nil) {
                //                [_currBtn setHidden:YES];
                [_currBtn setEnabled:NO];
            }
            [_currBtn setTitle:@"答案及解析" forState:UIControlStateNormal];
            [_currBtn setTitle:@"答案及解析" forState:UIControlStateDisabled];
            [_currBtn setTitleColor:RGB(4, 121, 202) forState:UIControlStateNormal];
            [_currBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            
            [_currBtn addTarget:self action:@selector(smtAnswer) forControlEvents:UIControlEventTouchUpInside];
            
            //输入框
            _textFiled = [[UITextField alloc]init];
            _textFiled.placeholder =@"输入您的答案";
            _operView.frame = CGRectMake(_operView.frame.origin.x, _operView.frame.origin.y-80, _operView.frame.size.width, _operView.frame.size.height);
            _textFiled.frame = CGRectMake(10, _questionView.tableHeaderView.frame.origin.y + _questionView.tableHeaderView.frame.size.height+40,260, 40);
            _textFiled.backgroundColor = [UIColor whiteColor];
            [_scrollView addSubview:_textFiled];
            
        }
//        else
//        {
//        
//            if (question.myAser != nil) {
//                //                [_currBtn setHidden:YES];
//                [_currBtn setEnabled:NO];
//            }
//            [_currBtn setTitle:@"提交" forState:UIControlStateNormal];
//            [_currBtn setTitle:@"已提交" forState:UIControlStateDisabled];
//            [_currBtn addTarget:self action:@selector(smtAnswer) forControlEvents:UIControlEventTouchUpInside];
//            
//            //输入框
//            _answerView = [[UITextView alloc]init];
//            _answerView.frame = CGRectMake(hv.frame.origin.x, hv.frame.origin.y+hv.frame.size.height, hv.frame.size.width, 100);
//            [self addSubview:_answerView];
//        }
        
        
//        [_currBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _currBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_operView addSubview:_preQuestion];
        [_operView addSubview:_nextQuestion];
        [_operView addSubview:_currBtn];
        [_scrollView addSubview:_operView];
        
        
        _yellowBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, _operView.frame.origin.y + _operView.frame.size.height + 10, 76, 27)];
        [_yellowBtn setBackgroundImage:[UIImage imageNamed:@"nx_bg.9.png"] forState:UIControlStateNormal];
        [_yellowBtn setBackgroundImage:[UIImage imageNamed:@"nx_bg.9.png"] forState:UIControlStateDisabled];
        [_yellowBtn setTitle:@"查看解析" forState:UIControlStateNormal];
        [_yellowBtn setTitle:@"习题解析" forState:UIControlStateDisabled];
        
        [_yellowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _yellowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_yellowBtn addTarget:self action:@selector(showAnalysis) forControlEvents:UIControlEventTouchUpInside];
        [_yellowBtn setHidden:YES];
        
        _yellowBtn.enabled = [LSUserManager getIsVip] ? NO : YES;
        [_scrollView addSubview:_yellowBtn];
        
        
        if ([question.tid integerValue] == kSimpleAnswer || [question.tid integerValue]==kDiscuss)
        {
            CGRect frame = _yellowBtn.frame;
            frame.origin.y -= 40;
            _yellowBtn.frame = frame;
        }
        
        
        
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
//        [_currBtn setEnabled:NO];
    }

}

- (void)showAnalysis
{
    if ([_delegate respondsToSelector:@selector(showAnalysis)]) {
        [_delegate showAnalysis];
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

- (void)chooseQuestion
{
    if ([_delegate respondsToSelector:@selector(chooseQuestion)]) {
        [_delegate chooseQuestion];
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
