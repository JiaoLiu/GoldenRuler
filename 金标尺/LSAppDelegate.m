//
//  LSAppDelegate.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSAppDelegate.h"
#import "LSMainViewController.h"
#import "UIImage+Utility.h"
#import "LSLoginViewController.h"

@implementation LSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    Reachability *kRech = [Reachability reachabilityForInternetConnection];
    LSMainViewController *mainController = [[LSMainViewController alloc] init];
    if (kRech.currentReachabilityStatus != NotReachable) {
        mainController.iAdArray = [self loadADdata];
    }
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainController];
    mainNav.navigationBar.translucent = NO;
    self.window.rootViewController = mainNav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //customize navgationbar
    if (IOS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:RGB(4, 121, 202)];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:RGB(4, 121, 202) size:CGSizeMake(1, 44)] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setTitleTextAttributes:
         @{ UITextAttributeFont: [UIFont systemFontOfSize:17],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero] ,
            UITextAttributeTextColor : [UIColor whiteColor]} forState:UIControlStateNormal];

        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0) forBarMetrics:UIBarMetricsDefault];
    }
    
    // register WeiXin
    [WXApi registerApp:@"wx791a769bf20e2231"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:@"wx791a769bf20e2231"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"wx791a769bf20e2231"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else return YES;
}

#pragma mark - show loginView
+ (void)showLoginView:(UIViewController *)viewC
{
    LSLoginViewController *loginVC = [[LSLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [viewC presentViewController:nav animated:YES completion:^{
    }];
}

#pragma mark - load AD Img
- (NSDictionary *)loadADdata
{
    NSDictionary *dataArr = [[NSDictionary alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Index/Adv"]]] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:20];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dic = [data mutableObjectFromJSONData];
    NSInteger ret = [[dic objectForKey:@"status"] integerValue];
    if (ret == 1) {
        dataArr = [dic objectForKey:@"data"];
        [LSUserManager setPush:[[dataArr objectForKey:@"push"] integerValue]];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
    }
    return dataArr;
}

@end
