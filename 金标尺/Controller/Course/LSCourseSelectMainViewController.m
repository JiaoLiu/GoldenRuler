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
    NSMutableArray *titleArray;
    NSInteger selectedRow;
}

@end

@implementation LSCourseSelectMainViewController

@synthesize courseTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
//        titleArray = @[@"综合基础知识",@"综合基础知识",@"综合基础知识",@"综合基础知识"];
        selectedRow = -1;
        [SVProgressHUD showWithStatus:@"加载中"];
        titleArray = [[NSMutableArray alloc] init];
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/getCate?key=%d&uid=%d&tid=1&cid=0",[LSUserManager getKey],[LSUserManager getUid]]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSArray *tempArray = [dic objectForKey:@"data"];
            NSInteger num = tempArray.count;
            for (int i = 0; i < num; i++) {
                NSDictionary *dic = [tempArray objectAtIndex:i];
                if (![titleArray containsObject:dic]) {
                    [titleArray addObject:dic];
                }
            }
            [courseTable reloadData];
            [courseTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[LSUserManager getTCid] - 1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            selectedRow = [LSUserManager getTCid] - 1;
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
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

    courseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT)];
    courseTable.rowHeight = 35;
    courseTable.scrollEnabled = NO;
    courseTable.delegate = self;
    courseTable.dataSource = self;
    courseTable.editing = YES;
    courseTable.tableFooterView = [UIView new];
    [courseTable setEditing:YES animated:YES];
    [self.view addSubview:courseTable];
    
    if (IOS_VERSION >= 7.0) {
        courseTable.separatorInset = UIEdgeInsetsZero;
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
    [SVProgressHUD dismiss];
    if (selectedRow != -1) {
        [LSUserManager setTCid:[[[titleArray objectAtIndex:selectedRow] objectForKey:@"cid"] intValue]];
    }
    else
    {
        [LSUserManager setTCid:0];
    }
}

- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
    if (selectedRow != -1) {
        [LSUserManager setTCid:[[[titleArray objectAtIndex:selectedRow] objectForKey:@"cid"] intValue]];
    }
    else
    {
        [LSUserManager setTCid:0];
    }
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
    
    Cell.textLabel.text = [[titleArray objectAtIndex:indexPath.row] objectForKey:@"name"];
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
        selectedRow = -1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 20)];
    label.text = @"  请开启您要练习的课程";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.backgroundColor = [UIColor clearColor];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, 0.5)];
    separator.backgroundColor = [UIColor lightGrayColor];
    [label addSubview:separator];
    
    return label;
}

@end
