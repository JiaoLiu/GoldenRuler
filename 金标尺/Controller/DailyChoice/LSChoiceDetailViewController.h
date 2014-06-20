//
//  LSChoiceDetailViewController.h
//  金标尺
//
//  Created by Jiao on 14-4-25.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSImageButton.h"
#import "WXApi.h"

typedef enum : NSUInteger {
    kCollectBtnTag,
    kCommentBtnTag,
    kShareBtnTag,
    kWeiboBtnTag,
    kSinaBtnTag,
    kWeixinBtnTag
} kFooterViewTags;

typedef enum : NSUInteger {
    kDailyChoice,
    kCourseRecommend
} kDetailType;

@interface LSChoiceDetailViewController : UIViewController<UIWebViewDelegate,WXApiDelegate>

@property (nonatomic, strong)UIWebView *choiceWebView;
@property (nonatomic, assign)NSString *urlStr;
@property (nonatomic, strong)NSString *urlTitle;
@property (nonatomic, assign)kDetailType detailType;

@end
