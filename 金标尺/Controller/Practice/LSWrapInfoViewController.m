//
//  LSWrapInfoViewController.m
//  金标尺
//
//  Created by wzq on 14/6/5.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSWrapInfoViewController.h"
#import "LSPractiseController.h"
#import "LSTestViewController.h"
#import "LSExam.h"
#import "LSPrivateChargeViewController.h"


@interface LSWrapInfoViewController ()
{

//    int cid;                         //科目id
    int key;
    int uid;

    LSExam *exam;
    NSMutableArray *questionList;
}

@end

@implementation LSWrapInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(IOS_VERSION >= 7.0)
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"套卷测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
   
    // filterBtn
//    UIButton *filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
//    [filterBtn addTarget:self action:@selector(filterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [filterBtn setTitle:@"筛选"forState:UIControlStateNormal];
//    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self getPaper];
    
    
}



- (void)backBtnClicked
{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) startTest{
    NSLog(@"开始考试");
    LSTestViewController *vc = [[LSTestViewController alloc]init];
    vc.examType = self.wrapType;
    vc.exam = exam;
    vc.questionList = questionList;

    if ([LSUserManager getIsVip] || self.wrapType == LSWrapTypeSimulation) {
        [self.navigationController pushViewController:vc animated:YES];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您现在是普通会员不能做真题套卷测试，充值成为VIP会员才可以" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上充值", nil];
        alert.tag = 99;
        [alert show];
        return;

    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 99) {
        //充值
        LSPrivateChargeViewController *vc = [[LSPrivateChargeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getPaper
{
//    cid = [LSUserManager getTCid];
    key = [LSUserManager getKey];
    uid = [LSUserManager getUid];
    
    exam = [[LSExam alloc]init];
    questionList = [NSMutableArray arrayWithCapacity:0];
    
    [SVProgressHUD showWithStatus:@"正在加载题库，请稍后..."];
    
    NSString *url = @"";
    if (_wrapType == LSWrapTypeReal) {
        url = [NSString stringWithFormat:@"?uid=%d&key=%d&tk=%d&cid=%d&city=%@",uid,key,2,_cid,_city];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else if(_wrapType == LSWrapTypeSimulation) {
        url = [NSString stringWithFormat:@"?uid=%d&key=%d&tk=%d&cid=%d",uid,key,1,_cid];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIGETEXAM stringByAppendingString:url]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        NSString *msg = [dic objectForKey:@"msg"];
        if (ret == 1) {
            NSDictionary *dt = [dic objectForKey:@"data"];
            
            if (![dt isKindOfClass:[NSDictionary class]]) {
                [SVProgressHUD showErrorWithStatus:@"暂无考题"];
//                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            
            exam.score = [[dt objectForKey:@"score"] intValue];
            exam.num = [[dt objectForKey:@"num"] intValue];
            exam.mid = [dt objectForKey:@"mid"];
            exam.time = [[dt objectForKey:@"time"] intValue];
            exam.list = questionList;
            NSArray *questions = [dt objectForKey:@"list"];
            
            for (NSDictionary *qd in questions) {
                LSQuestion *q = [LSQuestion initWithDictionary:qd];
                [questionList addObject:q];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initStartView];
                [SVProgressHUD dismiss];
            });
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }
        
    }];
    
    

}

/* 初始化开始界面 */
- (void)initStartView
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    if (_wrapType == LSWrapTypeReal) {
        frame.size.height +=30;
    }
    UIView *tv = [[UIView alloc]initWithFrame:frame];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _wrapType == LSWrapTypeReal ? @"真题套卷测试":@"模拟套卷测试";
    [tv addSubview:titleLabel];
    
    if (_wrapType == LSWrapTypeReal) {
        UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 44)];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.text = [[NSString alloc]initWithFormat:@"重庆市－%@",_city];
        [tv addSubview:subLabel];
    }
    
    
    UIView *spt = [[UIView alloc]initWithFrame:CGRectMake(0, tv.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    spt.backgroundColor = [UIColor grayColor];
    [tv addSubview:spt];
    [self.view addSubview:tv];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, tv.frame.size.height+20, SCREEN_WIDTH, 24)];
    numLabel.textColor = [UIColor redColor];
    numLabel.text = [[NSString alloc]initWithFormat:@"套卷题数：共%d题",exam.num];

    numLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, tv.frame.size.height+20+24, SCREEN_WIDTH,24)];
    scoreLabel.text = [NSString stringWithFormat:@"套卷满分：%d分",exam.score];
    scoreLabel.textColor = [UIColor redColor];

    scoreLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, tv.frame.size.height+20+24+24, SCREEN_WIDTH, 24)];
    timeLabel.textColor = [UIColor redColor];
    timeLabel.text = [NSString stringWithFormat:@"参考时间：%d分钟",exam.time];

    timeLabel.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:numLabel];
    [self.view addSubview:scoreLabel];
    [self.view addSubview:timeLabel];
    
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, tv.frame.size.height+100, SCREEN_WIDTH-40, 34)];
    startBtn.backgroundColor = RGB(86, 167, 221);
    [startBtn setTitle:@"开始测试" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startTest) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:startBtn];

}
- (void)filterBtnClicked
{
    
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

@end
