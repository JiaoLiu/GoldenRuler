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


@interface LSWrapInfoViewController ()
{
    NSDictionary *info;
    int cid;                         //科目id
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
        
        info = @{
                 @"name"        :@"模拟套卷测试",
                 @"course"      :@"政治",
                 @"area"        :@"渝中区",
                 @"testNum"     :@"90",
                 @"totalScore"  :@"100",
                 @"testTime"    :@"120",
                 
                 };
        
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
    UIButton *filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
    [filterBtn addTarget:self action:@selector(filterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [filterBtn setTitle:@"筛选"forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self getPaper];
    
    
}



- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) startTest{
    NSLog(@"开始考试");
    LSTestViewController *vc = [[LSTestViewController alloc]init];
    vc.examType = self.wrapType;
    vc.exam = exam;
    vc.questionList = questionList;

    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)getPaper
{
//    cid = [LSUserManager getTCid];
    key = [LSUserManager getKey];
    uid = [LSUserManager getUid];
    
    exam = [[LSExam alloc]init];
    questionList = [NSMutableArray arrayWithCapacity:0];
    
    [SVProgressHUD showWithStatus:@"正在获取考题，请稍候..."];
    
    NSString *url = @"";
    if (_wrapType == LSWrapTypeReal) {
        url = [NSString stringWithFormat:@"?uid=%d&key=%d&tk=%d&cid=%d&city=%@",uid,key,2,_cid,_city];
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
            
            NSArray *list = [dt objectForKey:@"list"];
            NSString *totalScore = [dt objectForKey:@"score"];
            NSString *time = [dt objectForKey:@"time"];
            NSString *num  = [dt objectForKey:@"num"];
            NSString *mid = [dt objectForKey:@"mid"];
            
            exam.score = [totalScore intValue];
            exam.num = [num intValue];
            exam.mid = mid;
            exam.time = [time intValue];
            
            for (NSDictionary *qs in list)
            {
                
                NSString *tid = [qs objectForKey:@"tid"];
                NSString *score = [qs objectForKey:@"score"];
                NSString *qids = [qs objectForKey:@"qid"];
                if ( [qids respondsToSelector:@selector(rangeOfString:)])
                {
                    
                    if ([qids rangeOfString:@","].location != NSNotFound) {
                        NSArray *qidList = [[qs objectForKey:@"qid"] componentsSeparatedByString:@","];
                        [questionList addObjectsFromArray:qidList];
                    } else {
                        [questionList addObject:qids];
                    }
                    
                }
                
            }
            
            exam.list = questionList;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initStartView];
                [SVProgressHUD dismiss];
            });
            
        }
        if (ret == 0) {
            [SVProgressHUD showWithStatus:@"获取失败" maskType:SVProgressHUDMaskTypeNone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
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
        subLabel.text = [[NSString alloc]initWithFormat:@"%@--%d",_city,cid];
        [tv addSubview:subLabel];
    }
    
    
    UIView *spt = [[UIView alloc]initWithFrame:CGRectMake(0, tv.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    spt.backgroundColor = [UIColor grayColor];
    [tv addSubview:spt];
    [self.view addSubview:tv];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, tv.frame.size.height+20, SCREEN_WIDTH, 24)];
    numLabel.textColor = [UIColor redColor];
    numLabel.text = [[NSString alloc]initWithFormat:@"套卷题数：共%d题",exam.num];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, tv.frame.size.height+20+24, SCREEN_WIDTH,24)];
    scoreLabel.text = [NSString stringWithFormat:@"套卷满分：%d分",exam.score];
    scoreLabel.textColor = [UIColor redColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, tv.frame.size.height+20+24+24, SCREEN_WIDTH, 24)];
    timeLabel.textColor = [UIColor redColor];
    timeLabel.text = [NSString stringWithFormat:@"参考时间：%d分钟",exam.time];
    timeLabel.textAlignment = NSTextAlignmentCenter;
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
