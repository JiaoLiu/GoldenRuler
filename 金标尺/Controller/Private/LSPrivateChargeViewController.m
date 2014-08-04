//
//  LSPrivateChargeViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateChargeViewController.h"
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "AlixPayOrder.h"
#import "PartnerConfig.h"
#import "DataVerifier.h"
#import "DataSigner.h"

@interface LSPrivateChargeViewController ()
{
    NSArray *titleArray;
    NSArray *dateArray;
    NSArray *paymentArray;
    UILabel *vipLabel;
    UILabel *timeLabel;
    UIButton *addBtn;
}

@end

@implementation LSPrivateChargeViewController

@synthesize table;
@synthesize paymentBtn;
@synthesize dateBtn;
@synthesize totalNum;
@synthesize price;
@synthesize lastDate;
@synthesize pickerSheet;
@synthesize kPaymentSelected;
@synthesize kDateSelected;
@synthesize expireDate;
@synthesize isVip;

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
        paymentArray = @[@"快捷支付"/*,@"微信支付"*/];
        kDateSelected = 2;
        kPaymentSelected = 0;
//        price = 10;
//        totalNum = price * (kDateSelected + 1);
        isVip = [LSUserManager getIsVip];
    }
    return self;
}

- (void)loadDataWith:(NSInteger)month endTime:(NSString *)time
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/renew?key=%d&uid=%d&month=%d&etime=%@",[LSUserManager getKey],[LSUserManager getUid],month,time]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSDictionary *data = [dic objectForKey:@"data"];
            price = [[data objectForKey:@"price"] integerValue];
            lastDate = [data objectForKey:@"time"];
            totalNum = price * month * [[data objectForKey:@"zhekou"] integerValue] / 10;
            [table reloadData];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
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
//    [self calculateDate];
    
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
    headerImgView.image = [LSUserManager getUserImg];
    headerImgView.layer.borderWidth = 1;
    headerImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    headerImgView.clipsToBounds = YES;
    [headerBackView addSubview:headerImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImgView.frame.origin.x + headerImgView.frame.size.width + 10, 5, headerBackView.frame.size.width - 80, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [LSUserManager getUserName];
    nameLabel.textColor = [UIColor grayColor];
    [headerBackView addSubview:nameLabel];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 35, nameLabel.frame.size.width, 15)];
    emailLabel.backgroundColor = [UIColor clearColor];
    if ([LSUserManager getUserEmail].length != 0) {
        emailLabel.text = [NSString stringWithFormat:@"电子邮箱：%@",[LSUserManager getUserEmail]];
        emailLabel.hidden = NO;
    }
    else emailLabel.hidden = YES;
    emailLabel.textColor = [UIColor grayColor];
    emailLabel.font = [UIFont systemFontOfSize:11];
    emailLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [headerBackView addSubview:emailLabel];
    
    // vip area
    vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 55, 65, 15)];
    vipLabel.textColor = [UIColor redColor];
    vipLabel.text = @"VIP贵宾会员";
    vipLabel.backgroundColor = [UIColor clearColor];
    vipLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:vipLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(vipLabel.frame.origin.x + vipLabel.frame.size.width, vipLabel.frame.origin.y, 110, 15)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd"];
    timeLabel.text = [NSString stringWithFormat:@"到期时间:%@",[formatter stringFromDate:expireDate]];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:11];
    [headerBackView addSubview:timeLabel];
    
//    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width, vipLabel.frame.origin.y, 50, 15)];
//    [addBtn setTitle:@"【续期】" forState:UIControlStateNormal];
//    [addBtn setTitleColor:RGB(4, 121, 202) forState:UIControlStateNormal];
//    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    addBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//    addBtn.userInteractionEnabled = NO;
//    [headerBackView addSubview:addBtn];
    
    if (!isVip) {
        vipLabel.text = @"普通会员";
        vipLabel.textColor = [UIColor grayColor];
        timeLabel.hidden = YES;
//        addBtn.frame = CGRectMake(vipLabel.frame.origin.x + vipLabel.frame.size.width - 20, vipLabel.frame.origin.y, 100, 15);
//        [addBtn setTitle:@"【开通VIP会员】" forState:UIControlStateNormal];
    }
    
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
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self loadDataWith:kDateSelected + 1 endTime:[NSString stringFromDate:expireDate Formatter:@"yyy-MM-dd"]];
    
    _result = @selector(paymentResult:);
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
    /*
	 *生成订单信息及签名
	 *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
	 */
    
    NSString *appScheme = @"AlipaySdkDemo";
    NSString* orderInfo = [self getOrderInfo];
    NSString* signedStr = [self doRsa:orderInfo];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];

    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
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
    if (IOS_VERSION < 7.0) {
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
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
        if ([view isKindOfClass:[UIPickerView class]]) {
            switch ([view tag]) {
                case kDatePickerTag:
                {
                    kDateSelected = [view selectedRowInComponent:0];
//                    totalNum = price * (kDateSelected + 1);
//                    [self calculateDate];
                    [SVProgressHUD showWithStatus:@"加载中..."];
                    [self loadDataWith:kDateSelected + 1 endTime:[NSString stringFromDate:expireDate Formatter:@"yyy-MM-dd"]];
                }
                    break;
                case kPaymentPickerTag:
                {
                    kPaymentSelected = [view selectedRowInComponent:0];
                    [table reloadData];
                }
                    break;
                default:
                    break;
            }
        }
        [view removeFromSuperview];
    };
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
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
            Cell.detailTextLabel.text = [NSString stringWithFormat:@"%d元/月",price];
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

#pragma mark - AliPay Method
//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                [LSUserManager setIsVip:1];
                [LSUserManager setEndTime:lastDate];
                [self.navigationController popViewControllerAnimated:YES];
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

-(NSString*)getOrderInfo
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = [self getTradeNO]; //订单ID（由商家自行制定）
	order.productName = @"会员充值"; //商品标题
	order.productDescription = @"事考重庆"; //商品描述
	order.amount = [NSString stringWithFormat:@"%d",totalNum]; //商品价格
    order.returnUrl = @"goldenRuler://";
	order.notifyURL =  @"http://demo.deepinfo.cn/jbc2/index.php/Index/notifyul"; //回调URL
	
	return [order description];
}

- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

- (NSString *)getTradeNO
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/payment?key=%d&uid=%d&month=%d&etime=%@&price=%d&t=2",[LSUserManager getKey],[LSUserManager getUid],kDateSelected + 1,lastDate,totalNum]]]];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *dic = [data mutableObjectFromJSONData];
    if ([[dic objectForKey:@"status"] integerValue] == 1) {
        return [dic objectForKey:@"data"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        return nil;
    }
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    [LSUserManager setIsVip:1];
    [LSUserManager setEndTime:lastDate];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%@",result);
}

@end
