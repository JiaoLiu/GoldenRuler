//
//  LSCourseTableViewController.h
//  金标尺
//
//  Created by wzq on 14/6/19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTabBar.h"

@interface LSCourseTableViewController : UIViewController<LSTabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@end
