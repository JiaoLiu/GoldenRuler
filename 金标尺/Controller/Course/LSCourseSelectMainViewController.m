//
//  LSCourseSelectMainViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-22.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSCourseSelectMainViewController.h"

@interface LSCourseSelectMainViewController ()
{
    NSArray *titleArray;
    NSInteger selectedRow;
}

@end

@implementation LSCourseSelectMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        titleArray = @[@"综合基础知识",@"综合基础知识",@"综合基础知识",@"综合基础知识"];
        selectedRow = titleArray.count;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课程选择";
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

    NSInteger height = 35;
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, titleArray.count * height + 30)];
    table.rowHeight = height;
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    table.editing = YES;
    [table setEditing:YES animated:YES];
    [self.view addSubview:table];
    
    if (IOS_VERSION >= 7.0) {
        table.separatorInset = UIEdgeInsetsZero;
    }
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

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    Cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    return Cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:NO];
    selectedRow = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedRow == indexPath.row) {
        selectedRow = titleArray.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 20)];
    label.text = @"  请开启您要练习的课程";
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.backgroundColor = [UIColor clearColor];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, 0.5)];
    separator.backgroundColor = [UIColor lightGrayColor];
    [label addSubview:separator];
    
    return label;
}

@end
