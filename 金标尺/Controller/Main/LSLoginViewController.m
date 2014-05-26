//
//  LSLoginViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-13.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSLoginViewController.h"
#import "LSRegisterViewController.h"

@interface LSLoginViewController ()

@end

@implementation LSLoginViewController

@synthesize usernameField;
@synthesize pwdField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = YES;
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //input field
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 70)];
    inputView.layer.borderWidth = 0.5;
    inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:inputView];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 35 - 0.25, SCREEN_WIDTH - 20, 0.5)];
    separator.backgroundColor = [UIColor lightGrayColor];
    [inputView addSubview:separator];
    
    usernameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 40, 35)];
    usernameField.placeholder = @"请输入用户名/Email";
    usernameField.delegate = self;
    usernameField.keyboardType = UIKeyboardTypeEmailAddress;
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameField.returnKeyType = UIReturnKeyNext;
    usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [inputView addSubview:usernameField];
    
    pwdField = [[UITextField alloc] initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH - 40, 35)];
    pwdField.placeholder = @"请输入密码";
    pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdField.returnKeyType = UIReturnKeyJoin;
    pwdField.secureTextEntry = YES;
    pwdField.delegate = self;
    pwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [inputView addSubview:pwdField];
    
    // loginBtn
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, inputView.frame.origin.y + inputView.frame.size.height + 15, SCREEN_WIDTH - 20, 40)];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:RGB(86, 167, 221) size:loginBtn.frame.size] forState:UIControlStateNormal];
    [loginBtn setTitle:@"用户登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    // registerBtn
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, loginBtn.frame.origin.y + loginBtn.frame.size.height + 15, SCREEN_WIDTH - 20, 40)];
    [registerBtn setBackgroundImage:[UIImage imageWithColor:RGB(86, 167, 221) size:loginBtn.frame.size] forState:UIControlStateNormal];
    [registerBtn setTitle:@"我还没有账号，点击注册？" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGes];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    [usernameField resignFirstResponder];
    [pwdField resignFirstResponder];
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

#pragma mark - handle btn action
- (void)loginBtnClicked
{
    [usernameField resignFirstResponder];
    [pwdField resignFirstResponder];
    if (usernameField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    if (pwdField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入用密码"];
        return;
    }
    NSURLRequest *requrest = [NSURLRequest requestWithURL:[NSURL URLWithString:[APILogin stringByAppendingString:[NSString stringWithFormat:@"?name=%@?pwd=%@",usernameField.text,pwdField.text]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:requrest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            [USER_DEFAULT setObject:@"Y" forKey:isLoginKey];
            [USER_DEFAULT synchronize];
            [self backBtnClicked];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

- (void)registerBtnClicked
{
    [usernameField resignFirstResponder];
    [pwdField resignFirstResponder];
    LSRegisterViewController *registerVC = [[LSRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)backBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == usernameField) {
        [pwdField becomeFirstResponder];
    }
    if (textField == pwdField) {
        [self loginBtnClicked];
    }
    return YES;
}

@end
