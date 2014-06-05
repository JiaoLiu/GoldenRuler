//
//  LSMsgPushViewController.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-21.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMsgPushViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *msgTable;

@end
