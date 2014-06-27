//
//  LSMainViewController.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSMainItemsView.h"
#import "LSMainAdScrollView.h"
#import "LSAppDelegate.h"
#import "LSPrivateCenterViewController.h"
#import "LSMsgPushViewController.h"
#import "LSPrivateCollectionViewController.h"
#import "LSCourseSelectMainViewController.h"
#import "LSChoiceListViewController.h"
#import "LSCourseRecommendViewController.h"

@interface LSMainViewController : UIViewController<LSMainItemsViewDelegate>

@property (nonatomic, strong)NSArray *itemsArray;

@end
