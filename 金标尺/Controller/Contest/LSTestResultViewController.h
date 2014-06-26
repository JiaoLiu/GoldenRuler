//
//  LSTestResultViewController.h
//  金标尺
//
//  Created by wzq on 14/6/26.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTabBar.h"

@interface LSTestResultViewController : UIViewController<LSTabBarDelegate>
@property (nonatomic) int myscore;
@property (nonatomic) int totalscore;
@property (nonatomic) int time;
@property (nonatomic) int usedtime;

@end
