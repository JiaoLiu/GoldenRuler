//
//  LSChooseQuestionViewController.h
//  金标尺
//
//  Created by wzq on 14/6/27.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSChooseQuestionDelegate <NSObject>

- (void)seletedQuestion:(int)index;

@end

@interface LSChooseQuestionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *questions;
@property (nonatomic,assign) id<LSChooseQuestionDelegate> delegate;
@property (nonatomic,strong) UITableView *tableView;
@end
