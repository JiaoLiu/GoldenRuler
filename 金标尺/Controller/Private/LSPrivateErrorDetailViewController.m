//
//  LSPrivateErrorDetailViewController.m
//  金标尺
//
//  Created by Jiao on 14-6-24.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateErrorDetailViewController.h"

@interface LSPrivateErrorDetailViewController ()
{
    LSExamView *eview;
}

@end

@implementation LSPrivateErrorDetailViewController

@synthesize qid;
@synthesize question;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        question = [[LSQuestion alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"错题详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadErrorData];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // homeBtn
//    UIButton *homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
//    [homeBtn addTarget:self action:@selector(homeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)loadErrorData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/errorInfo?key=%d&uid=%d&qid=%d",[LSUserManager getKey],[LSUserManager getUid],qid]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSDictionary *data = [dic objectForKey:@"data"];
            question = [LSQuestion initWithDictionary:data];
            [self initErrorView];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];
}

- (void)initErrorView
{
    eview = [[LSExamView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) withQuestion:question withIndex:1];
    eview.questionView.delegate = self;
    eview.questionView.dataSource = self;
//    [eview.selectBtn setTitle:@"1/1" forState:UIControlStateNormal];
    eview.selectBtn.hidden = YES;
    eview.rightImage.hidden = YES;
    [eview.wrongImage setHidden:NO];
    eview.myAnswer.text = [NSString stringWithFormat:@"你的答案:%@",question.myAser];
    eview.textFiled.hidden = YES;
    eview.yellowBtn.hidden = NO;
    eview.operTop.hidden = NO;
    eview.delegate = self;
    eview.textLabel.hidden = [LSUserManager getIsVip] ? NO : YES;
    [self.view addSubview:eview];
    
    if ([question.tid integerValue] != kDiscuss && [question.tid integerValue] != kSimpleAnswer) {
        eview.operTop.backgroundColor = RGB(240, 240, 240);
        eview.myAnswer.hidden = NO;
        eview.rtAnswer.hidden = NO;
    }
    else
    {
        [eview.wrongImage setHidden:YES];
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
    [SVProgressHUD dismiss];
}

- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

- (void)showAnalysis
{
    if (![LSUserManager getIsVip]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您现在是普通会员不能查看解析，充值成为VIP会员即可查看解析" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上充值", nil];
        [alert show];
        return;
    }
    [eview.textLabel setHidden:NO];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LSPrivateChargeViewController *vc = [[LSPrivateChargeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *answers = [question.answer componentsSeparatedByString:@"|"];
    return answers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if ([question.tid intValue] != kBlank) {
        NSArray *answers = [question.answer componentsSeparatedByString:@"|"];
        NSString *asContent = [answers objectAtIndex:indexPath.row];
        cell.textLabel.text = asContent;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize rect = [asContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.x, rect.width, rect.height);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        if ([question.tid intValue] != kSimpleAnswer && [question.tid intValue] != kDiscuss)
        {
            
            if (question.myAser != nil && [question.myAser rangeOfString:[[answers objectAtIndex:indexPath.row] substringToIndex:1]].location != NSNotFound )
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                tableView.userInteractionEnabled = NO;
            }
        }
        
        if (question.myAser != nil && [question.myAser isEqualToString:[answers objectAtIndex:indexPath.row]] ) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            tableView.userInteractionEnabled = NO;
        }
    }
    else
    {
        tableView.editing = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *answers = [question.answer componentsSeparatedByString:@"|"];
    NSString *asContent = [answers objectAtIndex:indexPath.row];
    CGSize rect = [asContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return rect.height+20;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}

@end
