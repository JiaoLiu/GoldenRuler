//
//  LSTestViewController.h
//  金标尺
//
//  Created by wzq on 14/6/13.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCommentsView.h"
#import "LSCorrectionView.h"
#import "LSExamDelegate.h"
#import "LSExam.h"
#import "LSQuestion.h"
#import "UITextViewWithPlaceholder.h"
#import "LSExamView.h"
#import "LSComments.h"
#import "LSContestView.h"
#import "LSChooseQuestionViewController.h"
#import "LSTestResultViewController.h"

@interface LSTestViewController : UIViewController<UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, LSCorrectionDelegate, LSCommentsDelegate, LSExamDelegate,UIAlertViewDelegate,LSChooseQuestionDelegate,LSTestResultViewDelegate>

@property (nonatomic,strong) LSExam *exam;
@property (nonatomic,strong) NSMutableArray *questionList;
@property (nonatomic,strong) LSQuestion *currQuestion;
@property (nonatomic) LSWrapType examType;
@end
