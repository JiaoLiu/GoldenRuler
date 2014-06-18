//
//  LSExamView.h
//  金标尺
//
//  Created by wzq on 14/6/12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Marco.h"
#import "LSQuestion.h"
#import "LSExamDelegate.h"

@interface LSExamView : UIView

@property (assign,nonatomic)    id<LSExamDelegate> delegate;
@property (strong, nonatomic)  UILabel *testType;
@property (strong, nonatomic)  UILabel *usedTime;
@property (strong, nonatomic)  UIButton *selectBtn;

@property (strong, nonatomic)  UIView *operView;
@property (strong, nonatomic)  UIButton *preQuestion;
@property (strong, nonatomic)  UIButton *nextQuestion;
@property (strong, nonatomic)  UIButton *currBtn;

@property (strong, nonatomic)  UITableView *questionView;
@property (strong, nonatomic)  UIScrollView *scrollView;

@property (strong, nonatomic)  UIButton *yellowBtn;
@property (strong, nonatomic)  UITextView *textView;
- (instancetype)initWithFrame:(CGRect)frame withQuestion:(LSQuestion *)question;
@end
