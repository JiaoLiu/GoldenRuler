//
//  LSContestViewController.h
//  金标尺
//
//  Created by wzq on 14/6/10.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSContestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *testType;
@property (weak, nonatomic) IBOutlet UILabel *usedTime;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
//@property (weak,nonatomic) IBOutlet UIView *uiview;
@property (weak, nonatomic) IBOutlet UITableView *questionView;

@property (weak, nonatomic) IBOutlet UIView *operView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)prevQuestion:(id)sender;
- (IBAction)nextQuestion:(id)sender;
- (IBAction)smtExam:(id)sender;


@end
