//
//  LSChoiceListViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-23.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSChoiceListViewController.h"
#import "LSChoiceDetailViewController.h"

#define kCatePicker_TAG 100

@interface LSChoiceListViewController ()
{
    NSDate *selectedDate;
    NSMutableArray *dataArray;
    NSMutableArray *cateArray;
    NSInteger msgPage;
    NSInteger selectedCate;
    BOOL hasMore;
    UILabel *emptyLabel;
}

@end

@implementation LSChoiceListViewController

@synthesize dateSelectBtn;
@synthesize catSelectBtn;
@synthesize pickerSheet;
@synthesize choiceTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedDate = nil;
        dataArray = [[NSMutableArray alloc] init];
        cateArray = [[NSMutableArray alloc] init];
        msgPage = 1;
//        [self loadDataWithPage:msgPage size:0 time:[NSString stringFromDate:selectedDate Formatter:@"yyyy-MM-dd"]];
        [self loadCategory];
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    }
    return self;
}

- (void)loadCategory
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/getCate?key=%d&uid=%d&tid=2&cid=2",[LSUserManager getKey],[LSUserManager getUid]]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSArray *tempArray = [dic objectForKey:@"data"];
            NSInteger num;
            if ([tempArray isKindOfClass:[NSNull class]]) {
                num = 0;
                catSelectBtn.enabled = NO;
            }
            else num = tempArray.count;
            for (int i = 0; i < num; i++) {
                NSDictionary *dic = [tempArray objectAtIndex:i];
                if (![cateArray containsObject:dic]) {
                    [cateArray addObject:dic];
                }
            }
            selectedCate = 2;
            [self loadDataWithPage:msgPage size:0 time:@""];
//            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

- (void)loadDataWithPage:(int)page size:(int)pageSize time:(NSString *)time
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/newList?key=%d&uid=%d&page=%d&pagesize=%d&cid=%d&time=%@",[LSUserManager getKey],[LSUserManager getUid],page,pageSize,selectedCate,time]]]];
    if (pageSize == 0) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/newList?key=%d&uid=%d&page=%d&cid=%d&time=%@",[LSUserManager getKey],[LSUserManager getUid],page,selectedCate,time]]]];
    }
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSArray *tempArray = [dic objectForKey:@"data"];
            NSInteger num = tempArray.count;
            if (num >= pageSize) {
                msgPage += 1;
                hasMore = YES;
                [LSSheetNotify dismiss];
            }
            else
            {
                hasMore = NO;
                [LSSheetNotify showOnce:@"暂无更多精选"];
            }
            for (int i = 0; i < num; i++) {
                NSDictionary *dic = [tempArray objectAtIndex:i];
                if (![dataArray containsObject:dic]) {
                    [dataArray addObject:dic];
                }
            }
            [choiceTable reloadData];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
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
    
//    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
//    topLabel.text = @"请选择时间";
//    topLabel.textColor = [UIColor whiteColor];
//    topLabel.backgroundColor = [UIColor clearColor];
//    topLabel.textAlignment = NSTextAlignmentCenter;
//    topLabel.font = [UIFont systemFontOfSize:15.0];
//    [topBar addSubview:topLabel];
    
    catSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 24.5)];
    [catSelectBtn setBackgroundImage:[UIImage imageNamed:@"mj"] forState:UIControlStateNormal];
    catSelectBtn.center = CGPointMake(topBar.frame.size.width / 2.0 - 80, topBar.frame.size.height / 2.0);
    [catSelectBtn setTitle:@"请选择分类" forState:UIControlStateNormal];
    [catSelectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    catSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    catSelectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    catSelectBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [catSelectBtn addTarget:self action:@selector(catSelectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:catSelectBtn];
    
    dateSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 24.5)];
    [dateSelectBtn setBackgroundImage:[UIImage imageNamed:@"mj"] forState:UIControlStateNormal];
    dateSelectBtn.center = CGPointMake(topBar.frame.size.width / 2.0 + 80, topBar.frame.size.height / 2.0);
    [dateSelectBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
    [dateSelectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    dateSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    dateSelectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    dateSelectBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [dateSelectBtn addTarget:self action:@selector(dateSelectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:dateSelectBtn];
    
    // choiceTabel
    choiceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, topBar.frame.origin.y + topBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - (64 + topBar.frame.size.height))];
    choiceTable.tableFooterView = [UIView new];
    choiceTable.delegate = self;
    choiceTable.dataSource = self;
    if (IOS_VERSION >= 7.0) {
        choiceTable.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:choiceTable];
    
    // emptyLabel
    int y = (choiceTable.frame.size.height - 20) / 2;
    emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 20)];
    emptyLabel.font = [UIFont systemFontOfSize:16];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"暂无精选";
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
    [choiceTable addSubview:emptyLabel];
    
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
    [SVProgressHUD dismiss];
    [LSSheetNotify dismiss];
}

- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
    [LSSheetNotify dismiss];
}

- (void)dateSelectBtnClicked
{
    [pickerSheet showInView:self.view];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    if (selectedDate == nil) {
        datePicker.date = [NSDate date];
    }
    else datePicker.date = selectedDate;
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

-(void)catSelectBtnClicked
{
    [pickerSheet showInView:self.view];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.tag = kCatePicker_TAG;
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
        if ([view isKindOfClass:[UIDatePicker class]]) {
            UIDatePicker *picker = (UIDatePicker *)view;
            NSDate *date = picker.date;
            selectedDate = date;
            [dateSelectBtn setTitle:[NSString stringFromDate:date Formatter:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            msgPage = 1;
            [dataArray removeAllObjects];
            [self loadDataWithPage:msgPage size:0 time:[NSString stringFromDate:selectedDate Formatter:@"yyyy-MM-dd"]];
            [SVProgressHUD showWithStatus:@"加载中..."];
        }
        if ([view isKindOfClass:[UIPickerView class]] && [view tag] == kCatePicker_TAG) {
            [catSelectBtn setTitle:[[cateArray objectAtIndex:[view selectedRowInComponent:0]] objectForKey:@"name"] forState:UIControlStateNormal];
//            [dateSelectBtn setTitle:[NSString stringFromDate:selectedDate Formatter:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            selectedCate = [[[cateArray objectAtIndex:[view selectedRowInComponent:0]] objectForKey:@"cid"] integerValue];
            [dataArray removeAllObjects];
            if (selectedDate == nil) {
                [self loadDataWithPage:msgPage size:0 time:@""];
            }
            else [self loadDataWithPage:msgPage size:0 time:[NSString stringFromDate:selectedDate Formatter:@"yyyy-MM-dd"]];
            [SVProgressHUD showWithStatus:@"加载中..."];
        }
        [view removeFromSuperview];
    }
}

#pragma mark - pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == kCatePicker_TAG) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == kCatePicker_TAG) {
        return cateArray.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == kCatePicker_TAG) {
        return [[cateArray objectAtIndex:row] objectForKey:@"name"];
    }
    return nil;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    emptyLabel.hidden = dataArray.count > 0 ? YES : NO;
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    Cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [LSSheetNotify dismiss];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LSChoiceDetailViewController *detailVC = [[LSChoiceDetailViewController alloc] init];
    detailVC.urlStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"url"];
    detailVC.detailType = kDailyChoice;
    detailVC.urlTitle = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGSize size = scrollView.contentSize;
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + scrollView.frame.size.height > size.height + 50 && hasMore) {
        [self loadDataWithPage:msgPage size:10 time:[NSString stringFromDate:selectedDate Formatter:@"yyyy-MM-dd"]];
        [LSSheetNotify showProgress:@"加载更多"];
    }
}

@end
