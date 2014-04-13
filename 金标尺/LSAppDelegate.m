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
    // Override point for customization after application launch.
    LSMainViewController *mainController = [[LSMainViewController alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainController];
    mainNav.navigationBar.translucent = NO;
    self.window.rootViewController = mainNav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //customize navgationbar
    if (IOS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:RGB(46, 121, 202)];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:RGB(46, 121, 202) size:CGSizeMake(1, 44)] forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
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
    [USER_DEFAULT setObject:@"N" forKey:isLoginKey];
    [USER_DEFAULT synchronize];
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

#pragma mark - show loginView

+ (void)showLoginView:(UIViewController *)viewC
{
    LSLoginViewController *loginVC = [[LSLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [viewC presentViewController:nav animated:YES completion:^{
    }];
}



@end
