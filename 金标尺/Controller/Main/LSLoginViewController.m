//
//  LSLoginViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-13.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSLoginViewController.h"

@interface LSLoginViewController ()

@end

@implementation LSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = YES;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户登录";
    self.view.backgroundColor = [UIColor redColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, NavigationBar_HEIGHT)];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
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

- (void)backBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
