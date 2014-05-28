//
//  LSPrivateEditViewController.h
//  金标尺
//
//  Created by Jiao on 14-5-28.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kEditName,
    kEditPhone,
    kEditEmail,
    kEditQQ,
    kEditPwd
} kEditType;

@interface LSPrivateEditViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, assign)kEditType type;

@end
