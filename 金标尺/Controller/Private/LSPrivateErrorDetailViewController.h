//
//  LSPrivateErrorDetailViewController.h
//  金标尺
//
//  Created by Jiao on 14-6-24.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSExamView.h"
#import "LSQuestion.h"

@interface LSPrivateErrorDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign)NSInteger qid;
@property (nonatomic, strong)LSQuestion *question;

@end
