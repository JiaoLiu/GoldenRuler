//
//  LSPrivateSettingViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-21.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateSettingViewController.h"
#import "LSPrivateFeedbackViewController.h"
#import "LSPrivateAboutViewController.h"

@interface LSPrivateSettingViewController ()
{
    NSArray *titleArray;
}

@end

@implementation LSPrivateSettingViewController

@synthesize updateUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArray = @[@"消息推送",@"意见反馈",@"关于",@"版本更新检测"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // tableView
    NSInteger height = 35;
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, titleArray.count * height)];
    table.rowHeight = height;
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    
    if (IOS_VERSION >= 7.0) {
        table.separatorInset = UIEdgeInsetsZero;
    }
    
    // copyrightLabel
    UILabel *copyRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, table.frame.origin.y + table.frame.size.height + 20, SCREEN_WIDTH, 40)];
    copyRightLabel.text = [NSString stringWithFormat:@"©2014 金标尺版权所有\n当前版本V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    copyRightLabel.textColor = [UIColor lightGrayColor];
    copyRightLabel.font = [UIFont systemFontOfSize:13.0];
    copyRightLabel.numberOfLines = 0;
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    copyRightLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:copyRightLabel];
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

- (void)switchBtnClicked:(UISwitch *)sender
{
    NSLog(@"%@",sender.isOn ? @"On" : @"Off");
    if (sender.isOn) {
        [LSUserManager setRevPush:TRUE];
    }
    else{
        [LSUserManager setRevPush:FALSE];
    }
}

- (void)checkVersion
{
    NSString *curVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Index/updateApp?client=apple&version=%@",curVer]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        [SVProgressHUD dismiss];
        if (ret == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (ret == 2) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[dic objectForKey:@"msg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                updateUrl = [dic objectForKey:@"data"];
            }
            else [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
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
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        Cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(Cell.frame.size.width - 70 , 0, 50, 35)];
                if (IOS_VERSION < 7.0) {
                    CGRect frame = switchBtn.frame;
                    frame.origin.x -= 20;
                    switchBtn.frame = frame;
                }
                [switchBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventValueChanged];
                switchBtn.on = [LSUserManager RevPush] ? TRUE : FALSE;
                [Cell.contentView addSubview:switchBtn];
            }
                break;
            case 1:
            {
                Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 2:
            {
                Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 3:
            {
//                Cell.detailTextLabel.text = [NSString stringWithFormat:@"最新版本号V%@",@"4.2.4"];
//                Cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
//                Cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
                
            default:
                break;
        }
    }
    
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            LSPrivateFeedbackViewController *feedbackVC = [[LSPrivateFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case 2:
        {
            LSPrivateAboutViewController *aboutVC = [[LSPrivateAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case 3:
        {
            [self checkVersion];
            [SVProgressHUD showWithStatus:@"检测中..." maskType:SVProgressHUDMaskTypeBlack];
        }
            break;
        default:
            break;
    }
}

@end
