//
//  LSTestResultViewController.h
//  金标尺
//
//  Created by wzq on 14/6/26.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTabBar.h"

@protocol LSTestResultViewDelegate <NSObject>

- (void)redoExam;
- (void)checkAnalysis;

@end

@interface LSTestResultViewController : UIViewController<LSTabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) id<LSTestResultViewDelegate> delegate;
@property (nonatomic) int myscore;
@property (nonatomic) int totalscore;
@property (nonatomic) int time;
@property (nonatomic) int usedtime;

@property (nonatomic) int examId;//考试id 获取统计数据
@property (nonatomic) int mid;

@property (nonatomic,strong) UITableView *tableView;

@end
