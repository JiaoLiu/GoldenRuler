//
//  LSPrivateChargeViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateChargeViewController.h"

@interface LSPrivateChargeViewController ()
{
    NSArray *titleArray;
    NSArray *dateArray;
    NSArray *paymentArray;
}

@end

@implementation LSPrivateChargeViewController

@synthesize table;
@synthesize paymentBtn;
@synthesize dateBtn;
@synthesize totalNum;
@synthesize lastDate;
@synthesize pickerSheet;
@synthesize kPaymentSelected;
@synthesize kDateSelected;
@synthesize expireDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArray = @[@"VIP贵宾会员",@"开通时长",@"支付方式",@"应付金额",@"充值后到期时间"];
        dateArray = @[@"一个月",
                      @"两个月",
                      @"三个月",
                      @"四个月",
                      @"五个月",
                      @"六个月",
                      @"七个月",
                      @"八个月",
                      @"九个月",
                      @"十个月",
                      @"十一个月",
                      @"十二个月"];
        paymentArray = @[@"支付宝",@"微信支付"];
        kDateSelected = 2;
        kPaymentSelected = 0;
        totalNum = 10 * (kDateSelected + 1);
    }
    return self;
}

- (void)calculateDate
{
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [canlendar components: NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:expireDate];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSInteger day = [components day];
    
    if (month + (kDateSelected + 1) > 12) {
        year += 1;
        month = month + (kDateSelected + 1) - 12;
    }
    else
    {
        month = month + (kDateSelected +1);
        year = year;
    }
    
    [components setMonth:month];
    [components setYear:year];
    [components setDay:day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    lastDate = [formatter stringFromDate:[canlendar dateFromComponents:components]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员充值";
    self.view.backgroundColor = [UIColor whiteColor];
    [self calculateDate];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // HeaderView
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 80)];
    headerBackView.backgroundColor = RGB(243, 243, 243);
    headerBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    headerBackView.layer.borderWidth = 0.5;
    [self.view addSubview:headerBackView];
    
    UIImageView *headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    headerImgView.image = [UIImage imageNamed:@"default_header@2x.jpg"];
    headerImgView.layer.borderWidth = 1;
    headerImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    headerImgView.clipsToBounds = YES;
    [headerBackView addSubview:headerImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImgView.frame.origin.x + headerImgView.frame.size.width + 10, 5, headerBackView.frame.size.width - 80, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"风中玉碟";
    nameLabel.textColor = [UIColor grayColor];
    [headerBackView addSubview:nameLabel];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 35, nameLabel.frame.size.width, 15)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = @"电子邮箱：341312414@qq.com";
    emailLabel.textColor = [UIColor lightGrayColor];
    emailLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:emailLabel];
    
    UILabel *vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 55, 65, 15)];
    vipLabel.textColor = [UIColor redColor];
    vipLabel.text = @"VIP贵宾会员";
    vipLabel.backgroundColor = [UIColor clearColor];
    vipLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:vipLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(vipLabel.frame.origin.x + vipLabel.frame.size.width, vipLabel.frame.origin.y, 110, 15)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    timeLabel.text = [NSString stringWithFormat:@"到期时间:%@",[formatter stringFromDate:expireDate]];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:timeLabel];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width, vipLabel.frame.origin.y, 50, 15)];
    [addBtn setTitle:@"【续期】" forState:UIControlStateNormal];
    [addBtn setTitleColor:RGB(4, 121, 202) forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:addBtn];
    
    // tableList
    NSInteger height = 35;
    table = [[UITableView alloc] initWithFrame:CGRectMake(10, headerBackView.frame.origin.y + headerBackView.frame.size.height + 7, SCREEN_WIDTH - 20, height * titleArray.count)];
    table.layer.borderColor = [UIColor lightGrayColor].CGColor;
    table.layer.borderWidth = 0.5;
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = height;
    [self.view addSubview:table];
    
    if (IOS_VERSION >= 7.0) {
        table.separatorInset = UIEdgeInsetsZero;
    }
    
    // chargebtn
    UIButton *chargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, table.frame.origin.y + table.frame.size.height + 15, SCREEN_WIDTH - 20, 40)];
    [chargeBtn setBackgroundImage:[UIImage imageWithColor:RGB(86, 167, 221) size:chargeBtn.frame.size] forState:UIControlStateNormal];
    [chargeBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    [chargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chargeBtn addTarget:self action:@selector(chargeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chargeBtn];
    
    // actionSheet
    pickerSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
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
- (void)chargeBtnClicked
{
    
}

- (void)dateBtnClicked
{
    [pickerSheet showInView:self.view];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.tag = kDatePickerTag;
    [pickerView selectRow:kDateSelected inComponent:0 animated:YES];
    [pickerSheet addSubview:pickerView];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(pickerSheet.frame.size.width - 70, 0, 50, 40)];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:RGB(4, 121, 202) forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [pickerSheet addSubview:doneBtn];
}

- (void)paymentBtnClicked
{
    [pickerSheet showInView:self.view];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.tag = kPaymentPickerTag;
    [pickerView selectRow:kPaymentSelected inComponent:0 animated:YES];
    [pickerSheet addSubview:pickerView];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(pickerSheet.frame.size.width - 70, 0, 50, 40)];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:RGB(4, 121, 202) forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [pickerSheet addSubview:doneBtn];
}

- (void)doneBtnClicked
{
    [pickerSheet dismissWithClickedButtonIndex:0 animated:YES];
    for (id view in [pickerSheet subviews]) {
        if ([view isKindOfClass:[UIPickerView class]]) {
            switch ([view tag]) {
                case kDatePickerTag:
                {
                    kDateSelected = [view selectedRowInComponent:0];
                    totalNum = 10 * (kDateSelected + 1);
                    [self calculateDate];
                }
                    break;
                case kPaymentPickerTag:
                {
                    kPaymentSelected = [view selectedRowInComponent:0];
                }
                    break;
                default:
                    break;
            }
        }
        [view removeFromSuperview];
    };
    [table reloadData];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == kDatePickerTag) {
        return 1;
    }
    if (pickerView.tag == kPaymentPickerTag) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == kDatePickerTag) {
        return dateArray.count;
    }
    if (pickerView.tag == kPaymentPickerTag) {
        return paymentArray.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == kDatePickerTag) {
        return [dateArray objectAtIndex:row];
    }
    if (pickerView.tag == kPaymentPickerTag) {
        return [paymentArray objectAtIndex:row];
    }
    return nil;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        Cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
        if (indexPath.row == 1) {
            dateBtn = [[UIButton alloc] initWithFrame:CGRectMake(Cell.frame.size.width - 110, 3, 83.5, 29)];
            [dateBtn setBackgroundImage:[UIImage imageNamed:@"chongzhi"] forState:UIControlStateNormal];
            [dateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            dateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [dateBtn addTarget:self action:@selector(dateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [Cell.contentView addSubview:dateBtn];
        }
        if (indexPath.row == 2) {
            paymentBtn = [[UIButton alloc] initWithFrame:CGRectMake(Cell.frame.size.width - 110, 3, 83.5, 29)];
            [paymentBtn setBackgroundImage:[UIImage imageNamed:@"chongzhi"] forState:UIControlStateNormal];
            [paymentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            paymentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [paymentBtn addTarget:self action:@selector(paymentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [Cell.contentView addSubview:paymentBtn];
        }
    }
    
    switch (indexPath.row) {
        case 0:
        {
            Cell.detailTextLabel.text = @"10元/月";
        }
            break;
        case 1:
        {
            [dateBtn setTitle:[dateArray objectAtIndex:kDateSelected] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [paymentBtn setTitle:[paymentArray objectAtIndex:kPaymentSelected] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            Cell.detailTextLabel.text = [NSString stringWithFormat:@"%d元",totalNum];
        }
            break;
        case 4:
        {
            Cell.detailTextLabel.text = lastDate;
        }
            break;
            
        default:
            break;
    }
    
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

@end
