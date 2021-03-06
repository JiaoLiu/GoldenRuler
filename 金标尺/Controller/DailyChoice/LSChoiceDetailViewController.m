//
//  LSChoiceDetailViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-25.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSChoiceDetailViewController.h"
#import "LSShareSheet.h"

@interface LSChoiceDetailViewController ()
{
    UIActivityIndicatorView *activityIDC;
}

@end

@implementation LSChoiceDetailViewController

@synthesize choiceWebView;
@synthesize urlStr;
@synthesize urlTitle;
@synthesize detailType;

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
    switch (detailType) {
        case kCourseRecommend:
            self.title = @"课程推荐";
            break;
        case kDailyChoice:
            self.title = @"每日精选";
            break;
        case kPushDetail:
            self.title = @"消息详情";
            break;
            
        default:
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // shareBtn
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, NavigationBar_HEIGHT)];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // webView & activityView
    choiceWebView  = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    choiceWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    [choiceWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    choiceWebView.delegate = self;
    choiceWebView.scalesPageToFit = YES;
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

- (void)shareBtnClicked
{
    LSShareSheet *shareSheet = [[LSShareSheet alloc] initWithDelegate:self];
    shareSheet.items = @{@"url":urlStr,@"title":urlTitle};
    [shareSheet showInView:self.view];
}

- (void)footViewBtnClicked:(UIButton *)sender
{
    kFooterViewTags tag = sender.tag;
    switch (tag) {
        case kCollectBtnTag:
        {
            
        }
            break;
        case kCommentBtnTag:
        {
            
        }
            break;
        case kShareBtnTag:
        {
            
        }
            break;
        case kWeiboBtnTag:
        {
            NSString *openUrl = [NSString stringWithFormat:@"http://www.jiathis.com/send/?webid=tqq&url=%@&title=%@",urlStr,urlTitle];
            openUrl = [openUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
        }
            break;
        case kSinaBtnTag:
        {
            NSString *openUrl = [NSString stringWithFormat:@"http://www.jiathis.com/send/?webid=tsina&url=%@&title=%@",urlStr,urlTitle];
            openUrl = [openUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
        }
            break;
        case kWeixinBtnTag:
        {
//            NSString *openUrl = [NSString stringWithFormat:@"http://www.jiathis.com/send/?webid=weixin&url=%@&title=金标尺",urlStr];
//            openUrl = [openUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
            WXMediaMessage *msg = [WXMediaMessage message];
            msg.title = urlTitle;
//            msg.description = @"Hello from Jiao ~_~";
            [msg setThumbImage:[UIImage imageNamed:@"logo"]];
            WXWebpageObject *obj = [WXWebpageObject object];
            obj.webpageUrl = urlStr;
            msg.mediaObject = obj;
            SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
            request.message = msg;
            request.bText = NO;
            request.scene = WXSceneTimeline;
            [WXApi sendReq:request];
        }
            break;
        default:
            break;
    }
}

#pragma mark - webview Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIDC startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIDC stopAnimating];
/*    CGFloat contentHeight = webView.scrollView.contentSize.height;
    CGFloat widthOffset = (SCREEN_WIDTH - 90 * 3) / 4.0;
    dispatch_async(dispatch_get_main_queue(), ^{ // add footerView for web
        webView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + 70);
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, contentHeight, SCREEN_WIDTH, 70)];
        footView.backgroundColor = [UIColor whiteColor];
        [webView.scrollView addSubview:footView];
        
//        LSImageButton *collectBtn = [[LSImageButton alloc] initWithFrame:CGRectMake(widthOffset, 20, 90, 70)];
//        collectBtn.image = [UIImage imageNamed:@"m_add"];
//        collectBtn.title = @"加入收藏";
//        collectBtn.tag = kCollectBtnTag;
//        collectBtn.titleFont = [UIFont systemFontOfSize:13.0];
//        collectBtn.layer.borderColor = [UIColor grayColor].CGColor;
//        collectBtn.layer.borderWidth = 1;
//        collectBtn.layer.cornerRadius = 3;
//        [collectBtn addTarget:self action:@selector(footViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [footView addSubview:collectBtn];
//        
//        LSImageButton *commentBtn = [[LSImageButton alloc] initWithFrame:CGRectMake(collectBtn.frame.size.width + collectBtn.frame.origin.x + widthOffset, 20, 90, 70)];
//        commentBtn.image = [UIImage imageNamed:@"m_ping"];
//        commentBtn.title = @"网友评论";
//        commentBtn.tag = kCommentBtnTag;
//        commentBtn.titleFont = [UIFont systemFontOfSize:13.0];
//        commentBtn.layer.borderColor = [UIColor grayColor].CGColor;
//        commentBtn.layer.borderWidth = 1;
//        commentBtn.layer.cornerRadius = 3;
//        [commentBtn addTarget:self action:@selector(footViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [footView addSubview:commentBtn];
//        
//        LSImageButton *shareBtn = [[LSImageButton alloc] initWithFrame:CGRectMake(commentBtn.frame.size.width + commentBtn.frame.origin.x + widthOffset, 20, 90, 70)];
//        shareBtn.image = [UIImage imageNamed:@"m_fenxiang"];
//        shareBtn.title = @"分享好友";
//        shareBtn.tag = kShareBtnTag;
//        shareBtn.titleFont = [UIFont systemFontOfSize:13.0];
//        shareBtn.layer.borderColor = [UIColor grayColor].CGColor;
//        shareBtn.layer.borderWidth = 1;
//        shareBtn.layer.cornerRadius = 3;
//        [shareBtn addTarget:self action:@selector(footViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [footView addSubview:shareBtn];
        
        UIView *shareCenterView = [[UIView alloc] initWithFrame:CGRectMake(90 + widthOffset * 5, 20, 90 * 2 - widthOffset * 2, 30)];
        shareCenterView.layer.borderColor = [UIColor grayColor].CGColor;
        shareCenterView.layer.borderWidth = 0.5;
        shareCenterView.layer.cornerRadius = 5;
        [footView addSubview:shareCenterView];
        
        CGFloat width = (shareCenterView.frame.size.width - 46 - 82 / 2) / 4.0;
        CGFloat height = (30 - 45 / 2.0) / 2.0;
        
        UIButton *weiboBtn = [[UIButton alloc] initWithFrame:CGRectMake(width, height, 46 / 2.0, 45 / 2.0)];
        weiboBtn.tag = kWeiboBtnTag;
        [weiboBtn setImage:[UIImage imageNamed:@"m_w"] forState:UIControlStateNormal];
        [weiboBtn addTarget:self action:@selector(footViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [shareCenterView addSubview:weiboBtn];
        
        UIButton *sinaBtn = [[UIButton alloc] initWithFrame:CGRectMake(width + weiboBtn.frame.size.width + weiboBtn.frame.origin.x, height, 82 / 2.0, 45 / 2.0)];
        sinaBtn.tag = kSinaBtnTag;
        [sinaBtn setImage:[UIImage imageNamed:@"m_s"] forState:UIControlStateNormal];
        [sinaBtn addTarget:self action:@selector(footViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [shareCenterView addSubview:sinaBtn];
        
        UIButton *weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake(width + sinaBtn.frame.size.width + sinaBtn.frame.origin.x, height, 46 / 2.0, 45 / 2.0)];
        weixinBtn.tag = kWeixinBtnTag;
        [weixinBtn setImage:[UIImage imageNamed:@"m_ww"] forState:UIControlStateNormal];
        [weixinBtn addTarget:self action:@selector(footViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [shareCenterView addSubview:weixinBtn];
    });
 */
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
