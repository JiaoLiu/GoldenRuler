//
//  LSPrivateSettingViewController.h
//  金标尺
//
//  Created by Jiao on 14-4-21.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSPrivateSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)NSString *updateUrl;

@end
