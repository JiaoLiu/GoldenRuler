//
//  LSShareSheet.m
//  金标尺
//
//  Created by Jiao on 14-7-3.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSShareSheet.h"

@implementation LSShareSheet

@synthesize items;

- (id)initWithDelegate:(id)delegate
{
    self = [super initWithTitle:@"\n\n\n" delegate:delegate cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    if (self) {
        // Initialization code
        UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 70)];
        if (IOS_VERSION < 7.0) {
            backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
        }
        backView.backgroundColor = [UIColor clearColor];
        [self addSubview:backView];
        
        NSInteger width = 20;
        NSInteger height = 10;
        UIButton *weiboBtn = [[UIButton alloc] initWithFrame:CGRectMake(width, height, 46, 45)];
        weiboBtn.tag = kShareWeibo;
        [weiboBtn setImage:[UIImage imageNamed:@"m_w"] forState:UIControlStateNormal];
        [weiboBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:weiboBtn];
        
        UIButton *sinaBtn = [[UIButton alloc] initWithFrame:CGRectMake(width + weiboBtn.frame.size.width + weiboBtn.frame.origin.x, height, 82, 45)];
        sinaBtn.tag = kShareSina;
        [sinaBtn setImage:[UIImage imageNamed:@"m_s"] forState:UIControlStateNormal];
        [sinaBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:sinaBtn];
        
        UIButton *weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake(width + sinaBtn.frame.size.width + sinaBtn.frame.origin.x, height, 46, 45)];
        weixinBtn.tag = kShareWeixin;
        [weixinBtn setImage:[UIImage imageNamed:@"m_ww"] forState:UIControlStateNormal];
        [weixinBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:weixinBtn];
        
        backView.contentSize = CGSizeMake(weiboBtn.frame.origin.x + weixinBtn.frame.size.width + width, 70);
        
        items = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    items = nil;
}

- (void)clickShareBtn:(UIButton *)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    kShareType tag = sender.tag;
    switch (tag) {
        case kShareWeibo:
        {
            NSString *openUrl = [NSString stringWithFormat:@"http://www.jiathis.com/send/?webid=tqq&url=%@&title=%@",[items objectForKey:@"url"],[items objectForKey:@"title"]];
            openUrl = [openUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
        }
            break;
        case kShareSina:
        {
            NSString *openUrl = [NSString stringWithFormat:@"http://www.jiathis.com/send/?webid=tsina&url=%@&title=%@",[items objectForKey:@"url"],[items objectForKey:@"title"]];
            openUrl = [openUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
        }
            break;
        case kShareWeixin:
        {
            if (![WXApi isWXAppInstalled]) {
                [SVProgressHUD showErrorWithStatus:@"未安装微信客户端"];
                break;
            }
            WXMediaMessage *msg = [WXMediaMessage message];
            msg.title = [items objectForKey:@"title"];
            //            msg.description = @"Hello from Jiao ~_~";
            [msg setThumbImage:[UIImage imageNamed:@"logo"]];
            WXWebpageObject *obj = [WXWebpageObject object];
            obj.webpageUrl = [items objectForKey:@"url"];
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

//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}

@end
