//
//  LSMsgPushViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-21.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSMsgPushViewController.h"
#import "LSMsgDetailViewController.h"
#import "LSSheetNotify.h"

@interface LSMsgPushViewController ()
{
    NSMutableArray *dataArray;
    NSInteger msgPage;
}

@end

@implementation LSMsgPushViewController

@synthesize msgTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        dataArray = [[NSMutableArray alloc] init];
        msgPage = 1;
        [self loadDataWithPage:msgPage size:0];
        [SVProgressHUD showWithStatus:@"加载中"];
    }
    return self;
}

- (void)loadDataWithPage:(int)page size:(int)pageSize
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/pushMsg?key=%d&uid=%d&page=%d&pagesize=%d",[LSUserManager getKey],[LSUserManager getUid],page,pageSize]]]];
    if (pageSize == 0) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/pushMsg?key=%d&uid=%d&page=%d",[LSUserManager getKey],[LSUserManager getUid],page]]]];
    }
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSArray *tempArray = [dic objectForKey:@"data"];
            NSInteger num = tempArray.count;
            if (num >= pageSize) {
                msgPage += 1;
                [LSSheetNotify dismiss];
            }
            else
            {
                [LSSheetNotify showOnce:@"暂无更多消息"];
            }
            for (int i = 0; i < num; i++) {
                NSDictionary *dic = [tempArray objectAtIndex:i];
                if (![dataArray containsObject:dic]) {
                    [dataArray addObject:dic];
                }
            }
            [msgTable reloadData];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
//    for (int i = 0; i < 100; i++) {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"2014-%d年第一季度公务员考试开始拉",i],@"title",@"2014年4月24 10:21:34",@"time", nil];
//        [dataArray insertObject:dic atIndex:i];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息推送";
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
    
    // msgTable
    msgTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT - 20)];
    msgTable.delegate = self;
    msgTable.dataSource = self;
    msgTable.tableFooterView = [UIView new];
    msgTable.rowHeight = 50;
    [self.view addSubview:msgTable];
    
    if (IOS_VERSION >= 7.0) {
        msgTable.separatorInset = UIEdgeInsetsZero;
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
    [LSSheetNotify dismiss];
}

- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
    [LSSheetNotify dismiss];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    Cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    Cell.detailTextLabel.text = [NSString stringWithFormat:@"推送时间：%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] ];
    Cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [LSSheetNotify dismiss];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LSMsgDetailViewController *detailVC = [[LSMsgDetailViewController alloc] init];
    detailVC.msgTitle = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    detailVC.msgUrl = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"url"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y > 50) {
        [self loadDataWithPage:msgPage size:10];
        [LSSheetNotify showProgress:@"加载更多"];
    }
}

@end
