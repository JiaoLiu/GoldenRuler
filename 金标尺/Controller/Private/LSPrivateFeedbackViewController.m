//
//  LSPrivateFeedbackViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-6-8.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateFeedbackViewController.h"

@interface LSPrivateFeedbackViewController ()

@end

@implementation LSPrivateFeedbackViewController

@synthesize feedBackTextView;
@synthesize phoneTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // sendBtn
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // input area
    NSInteger height;
    if (iPhone5) {
        height = 140;
    }
    else height = 100;
    
    feedBackTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH - 20, height)];
    feedBackTextView.layer.cornerRadius = 3;
    feedBackTextView.layer.borderWidth = 1;
    feedBackTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    feedBackTextView.font = [UIFont systemFontOfSize:14.0];
    [feedBackTextView becomeFirstResponder];
    [self.view addSubview:feedBackTextView];
    
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, feedBackTextView.frame.origin.y + height + 10, SCREEN_WIDTH - 20, 44)];
    phoneTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.placeholder = @"请输入电话号码";
    phoneTextField.layer.cornerRadius = 3;
    phoneTextField.layer.borderWidth = 1;
    phoneTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTextField];
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
    [SVProgressHUD dismiss];
}

- (void)sendBtnClicked
{
    if (feedBackTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入反馈意见"];
        return;
    }
    if (phoneTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入电话号码"];
        return;
    }
    [SVProgressHUD showWithStatus:@"提交中" maskType:SVProgressHUDMaskTypeBlack];
    [self sendFeedBack];
}

- (void)sendFeedBack
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Index/message?client=apple&tel=%@&content=%@",phoneTextField.text,feedBackTextView.text]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"msg"]];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

@end
