//
//  LSPrivateCenterViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateCenterViewController.h"
#import "LSPrivateChargeViewController.h"
#import "LSPrivateInfoViewController.h"
#import "LSPrivateSettingViewController.h"
#import "LSMsgPushViewController.h"
#import "LSPrivateCommentViewController.h"
#import "LSPrivateCollectionViewController.h"
#import "LSPrivateErrorDBViewController.h"
#import "LSContestRankViewController.h"

#define LOGOUT_TAG 100

@interface LSPrivateCenterViewController ()
{
    NSArray *titleArray;
    UIImageView *headerImgView;
    UILabel *emailLabel;
    UILabel *vipLabel;
    UILabel *timeLabel;
    UIButton *addBtn;
}

@end

@implementation LSPrivateCenterViewController

@synthesize isVip;
@synthesize hasNotice;
@synthesize table;
@synthesize expireDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isVip = [LSUserManager getIsVip];
        if ([LSUserManager getEndTime].length == 0) {
            expireDate = [NSDate date];
        }
        else expireDate = [NSString dateFromString:[LSUserManager getEndTime] Formatter:@"yyy-MM-dd"];
        titleArray = @[@"我的资料管理",@"消息推送",@"我的收藏",@"我的错题库",@"排行榜",@"我的评论",@"我要充值",@"设置",@"退出登陆"];
        hasNotice = [LSUserManager getPush];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // HeaderView
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 80)];
    headerBackView.backgroundColor = RGB(243, 243, 243);
    headerBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    headerBackView.layer.borderWidth = 0.5;
    [self.view addSubview:headerBackView];
    
    headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    headerImgView.image = [LSUserManager getUserImg];
    headerImgView.layer.borderWidth = 1;
    headerImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    headerImgView.clipsToBounds = YES;
    [headerBackView addSubview:headerImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImgView.frame.origin.x + headerImgView.frame.size.width + 10, 5, headerBackView.frame.size.width - 80, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [LSUserManager getUserName];
    nameLabel.textColor = [UIColor grayColor];
    [headerBackView addSubview:nameLabel];
    
    emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 35, nameLabel.frame.size.width, 15)];
    emailLabel.backgroundColor = [UIColor clearColor];
    if ([LSUserManager getUserEmail].length != 0) {
        emailLabel.text = [NSString stringWithFormat:@"电子邮箱：%@",[LSUserManager getUserEmail]];
        emailLabel.hidden = NO;
    }
    else emailLabel.hidden = YES;
    emailLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    emailLabel.textColor = [UIColor grayColor];
    emailLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:emailLabel];
    
    // vip area
    vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 55, 65, 15)];
    vipLabel.textColor = [UIColor redColor];
    vipLabel.text = @"VIP贵宾会员";
    vipLabel.backgroundColor = [UIColor clearColor];
    vipLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:vipLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(vipLabel.frame.origin.x + vipLabel.frame.size.width, vipLabel.frame.origin.y, 110, 15)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd"];
    timeLabel.text = [NSString stringWithFormat:@"到期时间:%@",[formatter stringFromDate:expireDate]];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:timeLabel];
    
    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width, vipLabel.frame.origin.y, 50, 15)];
    [addBtn setTitle:@"【续期】" forState:UIControlStateNormal];
    [addBtn setTitleColor:RGB(4, 121, 202) forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:addBtn];
    
    if (!isVip) {
        vipLabel.text = @"普通会员";
        vipLabel.textColor = [UIColor grayColor];
        vipLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.hidden = YES;
        addBtn.frame = CGRectMake(vipLabel.frame.origin.x + vipLabel.frame.size.width - 20, vipLabel.frame.origin.y, 100, 15);
        [addBtn setTitle:@"【开通VIP会员】" forState:UIControlStateNormal];
    }
    
    NSInteger height = 35;
    table = [[UITableView alloc] initWithFrame:CGRectMake(10, headerBackView.frame.origin.y + headerBackView.frame.size.height + 7, SCREEN_WIDTH - 20, height * titleArray.count)];
    table.layer.borderColor = [UIColor lightGrayColor].CGColor;
    table.layer.borderWidth = 0.5;
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = height;
    [self.view addSubview:table];
    
    if (IOS_VERSION >= 7.0) {
        table.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    isVip = [LSUserManager getIsVip];
    if (isVip) {
        vipLabel.textColor = [UIColor redColor];
        vipLabel.font = [UIFont systemFontOfSize:11];
        vipLabel.text = @"VIP贵宾会员";
        timeLabel.hidden = NO;
        addBtn.frame = CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width, vipLabel.frame.origin.y, 50, 15);
        [addBtn setTitle:@"【续期】" forState:UIControlStateNormal];
    }
    else
    {
        vipLabel.text = @"普通会员";
        vipLabel.textColor = [UIColor grayColor];
        vipLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.hidden = YES;
        addBtn.frame = CGRectMake(vipLabel.frame.origin.x + vipLabel.frame.size.width - 20, vipLabel.frame.origin.y, 100, 15);
        [addBtn setTitle:@"【开通VIP会员】" forState:UIControlStateNormal];
    }
    hasNotice = [LSUserManager getPush];
    [table reloadData];
    headerImgView.image = [LSUserManager getUserImg];
    if ([LSUserManager getUserEmail].length != 0) {
        emailLabel.text = [NSString stringWithFormat:@"电子邮箱：%@",[LSUserManager getUserEmail]];
        emailLabel.hidden = NO;
    }
    else emailLabel.hidden = YES;
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
- (void)addBtnClicked
{
    LSPrivateChargeViewController *ChargeVC = [[LSPrivateChargeViewController alloc] init];
    ChargeVC.expireDate = expireDate;
    [self.navigationController pushViewController:ChargeVC animated:YES];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
        Cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
        Cell.textLabel.textColor = [UIColor grayColor];
        if (indexPath.row == 1) {
//            UILabel *pushNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 40, 35)];
//            pushNumLabel.textColor = [UIColor redColor];
//            pushNumLabel.backgroundColor = [UIColor clearColor];
//            pushNumLabel.textAlignment = NSTextAlignmentCenter;
//            pushNumLabel.tag = 100;
//            [Cell.contentView addSubview:pushNumLabel];
            UIImageView *notice = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 11, 49 / 2.0, 13)];
            notice.tag = 100;
            notice.image = [UIImage imageNamed:@"message_new"];
            notice.hidden = YES;
            [Cell.contentView addSubview:notice];
        }
    }
    
    if (indexPath.row == 1) {
        for (UIInputView *view in [Cell.contentView subviews]) {
            if (view.tag == 100 && hasNotice) {
                view.hidden = NO;
            }
        }
    }
    
    Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            LSPrivateInfoViewController *privateInfoVC = [[LSPrivateInfoViewController alloc] init];
            [self.navigationController pushViewController:privateInfoVC animated:YES];
        }
            break;
        case 1:
        {
            if ([LSUserManager RevPush]) {
                LSMsgPushViewController *msgPushVC = [[LSMsgPushViewController alloc] init];
                [self.navigationController pushViewController:msgPushVC animated:YES];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"请先开启消息推送"];
            }
        }
            break;
        case 2:
        {
            LSPrivateCollectionViewController *collectionVC = [[LSPrivateCollectionViewController alloc] init];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }
            break;
        case 3:
        {
            LSPrivateErrorDBViewController *errorVC = [[LSPrivateErrorDBViewController alloc] init];
            [self.navigationController pushViewController:errorVC animated:YES];
        }
            break;
        case 4:
        {
            LSContestRankViewController *rankVC = [[LSContestRankViewController alloc] init];
            [self.navigationController pushViewController:rankVC animated:YES];
        }
            break;
        case 5:
        {
            LSPrivateCommentViewController *commentVC = [[LSPrivateCommentViewController alloc] init];
            [self.navigationController pushViewController:commentVC animated:YES];
        }
            break;
        case 6:
        {
            [self addBtnClicked];
        }
            break;
        case 7:
        {
            LSPrivateSettingViewController *settingVC = [[LSPrivateSettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        case 8:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = LOGOUT_TAG;
            [alert show];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case LOGOUT_TAG:
        {
            if (buttonIndex == 1) {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APILogout stringByAppendingString:[NSString stringWithFormat:@"?key=%d&uid=%d",[LSUserManager getKey],[LSUserManager getUid]]]]];
                NSOperationQueue *queue = [NSOperationQueue currentQueue];
                [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    NSDictionary *dic = [data mutableObjectFromJSONData];
                    NSLog(@"%@",[dic objectForKey:@"msg"]);
                    [LSUserManager setIsLogin:NO];
                    [LSUserManager setTCid:0];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckLogin" object:nil];
                    //                NSInteger ret = [[dic objectForKey:@"status"] integerValue];
                    //                if (ret == 1 || ret == 0) {
                    //                    [LSUserManager setIsLogin:NO];
                    //                    [self.navigationController popToRootViewControllerAnimated:YES];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckLogin" object:nil];
                    //                }
                    //                else
                    //                {
                    //                    [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
                    //                }
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
