//
//  LSPractiseController.h
//  金标尺
//
//  Created by wzq on 14/6/19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSQuestionView.h"
#import "LSComments.h"
#import "LSExamDelegate.h"
#import "LSCommentsView.h"
#import "LSExamView.h"
#import "LSCorrectionView.h"

@interface LSPractiseController : UIViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,LSExamDelegate,LSCommentsDelegate,LSCorrectionDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *tid;
@property (nonatomic,assign) LSWrapType testType;
@property (nonatomic,strong) NSString *qTypeString;

@property (nonatomic) BOOL isContinue;


@end
