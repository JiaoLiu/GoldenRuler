//
//  LSSheetNotify.h
//  金标尺
//
//  Created by Jiao Liu on 14-6-6.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSSheetNotify : UIView

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIView *sheetView;
@property (nonatomic, strong, readonly) UILabel *stringLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinnerView;

@property (nonatomic, strong)UIColor *sheetBackgroundColor;

+ (instancetype)sharedInstance;
+ (void)showProgress:(NSString *)status;
+ (void)showOnce:(NSString *)status;
+ (void)dismiss;

@end
