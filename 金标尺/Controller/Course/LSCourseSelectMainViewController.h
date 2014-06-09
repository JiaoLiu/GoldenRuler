//
//  LSCourseSelectMainViewController.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-22.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSCourseSelectMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *courseTable;

@end
