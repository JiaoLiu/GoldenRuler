//
//  LSPrivateCenterViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateCenterViewController.h"

@interface LSPrivateCenterViewController ()

@end

@implementation LSPrivateCenterViewController

@synthesize isVip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isVip = YES;
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
    
    UIImageView *headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    headerImgView.image = [UIImage imageNamed:@"default_header@2x.jpg"];
    headerImgView.layer.borderWidth = 1;
    headerImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    headerImgView.clipsToBounds = YES;
    [headerBackView addSubview:headerImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImgView.frame.origin.x + headerImgView.frame.size.width + 10, 5, headerBackView.frame.size.width - 80, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"风中玉碟";
    [headerBackView addSubview:nameLabel];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 35, nameLabel.frame.size.width, 15)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = @"电子邮箱：341312414@qq.com";
    emailLabel.textColor = [UIColor lightGrayColor];
    emailLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:emailLabel];
    
    if (isVip) {
        UILabel *vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 55, 65, 15)];
        vipLabel.textColor = [UIColor redColor];
        vipLabel.text = @"VIP贵宾会员";
        vipLabel.backgroundColor = [UIColor clearColor];
        vipLabel.font = [UIFont systemFontOfSize:11];
        [headerBackView addSubview:vipLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(vipLabel.frame.origin.x + vipLabel.frame.size.width, vipLabel.frame.origin.y, 110, 15)];
        timeLabel.text = [NSString stringWithFormat:@"到期时间:%@",@"2014-05-12"];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:11];
        [headerBackView addSubview:timeLabel];
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width, vipLabel.frame.origin.y, 50, 15)];
        [addBtn setTitle:@"【续期】" forState:UIControlStateNormal];
        [addBtn setTitleColor:RGB(4, 121, 202) forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [headerBackView addSubview:addBtn];
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
- (void)addBtnClicked
{
    
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
