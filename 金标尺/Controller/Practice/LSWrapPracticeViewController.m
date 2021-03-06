//
//  LSWrapPracticeViewController.m
//  金标尺
//
//  Created by wzq on 14/6/5.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSWrapPracticeViewController.h"
#import "LSWrapInfoViewController.h"
#import "LSCityViewController.h"

@interface LSWrapPracticeViewController ()
{
    NSArray *courseArray;
    LSWrapType testType;
    UITableView *table;
}
@end

@implementation LSWrapPracticeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0)
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        courseArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"套卷测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    // filterBtn
//    UIButton *filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
//    [filterBtn addTarget:self action:@selector(filterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [filterBtn setTitle:@"筛选"forState:UIControlStateNormal];
    
    
    // homeBtn
    UIButton *homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [homeBtn addTarget:self action:@selector(homeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;


    
//    
//    //tabBar
//    LSTabBar *tabBar = [[LSTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
//    tabBar.items = @[@"模拟试题",@"历年真题"];
//    tabBar.selectedItem = 0;
//    testType = LSWrapTypeSimulation;
//    tabBar.delegate = self;
//    [self.view addSubview:tabBar];
//    
    
    courseArray = @[@"模拟套卷测试",@"真题套卷测试"];
    
    NSInteger height = 44;
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.view.bounds.size.height)];
    table.rowHeight = height;
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [UIView new];
    [self.view addSubview:table];
    if (IOS_VERSION >= 7.0) {
        table.separatorInset = UIEdgeInsetsZero;
    }
    
//    [self getCourses];

}

//- (void)getCourses
//{
//    [SVProgressHUD showWithStatus:@"科目加载中..."];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/getCate?key=%d&uid=%d&tid=1&cid=%d",[LSUserManager getKey],[LSUserManager getUid],[LSUserManager getTCid]]]]];
//    NSOperationQueue *queue = [NSOperationQueue currentQueue];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *dic = [data mutableObjectFromJSONData];
//        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
//        if (ret == 1) {
//            NSLog(@"dic:%@",dic);
//            
//            NSArray *tempArray = [dic objectForKey:@"data"];
//            NSInteger num = tempArray.count;
//            for (int i = 0; i < num; i++)
//            {
//                NSDictionary *dic = [tempArray objectAtIndex:i];
//                if (![courseArray containsObject:dic]) {
//                    [courseArray addObject:dic];
//                }
//                
//            }
//            [table reloadData];
//            [SVProgressHUD dismiss];
//        }
//        else
//        {
//            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
//        }
//    }];
//    
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"practiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
//    NSString *name = [[courseArray objectAtIndex:indexPath.row] objectForKey:@"name"];
//    int cid = [[[courseArray objectAtIndex:indexPath.row] objectForKey:@"cid"] intValue];
//    cell.textLabel.text = name;
//    cell.tag = cid;
    cell.textLabel.text = [courseArray objectAtIndex:indexPath.row];
    
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int cid = [tableView cellForRowAtIndexPath:indexPath].tag;
    
    switch (indexPath.row) {
        case 0:
        {
            LSWrapInfoViewController *vc = [[LSWrapInfoViewController alloc]init];
            vc.wrapType = LSWrapTypeSimulation;
            vc.cid = [LSUserManager getTCid];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {

            LSCityViewController *vc = [[LSCityViewController alloc]init];
//            vc.cid = cid;
            vc.cid = [LSUserManager getTCid];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
            
        default:
            break;
    }
}



#pragma mark -| nav btn click
- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
    [LSSheetNotify dismiss];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)filterBtnClicked
{
    NSLog(@"filterBtnClicked");
}

//#pragma mark -tabbar delegate
//- (void)SelectItemAtIndex:(NSNumber *)index{
//    switch (index.intValue) {
//        case 0:
//            testType = LSWrapTypeSimulation;
//            break;
//        case 1:
//            testType = LSWrapTypeReal;
//            break;
//        default:
//            break;
//    }
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
