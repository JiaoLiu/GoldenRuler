//
//  LSSheetNotify.m
//  金标尺
//
//  Created by Jiao Liu on 14-6-6.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSSheetNotify.h"

@implementation LSSheetNotify

@synthesize overlayWindow;
@synthesize sheetView;
@synthesize spinnerView;
@synthesize stringLabel;

+ (instancetype)sharedInstance
{
    static LSSheetNotify *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LSSheetNotify alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedInstance;
}

+ (void)showProgress:(NSString *)status
{
    [[LSSheetNotify sharedInstance] showProgress:status];
}

+ (void)showOnce:(NSString *)status
{
    [[LSSheetNotify sharedInstance] showOnce:status];
}
+ (void)dismiss
{
    [[LSSheetNotify sharedInstance] dismiss];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (UIWindow *)overlayWindow
{
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
        overlayWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return overlayWindow;
}

- (UIView *)sheetView
{
    if(!sheetView) {
        sheetView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // UIAppearance is used when iOS >= 5.0
		sheetView.backgroundColor = self.sheetBackgroundColor;
        sheetView.alpha = 0.7;
        
        sheetView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:sheetView];
    }
    return sheetView;
}

- (UIActivityIndicatorView *)spinnerView
{
    if (spinnerView == nil) {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		spinnerView.hidesWhenStopped = YES;
        
        // UIAppearance is used when iOS >= 5.0
    }
    
    if(!spinnerView.superview)
        [self.sheetView addSubview:spinnerView];
    
    return spinnerView;
}

- (UILabel *)stringLabel
{
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        stringLabel.textAlignment = UITextAlignmentCenter;
#else
        stringLabel.textAlignment = NSTextAlignmentCenter;
#endif
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        
        // UIAppearance is used when iOS >= 5.0
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.font = [UIFont systemFontOfSize:16.0];
        
		stringLabel.shadowOffset = CGSizeMake(0, -1);
        stringLabel.numberOfLines = 0;
    }
    
    if(!stringLabel.superview)
        [self.sheetView addSubview:stringLabel];
    
    return stringLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)showProgress:(NSString *)status 
{
    if(!self.superview)
    {
        [self.overlayWindow addSubview:self];
    }
    
    self.sheetBackgroundColor = [UIColor blackColor];
    self.sheetView.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    
    CGSize sz = [status sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(MAXFLOAT, 40) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.stringLabel.frame = CGRectMake(SCREEN_WIDTH / 2 - sz.width / 2, 0, sz.width, 40);
    stringLabel.text = status;
    
    self.spinnerView.center = CGPointMake(stringLabel.frame.origin.x - 15, 20);
    spinnerView.hidden = NO;
    
    overlayWindow.hidden = NO;
    if(self.alpha != 1) {
        self.sheetView.transform = CGAffineTransformScale(self.sheetView.transform, 1.3, 1.3);
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.sheetView.transform = CGAffineTransformScale(self.sheetView.transform, 1/1.3, 1/1.3);
                             self.alpha = 1;
                             [spinnerView startAnimating];
                         }
                         completion:^(BOOL finished){
                         }];
        
        [self setNeedsDisplay];
    }
}

- (void)showOnce:(NSString *)status
{
    if(!self.superview)
    {
        [self.overlayWindow addSubview:self];
    }
    
    self.sheetBackgroundColor = [UIColor blackColor];
    self.sheetView.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    
    CGSize sz = [status sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(MAXFLOAT, 40) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.stringLabel.frame = CGRectMake(SCREEN_WIDTH / 2 - sz.width / 2, 0, sz.width, 40);
    stringLabel.text = status;
    
    if (spinnerView != nil) {
        spinnerView.hidden = YES;
    }
    
    overlayWindow.hidden = NO;
    if(self.alpha != 1) {
        self.sheetView.transform = CGAffineTransformScale(self.sheetView.transform, 1.3, 1.3);
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.sheetView.transform = CGAffineTransformScale(self.sheetView.transform, 1/1.3, 1/1.3);
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
        
        [self setNeedsDisplay];
    }
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.15 animations:^{ // available for ios 6.x
        self.alpha = 0;
        self.sheetView.transform = CGAffineTransformScale(self.sheetView.transform, 0.8, 0.8);
    } completion:^(BOOL finished) {
        if (self.alpha == 0) {
            [sheetView removeFromSuperview];
            sheetView = nil;
            
            [overlayWindow removeFromSuperview];
            overlayWindow = nil;
            
            [spinnerView stopAnimating];
        }
    }];
//    [UIView animateKeyframesWithDuration:0.15 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
//        self.alpha = 0;
//        self.sheetView.transform = CGAffineTransformScale(self.sheetView.transform, 0.8, 0.8);
//    } completion:^(BOOL finished) {
//        if (self.alpha == 0) {
//            [sheetView removeFromSuperview];
//            sheetView = nil;
//            
//            [overlayWindow removeFromSuperview];
//            overlayWindow = nil;
//            
//            [spinnerView stopAnimating];
//        }
//    }];
}

@end
