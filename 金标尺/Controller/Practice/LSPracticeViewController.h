//
//  LSPracticeViewController.h
//  金标尺
//
//  Created by wzq on 14/6/4.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSQuestionView.h"
#import "LSComments.h"


@interface LSPracticeViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *testType;
@property (weak, nonatomic) IBOutlet UILabel *usedTime;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *preQuestion;
@property (weak, nonatomic) IBOutlet UIButton *nextQuestion;
@property (weak, nonatomic) IBOutlet UIButton *currBtn;
//@property (weak,nonatomic) IBOutlet UIView *uiview;
@property (weak, nonatomic) IBOutlet UITableView *questionView;

@property (weak, nonatomic) IBOutlet UIView *operView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *yellowBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;




@end
