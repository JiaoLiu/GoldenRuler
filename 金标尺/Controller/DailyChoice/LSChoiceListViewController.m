//
//  LSChoiceListViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-23.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSChoiceListViewController.h"

@interface LSChoiceListViewController ()

@end

@implementation LSChoiceListViewController

@synthesize dateSelectBtn;
@synthesize pickerSheet;

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
    self.title = @"每日精选";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // homeBtn
    UIButton *homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [homeBtn addTarget:self action:@selector(homeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // topBar
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [topBar setBackgroundImage:[[UIImage imageNamed:@"topBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.view addSubview:topBar];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    topLabel.text = @"请选择时间";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont systemFontOfSize:15.0];
    [topBar addSubview:topLabel];
    
    dateSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 24.5)];
    [dateSelectBtn setBackgroundImage:[UIImage imageNamed:@"mj"] forState:UIControlStateNormal];
    dateSelectBtn.center = CGPointMake(topBar.frame.size.width / 2.0, topBar.frame.size.height / 2.0);
    NSDate *curDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [dateSelectBtn setTitle:[formatter stringFromDate:curDate] forState:UIControlStateNormal];
    [dateSelectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    dateSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    dateSelectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    dateSelectBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [dateSelectBtn addTarget:self action:@selector(dateSelectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:dateSelectBtn];
    
    // actionSheet
    pickerSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    [pickerSheet setBounds:CGRectMake(0, 0, 150, 100)];
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

- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dateSelectBtnClicked
{
    [pickerSheet showInView:self.view];
    
//    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
//    pickerView.delegate = self;
//    pickerView.showsSelectionIndicator = YES;
//    pickerView.dataSource = self;
//    pickerView.tag = kPaymentPickerTag;
//    [pickerView selectRow:kPaymentSelected inComponent:0 animated:YES];
//    [pickerSheet addSubview:pickerView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [pickerSheet addSubview:datePicker];
    
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(pickerSheet.frame.size.width - 70, 0, 50, 40)];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:RGB(4, 121, 202) forState:UIControlStateNormal];
    if (IOS_VERSION < 7.0) {
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [pickerSheet addSubview:doneBtn];
}

- (void)doneBtnClicked
{
    [pickerSheet dismissWithClickedButtonIndex:0 animated:YES];
    for (id view in [pickerSheet subviews]) {
        [view removeFromSuperview];
    }
}

@end
