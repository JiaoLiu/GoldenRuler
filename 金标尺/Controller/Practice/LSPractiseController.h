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

@interface LSPractiseController : UIViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *tid;
@property (nonatomic,assign) LSWrapType testType;
@end
