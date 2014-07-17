//
//  LSQuestionTypeTableViewController.h
//  金标尺
//
//  Created by wzq on 14/6/19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSQuestionTypeTableViewController : UITableViewController<UIAlertViewDelegate>
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,assign) LSWrapType testType;
@end
