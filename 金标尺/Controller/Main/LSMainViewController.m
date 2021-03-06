//
//  LSMainViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSMainViewController.h"
#import "LSWrapPracticeViewController.h"
#import "LSPrivateErrorDBViewController.h"
#import "LSCourseTableViewController.h"
#import "LSPractiseController.h"

@interface LSMainViewController ()
{
    UIImageView *newMsg;
    Reachability *reach;
}

@end

@implementation LSMainViewController

@synthesize itemsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        itemsArray = @[@{@"title": @"继续上次练习" ,@"img": @"index_a" ,@"color": RGB(20, 180, 242)},
                       @{@"title": @"我的收藏" ,@"img": @"index_b" ,@"color": RGB(239, 156, 36)},
                       @{@"title": @"模块练习" ,@"img": @"index_c" ,@"color": RGB(93, 167, 70)},
                       @{@"title": @"套卷测试" ,@"img": @"index_d" ,@"color": RGB(37, 189, 212)},
                       @{@"title": @"每日精选" ,@"img": @"index_e" ,@"color": RGB(239, 156, 36)},
                       @{@"title": @"课程推荐" ,@"img": @"index_f" ,@"color": RGB(104, 191, 76)}];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CheckLogin) name:@"CheckLogin" object:nil];
        reach = [Reachability reachabilityForInternetConnection];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"重庆事业单位";
    
    // selectionBtn
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, NavigationBar_HEIGHT)];
    [selectBtn setTitle:@"选课" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // infoBtn
    UIButton *infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [infoBtn addTarget:self action:@selector(infoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"index_topr"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // incorrectBtn
    UIButton *incorrectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 + 18.5 / 2, 0, 31.5, 129.5)];
    [incorrectBtn setBackgroundImage:[UIImage imageNamed:@"index_msg"] forState:UIControlStateNormal];
    [incorrectBtn addTarget:self action:@selector(incorrectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:incorrectBtn];
    UILabel *incorrectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, incorrectBtn.frame.size.width, incorrectBtn.frame.size.height - 40)];
    incorrectLabel.backgroundColor = [UIColor clearColor];
    incorrectLabel.text = @"错题库";
    incorrectLabel.textAlignment = NSTextAlignmentCenter;
    incorrectLabel.numberOfLines = 0;
    incorrectLabel.textColor = [UIColor whiteColor];
    [incorrectBtn addSubview:incorrectLabel];
    
    // privateBtn
    UIButton *privateBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 + 19.5 / 2, SCREEN_HEIGHT - 80 - 64, 30.5, 30.5)];
    [privateBtn setBackgroundImage:[UIImage imageNamed:@"index_aa"] forState:UIControlStateNormal];
    [privateBtn addTarget:self action:@selector(privateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateBtn];
    
    // messageBtn
    UIButton *msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(privateBtn.frame.origin.x, privateBtn.frame.origin.y + privateBtn.frame.size.height + 10, 30.5, 30.5 * 33 / 48.0)];
    [msgBtn setBackgroundImage:[UIImage imageNamed:@"index_bb"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(msgBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:msgBtn];
    
    //pushNotice
    newMsg = [[UIImageView alloc] initWithFrame:CGRectMake(10, -5, 49 / 2.0, 26 / 2.0)];
    newMsg.image = [UIImage imageNamed:@"message_new"];
    newMsg.hidden = YES;
    [msgBtn addSubview:newMsg];
    
    // iAdScrollView
    [self loadADdata];
    CGRect frame;
    if (iPhone5) {
        frame = CGRectMake(0, 10, SCREEN_WIDTH - 50, 140);
    }
    else
    {
        frame = CGRectMake(0, 10, SCREEN_WIDTH - 50, 100);
    }
    
    // itmesView
    NSInteger iAdOffset = frame.size.height + 20;
    LSMainItemsView *itemsView = [[LSMainItemsView alloc] initWithFrame:CGRectMake(0, iAdOffset, SCREEN_WIDTH - 50, SCREEN_HEIGHT - 64 - iAdOffset) Items:itemsArray];
    itemsView.delegate = self;
    [self.view addSubview:itemsView];
    
    if (reach.isReachable) {
        [self CheckLogin];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"网络服务不稳定，请稍后再试"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CheckLogin" object:nil];
}

#pragma mark - load AD Img
- (void)loadADdata
{
    // iAdScrollView
    CGRect frame;
    if (iPhone5) {
        frame = CGRectMake(0, 10, SCREEN_WIDTH - 50, 140);
    }
    else
    {
        frame = CGRectMake(0, 10, SCREEN_WIDTH - 50, 100);
    }
    __block LSMainAdScrollView *iAdScrollView= [[LSMainAdScrollView alloc] initWithFrame:frame];
    [self.view addSubview:iAdScrollView];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Index/Adv"]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSDictionary *dataArr = [dic objectForKey:@"data"];
            [LSUserManager setPush:[[dataArr objectForKey:@"push"] integerValue]];
            [iAdScrollView setItems:dataArr];
        }
        else
        {
            if (reach.isReachable) {
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"网络服务不稳定，请稍后再试"];
            }
        }
    }];
}

#pragma mark - CheckLogin / getUserInfo
- (void)CheckLogin
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [super viewDidAppear:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![LSUserManager getIsLogin]) {
                [LSAppDelegate showLoginView:self];
            }
            else
            {
                [self loadADdata];
                [self queryUserCenterInfo];
                [self queryUserInfo];
            }
        });
    });
}

- (void)queryUserCenterInfo
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/mycenter?key=%d&uid=%d",[LSUserManager getKey],[LSUserManager getUid]]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSDictionary *data = [dic objectForKey:@"data"];
            [LSUserManager setUserName:[data objectForKey:@"name"]];
            [LSUserManager setUserImg:[data objectForKey:@"avatar"]];
            [LSUserManager setUserEmail:[data objectForKey:@"email"]];
            [LSUserManager setPush:[[data objectForKey:@"push"] integerValue]];
            [LSUserManager setEndTime:[data objectForKey:@"endtime"]];
            [LSUserManager setHidePay:[[data objectForKey:@"iospb"] integerValue]];
            if ([LSUserManager RevPush]) {
                newMsg.hidden = [LSUserManager getPush] == 0 ? YES : NO;
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
            if (ret == 0) {
                [LSAppDelegate showLoginView:self];
                [LSUserManager setTCid:0];
            }
        }
    }];
}

- (void)queryUserInfo
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/myInfo?key=%d&uid=%d",[LSUserManager getKey],[LSUserManager getUid]]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSDictionary *data = [dic objectForKey:@"data"];
            [LSUserManager setUserTel:[data objectForKey:@"tel"]];
            [LSUserManager setUserQQ:[data objectForKey:@"qq"]];
            [LSUserManager setUserCity:[data objectForKey:@"city"]];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

#pragma mark - itemsViewDelegate

- (void)clickedOnItem:(UIButton *)sender
{
    if (!reach.isReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络服务不稳定，请稍后再试"];
        return;
    }
    if (![LSUserManager getIsLogin]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
    if ([LSUserManager getTCid] == 0) {
        [self selectBtnClicked];
        return;
    }
    switch (sender.tag) {
        case 0:
        {
            LSPractiseController *vc = [[LSPractiseController alloc]init];
            vc.isContinue = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            LSPrivateCollectionViewController *collectionVC = [[LSPrivateCollectionViewController alloc] init];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }
            break;
        case 2:
        {//练习模块
            LSCourseTableViewController *courseVC = [[LSCourseTableViewController alloc]init];
            [self.navigationController pushViewController:courseVC animated:YES];
        }
            break;
        case 3:
        {//套卷模块
            LSWrapPracticeViewController *wrapVC = [[LSWrapPracticeViewController alloc]init];
            [self.navigationController pushViewController:wrapVC animated:YES];
            
        }
            break;
        case 4:
        {
            LSChoiceListViewController *choiceVC = [[LSChoiceListViewController alloc] init];
            [self.navigationController pushViewController:choiceVC animated:YES];
        }
            break;
        case 5:
        {
            LSCourseRecommendViewController *recommendVC = [[LSCourseRecommendViewController alloc] init];
            [self.navigationController pushViewController:recommendVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - handle button click

- (void)selectBtnClicked
{
    if (!reach.isReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络服务不稳定，请稍后再试"];
        return;
    }
    if (![LSUserManager getIsLogin]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
    LSCourseSelectMainViewController *courseVC = [[LSCourseSelectMainViewController alloc] init];
    [self.navigationController pushViewController:courseVC animated:YES];
}

- (void)infoBtnClicked
{
    if (!reach.isReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络服务不稳定，请稍后再试"];
        return;
    }
    if (![LSUserManager getIsLogin]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
    LSPrivateErrorDBViewController *errorVC = [[LSPrivateErrorDBViewController alloc] init];
    [self.navigationController pushViewController:errorVC animated:YES];
}

- (void)incorrectBtnClicked
{
    if (!reach.isReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络服务不稳定，请稍后再试"];
        return;
    }
    if (![LSUserManager getIsLogin]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
    LSPrivateErrorDBViewController *errorVC = [[LSPrivateErrorDBViewController alloc] init];
    [self.navigationController pushViewController:errorVC animated:YES];
}

- (void)privateBtnClicked
{
    if (!reach.isReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络服务不稳定，请稍后再试"];
        return;
    }
    if (![LSUserManager getIsLogin]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
    LSPrivateCenterViewController *privateCenterVC = [[LSPrivateCenterViewController alloc] init];
    [self.navigationController pushViewController:privateCenterVC animated:YES];
}

- (void)msgBtnClicked
{
    if (!reach.isReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络服务不稳定，请稍后再试"];
        return;
    }
    if (![LSUserManager getIsLogin]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
    if ([LSUserManager RevPush]) {
        LSMsgPushViewController *msgPushVC = [[LSMsgPushViewController alloc] init];
        [self.navigationController pushViewController:msgPushVC animated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请先开启消息推送"];
    }
}

@end
