//
//  LSMainViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSMainViewController.h"

@interface LSMainViewController ()

@end

@implementation LSMainViewController

@synthesize itemsArray;
@synthesize iAdArray;

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
        iAdArray = @[@"1",@"2",@"3",@"4",@"5"];
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
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // infoBtn
    UIButton *infoOrhomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [infoOrhomeBtn addTarget:self action:@selector(infoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [infoOrhomeBtn setBackgroundImage:[UIImage imageNamed:@"index_topr"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:infoOrhomeBtn];
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
    UIButton *msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(privateBtn.frame.origin.x, privateBtn.frame.origin.y + privateBtn.frame.size.height, 30.5, 30.5)];
    [msgBtn setBackgroundImage:[UIImage imageNamed:@"index_bb"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(msgBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:msgBtn];
    
    // iAdScrollView
    LSMainAdScrollView *iAdScrollView;
    if (iAdArray.count != 0) {
        CGRect frame;
        if (iPhone5) {
            frame = CGRectMake(0, 10, SCREEN_WIDTH - 50, 140);
        }
        else
        {
            frame = CGRectMake(0, 10, SCREEN_WIDTH - 50, 100);
        }
        iAdScrollView = [[LSMainAdScrollView alloc] initWithFrame:frame Items:iAdArray];
        iAdScrollView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:iAdScrollView];
    }
    
    // itmesView
    NSInteger iAdOffset = iAdScrollView.frame.size.height + 20;
    LSMainItemsView *itemsView = [[LSMainItemsView alloc] initWithFrame:CGRectMake(0, iAdOffset, SCREEN_WIDTH - 50, SCREEN_HEIGHT - 64 - iAdOffset) Items:itemsArray];
    itemsView.delegate = self;
    [self.view addSubview:itemsView];
    
    if (![[USER_DEFAULT objectForKey:isLoginKey] isEqualToString:@"Y"]) {
        [LSAppDelegate showLoginView:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - itemsViewDelegate

- (void)clickedOnItem:(UIButton *)sender
{
    if (![[USER_DEFAULT objectForKey:isLoginKey] isEqualToString:@"Y"]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
    NSLog(@"%d",sender.tag);
}

#pragma mark - handle button click

- (void)selectBtnClicked
{
    if (![[USER_DEFAULT objectForKey:isLoginKey] isEqualToString:@"Y"]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
}

- (void)infoBtnClicked
{
    if (![[USER_DEFAULT objectForKey:isLoginKey] isEqualToString:@"Y"]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
}

- (void)incorrectBtnClicked
{
    if (![[USER_DEFAULT objectForKey:isLoginKey] isEqualToString:@"Y"]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
}

- (void)privateBtnClicked
{
    if (![[USER_DEFAULT objectForKey:isLoginKey] isEqualToString:@"Y"]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
    LSPrivateCenterViewController *privateCenterVC = [[LSPrivateCenterViewController alloc] init];
    [self.navigationController pushViewController:privateCenterVC animated:YES];
}

- (void)msgBtnClicked
{
    if (![[USER_DEFAULT objectForKey:isLoginKey] isEqualToString:@"Y"]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
}

@end
