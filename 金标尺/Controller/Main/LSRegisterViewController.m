//
//  LSRegisterViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-14.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSRegisterViewController.h"

@interface LSRegisterViewController ()

@end

@implementation LSRegisterViewController

@synthesize usernameField;
@synthesize pwdField;
@synthesize pwdComfirmField;
@synthesize emailField;
@synthesize nameField;

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
    self.title = @"用户注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    int height = 35;
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, height * 3)];
    table.rowHeight = height;
    table.scrollEnabled = NO;
    table.layer.borderColor = [UIColor lightGrayColor].CGColor;
    table.layer.borderWidth = 0.5;
    table.delegate = self;
    table.dataSource = self;
    if (IOS_VERSION >= 7.0) {
        table.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:table];
    
    // loginBtn
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, table.frame.origin.y + table.frame.size.height + 15, SCREEN_WIDTH - 20, 40)];
    [registerBtn setBackgroundImage:[UIImage imageWithColor:RGB(86, 167, 221) size:registerBtn.frame.size] forState:UIControlStateNormal];
    [registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    // registerBtn
    UIButton *backLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, registerBtn.frame.origin.y + registerBtn.frame.size.height + 15, SCREEN_WIDTH - 20, 40)];
    [backLoginBtn setBackgroundImage:[UIImage imageWithColor:RGB(86, 167, 221) size:backLoginBtn.frame.size] forState:UIControlStateNormal];
    [backLoginBtn setTitle:@"我已有账号，点击登录？" forState:UIControlStateNormal];
    [backLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backLoginBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backLoginBtn];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGes];
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

- (void)dismissKeyboard
{
    [usernameField resignFirstResponder];
    [pwdComfirmField resignFirstResponder];
    [pwdField resignFirstResponder];
//    [nameField resignFirstResponder];
//    [emailField resignFirstResponder];
}

#pragma mark - handle btn action
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

- (void)registerBtnClicked
{
    if (usernameField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    if (pwdField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (pwdComfirmField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入密码"];
        return;
    }
    if (![pwdComfirmField.text isEqualToString:pwdField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    [SVProgressHUD showWithStatus:@"注册中..." maskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [APIRegister stringByAppendingString:[NSString stringWithFormat:@"?name=%@&pwd=%@&client=1",usernameField.text,pwdField.text]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSDictionary *data = [dic objectForKey:@"data"];
            [LSUserManager setIsLogin:YES];
            [LSUserManager setIsVip:[[data objectForKey:@"is_vip"] integerValue]];
            [LSUserManager setKey:[[data objectForKey:@"key"] integerValue]];
            [LSUserManager setUid:[[data objectForKey:@"uid"] integerValue]];
            [LSUserManager setLastqid:[[data objectForKey:@"lastqid"] integerValue]];
            [self dismissViewControllerAnimated:YES completion:^{
                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckLogin" object:nil];
            }];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        switch (indexPath.row) {
            case 0:
            {
                usernameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 40, 35)];
                usernameField.placeholder = @"请输入用户名";
                usernameField.delegate = self;
                usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
                usernameField.returnKeyType = UIReturnKeyNext;
                usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [Cell.contentView addSubview:usernameField];
            }
                break;
            case 1:
            {
                pwdField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 40, 35)];
                pwdField.placeholder = @"请输入密码";
                pwdField.delegate = self;
                pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
                pwdField.returnKeyType = UIReturnKeyNext;
                pwdField.secureTextEntry = YES;
                pwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [Cell.contentView addSubview:pwdField];
            }
                break;
            case 2:
            {
                pwdComfirmField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 40, 35)];
                pwdComfirmField.placeholder = @"密码确认";
                pwdComfirmField.delegate = self;
                pwdComfirmField.clearButtonMode = UITextFieldViewModeWhileEditing;
                pwdComfirmField.returnKeyType = UIReturnKeyDone;
                pwdComfirmField.secureTextEntry = YES;
                pwdComfirmField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [Cell.contentView addSubview:pwdComfirmField];
            }
                break;
//            case 3:
//            {
//                nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 40, 35)];
//                nameField.placeholder = @"真实姓名";
//                nameField.delegate = self;
//                nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                nameField.returnKeyType = UIReturnKeyNext;
//                nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                [Cell.contentView addSubview:nameField];
//            }
//                break;
//            case 4:
//            {
//                emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 40, 35)];
//                emailField.placeholder = @"请输入邮箱";
//                emailField.delegate = self;
//                emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                emailField.keyboardType = UIKeyboardTypeEmailAddress;
//                emailField.returnKeyType = UIReturnKeyDone;
//                emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                [Cell.contentView addSubview:emailField];
//            }
//                break;
                
            default:
                break;
        }
    }
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [usernameField becomeFirstResponder];
            break;
        case 1:
            [pwdField becomeFirstResponder];
            break;
        case 2:
            [pwdComfirmField becomeFirstResponder];
            break;
//        case 3:
//            [nameField becomeFirstResponder];
//            break;
//        case 4:
//            [emailField becomeFirstResponder];
//            break;
        default:
            break;
    }
}

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == usernameField) {
        [pwdField becomeFirstResponder];
    }
    if (textField == pwdField) {
        [pwdComfirmField becomeFirstResponder];
    }
    if (textField == pwdComfirmField) {
        [pwdComfirmField resignFirstResponder];
    }
//    if (textField == nameField) {
//        [emailField becomeFirstResponder];
//    }
//    if (textField == emailField) {
//        [emailField resignFirstResponder];
//    }
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == phoneNumField) {
//        if ([string  isEqual: @""]) {
//            return YES;
//        }
//        return textField.text.length >= 11 ? NO : YES;
//    }
//    return YES;
//}

@end
