//
//  LSTestResultViewController.m
//  金标尺
//
//  Created by wzq on 14/6/26.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSTestResultViewController.h"

@interface LSTestResultViewController ()

@end

@implementation LSTestResultViewController

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
    self.title = @"套卷测试";
    
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
    
    //tabBar
    LSTabBar *tabBar = [[LSTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    tabBar.items = @[@"成绩统计",@"排行榜"];
    tabBar.selectedItem = 0;

    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    
    [self initResultView];
    
}

- (void)initResultView
{
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 30, 24)];
    lb.text = @"试卷得分";
    lb.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lb];
    
    UILabel *scoreLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 80, 30)];
    scoreLable.text = [NSString stringWithFormat:@"%d",_myscore];
    scoreLable.backgroundColor = [UIColor orangeColor];
    scoreLable.textColor = [UIColor whiteColor];
    scoreLable.font = [UIFont boldSystemFontOfSize:18];
    scoreLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:scoreLable];
    
    UILabel *avgScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 75, 70, 20)];
    avgScoreLabel.text = @"平均得分";
    avgScoreLabel.font = [UIFont systemFontOfSize:12];
    avgScoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:avgScoreLabel];
    
    UILabel *avgScore = [[UILabel alloc] initWithFrame:CGRectMake(150, 90, 70, 20)];
    avgScore.text = [NSString stringWithFormat:@"%d分",99];
    avgScore.font = [UIFont systemFontOfSize:12];
    avgScore.textColor = [UIColor grayColor];
    avgScore.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:avgScore];
    
    
    UILabel *allScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 75, 70, 20)];
    allScoreLabel.text = @"试卷总分";
    allScoreLabel.font = [UIFont systemFontOfSize:12];
    allScoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:allScoreLabel];
    
    UILabel *allScore = [[UILabel alloc] initWithFrame:CGRectMake(230, 90, 70, 20)];
    allScore.text = [NSString stringWithFormat:@"%d分",_totalscore];
    allScore.font = [UIFont systemFontOfSize:12];
    allScore.textColor = [UIColor grayColor];
    allScore.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:allScore];
    
    
    
    
    
    UILabel *lbt = [[UILabel alloc]initWithFrame:CGRectMake(30, 130, SCREEN_WIDTH - 30, 24)];
    lbt.text = @"试卷用时";
    lbt.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lbt];
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 160, 80, 30)];
    timeLable.text = [NSString stringWithFormat:@"%02d:%02d",_usedtime/60,_usedtime%60];
    timeLable.backgroundColor = [UIColor orangeColor];
    timeLable.textColor = [UIColor whiteColor];
    timeLable.font = [UIFont boldSystemFontOfSize:18];
    timeLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLable];
    
    UILabel *avgTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 155, 70, 20)];
    avgTimeLabel.text = @"平均用时";
    avgTimeLabel.font = [UIFont systemFontOfSize:12];
    avgTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:avgTimeLabel];
    
    UILabel *avgTime = [[UILabel alloc] initWithFrame:CGRectMake(150, 175, 70, 20)];
    avgTime.text = [NSString stringWithFormat:@"%02d分%02d秒",9,9];
    avgTime.font = [UIFont systemFontOfSize:12];
    avgTime.textColor = [UIColor grayColor];
    avgTime.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:avgTime];
    
    
    UILabel *allTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 155, 70, 20)];
    allTimeLabel.text = @"考试时间";
    allTimeLabel.font = [UIFont systemFontOfSize:12];
    allTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:allTimeLabel];
    
    UILabel *allTime = [[UILabel alloc] initWithFrame:CGRectMake(230, 175, 70, 20)];
    allTime.text = [NSString stringWithFormat:@"%d分钟",_time];
    allTime.font = [UIFont systemFontOfSize:12];
    allTime.textColor = [UIColor grayColor];
    allTime.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:allTime];

    
    UIView *sq = [[UIView alloc] initWithFrame:CGRectMake(30, 200, SCREEN_WIDTH-60, 0.5)];
    sq.backgroundColor = [UIColor grayColor];
    [self.view addSubview:sq];
    
    UILabel *mc = [[UILabel alloc] initWithFrame:CGRectMake(30, 220, 100, 20)];
    mc.text =@"参考排名120名";
    mc.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:mc];
    
    UILabel *tps = [[UILabel alloc] initWithFrame:CGRectMake(200, 220, 100, 20)];
    tps.text =@"做答人次1000名";
    tps.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tps];
    
    UIButton *readAns = [[UIButton alloc]initWithFrame:CGRectMake(30, 255, 260, 35)];
    readAns.backgroundColor = RGB(4, 121, 202);
    [readAns setTitle:@"查看答案及解析" forState:UIControlStateNormal];
    [readAns setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    readAns.layer.cornerRadius = 5;
    [self.view addSubview:readAns];
    
    UIButton *reDo = [[UIButton alloc]initWithFrame:CGRectMake(30, 305, 260, 35)];
    reDo.backgroundColor = [UIColor lightGrayColor];
    [reDo setTitle:@"重新作答" forState:UIControlStateNormal];
    [reDo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reDo.layer.cornerRadius = 5;
    [self.view addSubview:reDo];
    
    UIButton *share = [[UIButton alloc]initWithFrame:CGRectMake(30, 355, 260, 35)];
    share.backgroundColor = [UIColor lightGrayColor];
    [share setTitle:@"分享..." forState:UIControlStateNormal];
    share.layer.cornerRadius = 5;

    [self.view addSubview:share];
    

}

-(void)SelectItemAtIndex:(NSNumber *)index
{
    switch (index.intValue) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -| nav btn click
- (void)homeBtnClicked
{
    [SVProgressHUD dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void)backBtnClicked
{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
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
