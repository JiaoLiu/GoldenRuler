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
    
    UITextField *textOldPwd;
    UITextField *textNewPwd;
    UITextField *textNewPwdAgain;
    
    NSDictionary *cityInfo;
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
    switch (type) {
        case kEditPwd:
        {
            textOldPwd = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH - 20, 35)];
            textOldPwd.placeholder = @"请输入旧密码";
            textOldPwd.layer.borderWidth = 0.5;
            textOldPwd.layer.borderColor = [UIColor lightGrayColor].CGColor;
            textOldPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textOldPwd.returnKeyType = UIReturnKeyDone;
            textOldPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
            textOldPwd.returnKeyType = UIReturnKeyNext;
            textOldPwd.secureTextEntry = YES;
            textOldPwd.delegate = self;
            [self.view addSubview:textOldPwd];
            
            textNewPwd = [[UITextField alloc] initWithFrame:CGRectMake(10, textOldPwd.frame.origin.y + textOldPwd.frame.size.height - 0.5, SCREEN_WIDTH - 20, 35)];
            textNewPwd.placeholder = @"请输入新密码";
            textNewPwd.layer.borderWidth = 0.5;
            textNewPwd.layer.borderColor = [UIColor lightGrayColor].CGColor;
            textNewPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textNewPwd.returnKeyType = UIReturnKeyDone;
            textNewPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
            textNewPwd.returnKeyType = UIReturnKeyNext;
            textNewPwd.secureTextEntry = YES;
            textNewPwd.delegate = self;
            [self.view addSubview:textNewPwd];
            
            textNewPwdAgain = [[UITextField alloc] initWithFrame:CGRectMake(10, textNewPwd.frame.origin.y + textNewPwd.frame.size.height - 0.5, SCREEN_WIDTH - 20, 35)];
            textNewPwdAgain.placeholder = @"请再次输入新密码";
            textNewPwdAgain.layer.borderWidth = 0.5;
            textNewPwdAgain.layer.borderColor = [UIColor lightGrayColor].CGColor;
            textNewPwdAgain.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textNewPwdAgain.returnKeyType = UIReturnKeyDone;
            textNewPwdAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
            textNewPwdAgain.returnKeyType = UIReturnKeyDone;
            textNewPwdAgain.secureTextEntry = YES;
            textNewPwdAgain.delegate = self;
            [self.view addSubview:textNewPwdAgain];
        }
            break;
        case kEditCity:
        {
            cityInfo = [[NSDictionary alloc] init];
            [self getCitys];
        }
            break;
        default:
        {
            textFD = [[UITextField alloc] initWithFrame:CGRectMake(-0.5, 15, SCREEN_WIDTH + 1, 35)];
            textFD.layer.borderWidth = 0.5;
            textFD.layer.borderColor = [UIColor lightGrayColor].CGColor;
            textFD.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textFD.returnKeyType = UIReturnKeyDone;
            textFD.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textFD becomeFirstResponder];
            textFD.delegate = self;
            [self.view addSubview:textFD];
        }
            break;
    }
    
    // title
    switch (type) {
        case kEditName:
        {
            self.title = @"修改用户名";
            textFD.placeholder = @"请输入用户名";
            textFD.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        case kEditPhone:
        {
            self.title = @"修改手机号码";
            textFD.placeholder = @"请输入手机号码";
            textFD.keyboardType = UIKeyboardTypePhonePad;
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
            textFD.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case kEditEmail:
        {
            self.title = @"修改电子邮箱";
            textFD.placeholder = @"请输入电子邮箱";
            textFD.keyboardType = UIKeyboardTypeEmailAddress;
        }
            break;
        case kEditCity:
        {
            self.title = @"选择区域";
            saveBtn.hidden = YES;
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

- (void)getCitys{
    [SVProgressHUD showWithStatus:@"正在获取城市列表，请稍候..."];
    int uid = [LSUserManager getUid];
    int key = [LSUserManager getKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIGETCITY stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d",uid,key]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            cityInfo = dic;
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self buildView];
            });
        }
        
        if (ret == 0) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }];
}

- (void)buildView
{
    NSArray *data = [cityInfo objectForKey:@"data"];
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scroll.userInteractionEnabled = YES;
    int i = 0;
    for (NSDictionary *dic in data) {
        NSString *cid = [dic objectForKey:@"id"];
        NSString *name = [dic objectForKey:@"name"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = cid.intValue;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1;
        [btn.layer setCornerRadius:5];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        CGRect frame = CGRectMake(70*(i%4) + 10*(i%4) +10, 44*(i/4) + 10*(i/4) +10, 65, 40);
        btn.frame = frame;
        [scroll addSubview:btn];
        i++;
    }
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH, (i/4 + 1)*60);
    [self.view addSubview:scroll];
}

#pragma mark - handleBtnClicked
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

- (void)saveBtnClicked
{
    NSString *urlStr = [APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/editInfo?uid=%d&key=%d&value=%@",[LSUserManager getUid],[LSUserManager getKey],textFD.text]];
    switch (type) {
        case kEditName:
        {// can't edit
//            urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&name=name&t=0"]];
        }
            break;
        case kEditPhone:
        {
            urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&name=tel&t=0"]];
        }
            break;
        case kEditPwd:
        {
            if (textOldPwd.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入旧密码"];
                return;
            }
            if (textNewPwd.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
                return;
            }
            if (textNewPwdAgain.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请再次输入新密码"];
                return;
            }
            if (![textNewPwdAgain.text isEqualToString:textNewPwd.text]) {
                [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
                return;
            }
            urlStr = [APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/editPwd?uid=%d&key=%d&oldpwd=%@&newpwd=%@",[LSUserManager getUid],[LSUserManager getKey],textOldPwd.text,textNewPwdAgain.text]];
        }
            break;
        case kEditQQ:
        {
            urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&name=qq&t=0"]];
        }
            break;
        case kEditEmail:
        {
            urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&name=email&t=0"]];
        }
            break;
        default:
            break;
    }
    [SVProgressHUD showWithStatus:@"修改中..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            switch (type) {
                case kEditName:
                {
                    [LSUserManager setUserName:textFD.text];
                }
                    break;
                case kEditPhone:
                {
                    [LSUserManager setUserTel:textFD.text];
                }
                    break;
                case kEditPwd:
                {
                    
                }
                    break;
                case kEditQQ:
                {
                    [LSUserManager setUserQQ:textFD.text];
                }
                    break;
                case kEditEmail:
                {
                    [LSUserManager setUserEmail:textFD.text];
                }
                    break;
                default:
                    break;
            }
            [self backBtnClicked];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

- (void)cityBtnClick:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"修改中..."];
    UIButton *btn = sender;
    NSString *city = btn.titleLabel.text;
    NSString *urlStr = [APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/editInfo?uid=%d&key=%d&value=%@&name=city&t=0",[LSUserManager getUid],[LSUserManager getKey],city]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            [LSUserManager setUserCity:city];
            [self backBtnClicked];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

#pragma mark - textFD delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == textNewPwdAgain || textField == textFD) {
        [self saveBtnClicked];
    }
    if (textField == textOldPwd) {
        [textNewPwd becomeFirstResponder];
    }
    if (textField == textNewPwd) {
        [textNewPwdAgain becomeFirstResponder];
    }
    return YES;
}

@end
