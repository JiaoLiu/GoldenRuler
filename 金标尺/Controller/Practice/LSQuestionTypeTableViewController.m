//
//  LSQuestionTypeTableViewController.m
//  金标尺
//
//  Created by wzq on 14/6/19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSQuestionTypeTableViewController.h"
#import "LSPractiseController.h"

@interface LSQuestionTypeTableViewController ()
{
    NSMutableArray *qTypeArray;
}
@end

@implementation LSQuestionTypeTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"题型选择";
    
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
    
    
    self.tableView.tableFooterView = [UIView new];
    
    if (IOS_VERSION > 7.0) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    qTypeArray = [NSMutableArray arrayWithCapacity:0];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [qTypeArray removeAllObjects];
    [self getQuestionType];
}


- (void)getQuestionType
{
    [SVProgressHUD showWithStatus:@"题型加载中..."];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/qtype?key=%d&uid=%d&tk=%@&cid=%@",[LSUserManager getKey],[LSUserManager getUid],_testType == LSWrapTypeSimulation ? @"1":@"2",_cid]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSArray *tempArray = [dic objectForKey:@"data"];
            NSInteger num = tempArray.count;
            
            if (num > 0) {
                [qTypeArray removeAllObjects];
            }
            
            for (int i = 0; i < num; i++)
            {
                NSDictionary *dic = [tempArray objectAtIndex:i];
                
                if (![qTypeArray containsObject:dic]) {
                    if ([[dic objectForKey:@"count"] intValue]>0 && ![qTypeArray containsObject:dic]) {
                         [qTypeArray addObject:dic];
                    }
                   
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99 && buttonIndex == 1) {
        LSPrivateChargeViewController *vc = [[LSPrivateChargeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return qTypeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (qTypeArray.count > 0) {
    
    
    NSString *count = [[qTypeArray objectAtIndex:indexPath.row] objectForKey:@"count"];
    NSString *mycount = [[qTypeArray objectAtIndex:indexPath.row] objectForKey:@"mycount"];
    NSString *percent = [[qTypeArray objectAtIndex:indexPath.row] objectForKey:@"percent"];
    

    cell.tag = [[[qTypeArray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    cell.textLabel.text = [[qTypeArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"题目数%@ 我的答题数%@ 正确率%.02f%%",count,mycount,percent.floatValue];
    cell.detailTextLabel.textColor = [UIColor grayColor];
        
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LSPractiseController *vc = [[LSPractiseController alloc]init];
    vc.cid = _cid;
    vc.tid = [NSString stringWithFormat:@"%d",cell.tag];
    vc.testType = _testType;
    vc.qTypeString = cell.textLabel.text;
    
    
//    if (![LSUserManager getIsVip] && _testType == LSWrapTypeReal) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您现在是普通会员不能做真题库联系，充值称为VIP会员才可以" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"马上充值", nil];
//        alert.tag = 99;
//        [alert show];
//        return;
//    }
    
    
    
    [self.navigationController pushViewController:vc animated:YES];

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
