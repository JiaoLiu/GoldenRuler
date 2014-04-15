//
//  LSRegisterViewController.h
//  金标尺
//
//  Created by Jiao on 14-4-14.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSRegisterViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong)UITextField *usernameField;
@property (nonatomic, strong)UITextField *pwdField;
@property (nonatomic, strong)UITextField *pwdComfirmField;
@property (nonatomic, strong)UITextField *nameField;
@property (nonatomic, strong)UITextField *emailField;

@end
