//
//  LSMsgDetailViewController.h
//  金标尺
//
//  Created by Jiao Liu on 14-6-5.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMsgDetailViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *msgWebView;
@property (nonatomic,assign)NSString *msgTitle;
@property (nonatomic,assign)NSString *msgUrl;

@end
