//
//  LSMsgDetailViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-6-5.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSMsgDetailViewController.h"

@interface LSMsgDetailViewController ()
{
    UIActivityIndicatorView *activityIDC;
}

@end

@implementation LSMsgDetailViewController

@synthesize msgUrl;
@synthesize msgWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    // webView & activityView
    msgWebView  = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    msgWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    [msgWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:msgUrl]]];
    msgWebView.delegate = self;
    [self.view addSubview:msgWebView];
    
    activityIDC = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIDC.center = CGPointMake(msgWebView.frame.size.width / 2.0, msgWebView.frame.size.height / 2.0);
    [msgWebView addSubview:activityIDC];
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

- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - webview Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIDC startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIDC stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [webView removeFromSuperview];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    label.text = [error localizedDescription];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
}

@end
