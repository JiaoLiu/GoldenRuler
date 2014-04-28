//
//  LSCourseRecommendViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-27.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSCourseRecommendViewController.h"

@interface LSCourseRecommendViewController ()

@end

@implementation LSCourseRecommendViewController

@synthesize courseTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课程推荐";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // homeBtn
    UIButton *homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [homeBtn addTarget:self action:@selector(homeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    //tabBar
    LSTabBar *tabBar = [[LSTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    tabBar.items = @[@"推荐课程",@"热门课程"];
    tabBar.selectedItem = 0;
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    
    //courseTable
    courseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, tabBar.frame.origin.y + tabBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 36)];
    courseTable.delegate = self;
    courseTable.dataSource =self;
    courseTable.rowHeight = 50;
    courseTable.tableFooterView = [UIView new];
    if (IOS_VERSION >= 7.0) {
        courseTable.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:courseTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - handleBtnClicked
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - tabbar Delegate
- (void)SelectItemAtIndex:(NSNumber *)index
{
    NSLog(@"%d",[index integerValue]);
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    Cell.textLabel.text = @"2014重庆公共基础模拟题";
    Cell.detailTextLabel.text = @"授课时间。。。。 招生人数：200人";
    Cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return Cell;
}

@end
