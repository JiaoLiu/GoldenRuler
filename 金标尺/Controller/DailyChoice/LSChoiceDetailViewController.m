//
//  LSChoiceDetailViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-25.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSChoiceDetailViewController.h"

@interface LSChoiceDetailViewController ()
{
    UIActivityIndicatorView *activityIDC;
}

@end

@implementation LSChoiceDetailViewController

@synthesize choiceWebView;

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
    self.title = @"每日精选";
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
    choiceWebView  = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    choiceWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    [choiceWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://baidu.com"]]];
    choiceWebView.delegate = self;
    [self.view addSubview:choiceWebView];
    
    activityIDC = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIDC.center = CGPointMake(choiceWebView.frame.size.width / 2.0, choiceWebView.frame.size.height / 2.0);
    [choiceWebView addSubview:activityIDC];
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
    CGFloat contentHeight = webView.scrollView.contentSize.height;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + 100);
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, contentHeight, SCREEN_WIDTH, 200)];
        footView.backgroundColor = [UIColor whiteColor];
        [webView.scrollView addSubview:footView];
        
        LSImageButton *collectBtn = [[LSImageButton alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];
        collectBtn.image = [UIImage imageNamed:@"m_add"];
        collectBtn.title = @"加入收藏";
        collectBtn.titleFont = [UIFont systemFontOfSize:13.0];
        collectBtn.layer.borderColor = [UIColor grayColor].CGColor;
        collectBtn.layer.borderWidth = 1;
        collectBtn.layer.cornerRadius = 3;
        [footView addSubview:collectBtn];
    });
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
