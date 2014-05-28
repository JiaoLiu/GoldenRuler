//
//  LSPrivateEditViewController.m
//  金标尺
//
//  Created by Jiao on 14-5-28.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateEditViewController.h"

@interface LSPrivateEditViewController ()
{
    UITextField *textFD;
}

@end

@implementation LSPrivateEditViewController

@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // saveBtn
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    // editField
    if (type != kEditPwd) {
        textFD = [[UITextField alloc] initWithFrame:CGRectMake(-0.5, 15, SCREEN_WIDTH + 1, 35)];
        textFD.layer.borderWidth = 0.5;
        textFD.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textFD.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textFD.returnKeyType = UIReturnKeyDone;
        textFD.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFD.delegate = self;
        [self.view addSubview:textFD];
    }
    
    
    
    switch (type) {
        case kEditName:
        {
            self.title = @"修改用户名";
            textFD.placeholder = @"请输入用户名";
        }
            break;
        case kEditPhone:
        {
            self.title = @"修改手机号码";
            textFD.placeholder = @"请输入手机号码";
        }
            break;
        case kEditPwd:
        {
            self.title = @"修改登录密码";
        }
            break;
        case kEditQQ:
        {
            self.title = @"修改QQ号";
            textFD.placeholder = @"请输入QQ号";
        }
            break;
        case kEditEmail:
        {
            self.title = @"修改电子邮箱";
            textFD.placeholder = @"请输入电子邮箱";
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - handleBtnClicked
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtnClicked
{
    
}

#pragma mark - textFD delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveBtnClicked];
    return YES;
}

@end
