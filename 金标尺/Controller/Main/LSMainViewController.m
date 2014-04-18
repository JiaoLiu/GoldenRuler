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

@synthesize infoOrhomeBtn;
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
        itemsArray = @[@{@"title": @"继续上次练习" ,@"img": @"" ,@"color": RGB(36, 164, 238)},
                       @{@"title": @"我的收藏" ,@"img": @"" ,@"color": RGB(233, 138, 29)},
                       @{@"title": @"模块练习" ,@"img": @"" ,@"color": RGB(78, 154, 54)},
                       @{@"title": @"套卷测试" ,@"img": @"" ,@"color": RGB(39, 175, 202)},
                       @{@"title": @"每日精选" ,@"img": @"" ,@"color": RGB(233, 138, 29)},
                       @{@"title": @"课程推荐" ,@"img": @"" ,@"color": RGB(88, 182, 59)}];
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
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, NavigationBar_HEIGHT)];
    [selectBtn setTitle:@"选课" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
//    [self.navigationController.view addSubview:selectBtn];
    
    // infoBtn
    infoOrhomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 20, 50, NavigationBar_HEIGHT)];
    infoOrhomeBtn.backgroundColor = [UIColor redColor];
    [infoOrhomeBtn addTarget:self action:@selector(infoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:infoOrhomeBtn];
    
    // incorrectBtn
    UIButton *incorrectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 1, 50, 125)];
    incorrectBtn.backgroundColor = [UIColor blueColor];
    [incorrectBtn addTarget:self action:@selector(incorrectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:incorrectBtn];
    
    // privateBtn
    UIButton *privateBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 100 - 64, 50, 50)];
    privateBtn.backgroundColor = [UIColor greenColor];
    [privateBtn addTarget:self action:@selector(privateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateBtn];
    
    // messageBtn
    UIButton *msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, privateBtn.frame.origin.y + privateBtn.frame.size.height, 50, 50)];
    msgBtn.backgroundColor = [UIColor grayColor];
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
}

- (void)msgBtnClicked
{
    if (![[USER_DEFAULT objectForKey:isLoginKey] isEqualToString:@"Y"]) {
        [LSAppDelegate showLoginView:self];
        return;
    }
}

@end
