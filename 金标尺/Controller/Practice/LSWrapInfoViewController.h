//
//  LSWrapInfoViewController.h
//  金标尺
//
//  Created by wzq on 14/6/5.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSWrapInfoViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic,assign)  LSWrapType    wrapType;
@property (nonatomic,strong)  NSString      *city; //城市名
@property (nonatomic) int cid;
@end
