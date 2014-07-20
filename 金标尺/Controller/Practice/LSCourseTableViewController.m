//
//  LSCourseTableViewController.m
//  金标尺
//
//  Created by wzq on 14/6/19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSCourseTableViewController.h"
#import "LSQuestionTypeTableViewController.h"
#import "LSPrivateChargeViewController.h"

@interface LSCourseTableViewController ()
{
    NSMutableArray *courseArray;
    LSWrapType testType;
}
@end



@implementation LSCourseTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"课程选择";
    
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
    tabBar.items = @[@"模拟试题",@"历年真题"];
    tabBar.selectedItem = 0;
    testType = LSWrapTypeSimulation;
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tabBar.frame.origin.y + tabBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    courseArray = [NSMutableArray arrayWithCapacity:0];
    self.tableView.tableFooterView = [UIView new];
    if (IOS_VERSION >= 7.0) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    [self getCourses];
}




- (void)getCourses
{
    [SVProgressHUD showWithStatus:@"科目加载中..."];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/getCate?key=%d&uid=%d&tid=1&cid=%d",[LSUserManager getKey],[LSUserManager getUid],[LSUserManager getTCid]]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSLog(@"dic:%@",dic);
            
            NSArray *tempArray = [dic objectForKey:@"data"];
            NSInteger num = tempArray.count;
            for (int i = 0; i < num; i++)
            {
                NSDictionary *dic = [tempArray objectAtIndex:i];
                if (![courseArray containsObject:dic]) {
                    [courseArray addObject:dic];
                }

            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];

}





#pragma mark -tabbar delegate
- (void)SelectItemAtIndex:(NSNumber *)index{
    switch (index.intValue) {
        case 0:
            testType = LSWrapTypeSimulation;
            break;
        case 1:
            testType = LSWrapTypeReal;
            if (![LSUserManager getIsVip]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您现在是普通会员不能做真题库联系，充值成为VIP会员才可以" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上充值", nil];
                alert.tag = 99;
                [alert show];
                return;
            }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99 && buttonIndex ==1)
    {
        //充值
        LSPrivateChargeViewController *vc = [[LSPrivateChargeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return courseArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = [[[courseArray objectAtIndex:indexPath.row] objectForKey:@"cid"] intValue];
    cell.textLabel.text = [[courseArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSQuestionTypeTableViewController *typeVC = [[LSQuestionTypeTableViewController alloc]initWithStyle:UITableViewStylePlain];
    typeVC.testType = testType;
    typeVC.cid = [[courseArray objectAtIndex:indexPath.row] objectForKey:@"cid"];
    [self.navigationController pushViewController:typeVC animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -| nav btn click
- (void)homeBtnClicked
{
    [SVProgressHUD dismiss];
    [LSSheetNotify dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)backBtnClicked
{
    [SVProgressHUD dismiss];
    [LSSheetNotify dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
