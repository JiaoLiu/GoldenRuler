//
//  LSTestResultViewController.m
//  金标尺
//
//  Created by wzq on 14/6/26.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSTestResultViewController.h"
#import "LSTopTableViewCell.h"
#import "LSWrapPracticeViewController.h"
#import "LSAnalysisViewController.h"

@interface LSTestResultViewController ()
{
    int count;
    int mytop;
    NSString *avgTimeStr;
    NSString *avgScoreStr;
    
    NSMutableArray *topList;
    UIView *resultView;
    LSTabBar *tabBar;
    
    BOOL isLoadingMore;
}
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
    tabBar = [[LSTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    tabBar.items = @[@"成绩统计",@"排行榜"];
    tabBar.selectedItem = 0;
    
    tabBar.delegate = self;
    
    topList = [NSMutableArray arrayWithCapacity:0];
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UIView *sp = [[UIView alloc]initWithFrame:CGRectMake(0, 29.5, SCREEN_WIDTH, 0.5)];
    sp.backgroundColor = [UIColor grayColor];
    [header addSubview:sp];
    
    
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
    placeLabel.textColor = [UIColor darkGrayColor];
    placeLabel.font = [UIFont systemFontOfSize:14];
    placeLabel.backgroundColor = [UIColor clearColor];
    placeLabel.text =@"排名";
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 100, 30)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text =@"用户名";
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 80, 30)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor darkGrayColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.text = @"作答时间";
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 0, 50, 30)];
    scoreLabel.font = [UIFont systemFontOfSize:14];
    scoreLabel.textColor = [UIColor darkGrayColor];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.text = @"得分";
    
    [header addSubview:placeLabel];
    [header addSubview:nameLabel];
    [header addSubview:timeLabel];
    [header addSubview:scoreLabel];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tabBar.frame.origin.y+tabBar.frame.size.height, SCREEN_WIDTH, self.view.bounds.size.height - tabBar.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setHidden:YES];
    _tableView.tableHeaderView = header;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    if (IOS_VERSION >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }

//    [self initResultView];
    [self getExamTop];
    

    [self.view addSubview:tabBar];
    
    
    
    
}

- (void)initResultView
{
    resultView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:resultView];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 30, 24)];
    lb.text = @"试卷得分";
    lb.font = [UIFont systemFontOfSize:15];
    [resultView addSubview:lb];
    
    UILabel *scoreLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 80, 30)];
    scoreLable.text = [NSString stringWithFormat:@"%d",_myscore];
    scoreLable.backgroundColor = [UIColor orangeColor];
    scoreLable.textColor = [UIColor whiteColor];
    scoreLable.font = [UIFont boldSystemFontOfSize:18];
    scoreLable.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:scoreLable];
    
    UILabel *avgScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 75, 70, 20)];
    avgScoreLabel.text = @"平均得分";
    avgScoreLabel.font = [UIFont systemFontOfSize:12];
    avgScoreLabel.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:avgScoreLabel];
    
    UILabel *avgScore = [[UILabel alloc] initWithFrame:CGRectMake(150, 90, 70, 20)];
    avgScore.text = [NSString stringWithFormat:@"%@",avgScoreStr];
    avgScore.font = [UIFont systemFontOfSize:12];
    avgScore.textColor = [UIColor grayColor];
    avgScore.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:avgScore];
    
    
    UILabel *allScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 75, 70, 20)];
    allScoreLabel.text = @"试卷总分";
    allScoreLabel.font = [UIFont systemFontOfSize:12];
    allScoreLabel.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:allScoreLabel];
    
    UILabel *allScore = [[UILabel alloc] initWithFrame:CGRectMake(230, 90, 70, 20)];
    allScore.text = [NSString stringWithFormat:@"%d分",_totalscore];
    allScore.font = [UIFont systemFontOfSize:12];
    allScore.textColor = [UIColor grayColor];
    allScore.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:allScore];
    
    
    
    
    
    UILabel *lbt = [[UILabel alloc]initWithFrame:CGRectMake(30, 130, SCREEN_WIDTH - 30, 24)];
    lbt.text = @"试卷用时";
    lbt.font = [UIFont systemFontOfSize:15];
    [resultView addSubview:lbt];
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 160, 80, 30)];
    timeLable.text = [NSString stringWithFormat:@"%02d:%02d",_usedtime/60,_usedtime%60];
    timeLable.backgroundColor = [UIColor orangeColor];
    timeLable.textColor = [UIColor whiteColor];
    timeLable.font = [UIFont boldSystemFontOfSize:18];
    timeLable.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:timeLable];
    
    UILabel *avgTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 155, 70, 20)];
    avgTimeLabel.text = @"平均用时";
    avgTimeLabel.font = [UIFont systemFontOfSize:12];
    avgTimeLabel.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:avgTimeLabel];
    
    UILabel *avgTime = [[UILabel alloc] initWithFrame:CGRectMake(150, 175, 70, 20)];
    avgTime.text = [NSString stringWithFormat:@"%@",avgTimeStr];
    avgTime.font = [UIFont systemFontOfSize:12];
    avgTime.textColor = [UIColor grayColor];
    avgTime.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:avgTime];
    
    
    UILabel *allTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 155, 70, 20)];
    allTimeLabel.text = @"考试时间";
    allTimeLabel.font = [UIFont systemFontOfSize:12];
    allTimeLabel.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:allTimeLabel];
    
    UILabel *allTime = [[UILabel alloc] initWithFrame:CGRectMake(230, 175, 70, 20)];
    allTime.text = [NSString stringWithFormat:@"%d分钟",_time];
    allTime.font = [UIFont systemFontOfSize:12];
    allTime.textColor = [UIColor grayColor];
    allTime.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:allTime];

    
    UIView *sq = [[UIView alloc] initWithFrame:CGRectMake(30, 200, SCREEN_WIDTH-60, 0.5)];
    sq.backgroundColor = [UIColor grayColor];
    [resultView addSubview:sq];
    
    UILabel *mc = [[UILabel alloc] initWithFrame:CGRectMake(30, 220, 100, 20)];
    mc.text =[NSString stringWithFormat:@"参考排名%d名",mytop];
    mc.font = [UIFont systemFontOfSize:12];
    [resultView addSubview:mc];
    
    UILabel *tps = [[UILabel alloc] initWithFrame:CGRectMake(200, 220, 100, 20)];
    tps.text =[NSString stringWithFormat:@"做答人次%d名",count];
    tps.font = [UIFont systemFontOfSize:12];
    [resultView addSubview:tps];
    
    UIButton *readAns = [[UIButton alloc]initWithFrame:CGRectMake(30, 255, 260, 35)];
    readAns.backgroundColor = RGB(4, 121, 202);
    [readAns setTitle:@"查看答案及解析" forState:UIControlStateNormal];
    [readAns addTarget:self action:@selector(checkAnlysis) forControlEvents:UIControlEventTouchUpInside];
    [readAns setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    readAns.layer.cornerRadius = 5;
    [resultView addSubview:readAns];
    
    UIButton *reDo = [[UIButton alloc]initWithFrame:CGRectMake(30, 305, 260, 35)];
    reDo.backgroundColor = [UIColor lightGrayColor];
    [reDo setTitle:@"重新作答" forState:UIControlStateNormal];
    [reDo addTarget:self action:@selector(redoExam) forControlEvents:UIControlEventTouchUpInside];
    [reDo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reDo.layer.cornerRadius = 5;
    [resultView addSubview:reDo];
    
    UIButton *share = [[UIButton alloc]initWithFrame:CGRectMake(30, 355, 260, 35)];
    share.backgroundColor = [UIColor lightGrayColor];
    [share setTitle:@"分享..." forState:UIControlStateNormal];
    share.layer.cornerRadius = 5;

    [resultView addSubview:share];
    
    [self.view bringSubviewToFront:tabBar];
}

-(void)SelectItemAtIndex:(NSNumber *)index
{
    switch (index.intValue) {
        case 0:
        {
            [_tableView setHidden: YES];
            [resultView setHidden:NO];
//            [self initResultView];
        }
            break;
        case 1:
        {
            [_tableView setHidden: NO];
            [resultView setHidden:YES];
            [self getAllTop];
        }
            break;
            
        default:
            break;
    }
}


- (void)getExamTop
{
    [SVProgressHUD showWithStatus:@"统计成绩中..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/examTop?uid=%d&key=%d&mid=%d&id=%d",[LSUserManager getUid],[LSUserManager getKey],_mid,_examId]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        NSString *msg = [dic objectForKey:@"msg"];
        if (ret == 1)
        {
            NSDictionary *dt = [dic objectForKey:@"data"];
            count = [[dt objectForKey:@"count"] intValue];
            mytop = [[dt objectForKey:@"mytop"] intValue];
            avgTimeStr = [dt objectForKey:@"meantime"];
            avgScoreStr = [dt objectForKey:@"meanscore"];
            [self initResultView];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    
    
    }];
}

//排行榜
int currPage = 1;
- (void)getAllTop
{
    
    if (!isLoadingMore) {
         [SVProgressHUD showWithStatus:@"正在统计..."];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/Top?uid=%d&key=%d&page=%d&pagesize=%d",[LSUserManager getUid],[LSUserManager getKey],currPage++,20]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
//        NSString *msg = [dic objectForKey:@"msg"];
        if (ret == 1)
        {
            [SVProgressHUD dismiss];
            NSArray *temp = [dic objectForKey:@"data"];
            
            [topList addObjectsFromArray:temp];
            
            [_tableView reloadData];
            if (topList.count % 20 != 0) {
                isLoadingMore = YES;
            }else
            {
            isLoadingMore = NO;
            }
            [_tableView.tableFooterView setHidden:YES];
            for (UIView *view in _tableView.tableFooterView.subviews) {
                [view removeFromSuperview];
            }
            
            [self.view bringSubviewToFront:tabBar];
        }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"服务器繁忙"];
        }
        
        
    }];


}

#pragma mark -tableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LSTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (topList.count >0) {
        NSDictionary *dict = [topList objectAtIndex:indexPath.row];

        cell.placeLabel.text = [NSString stringWithFormat:@"%02d",indexPath.row+1];
        cell.placeLabel.backgroundColor = [UIColor redColor];
        cell.nameLabel.text =[dict objectForKey:@"name"];
        cell.timeLabel.text = [dict objectForKey:@"etime"];
        cell.scoreLabel.text = [NSString stringWithFormat:@"%@分",[dict objectForKey:@"score"]];
    }
   
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topList.count;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y > 20) {
        [self loadDataBegin];

    }
}


- (void)loadDataBegin
{
    if (isLoadingMore == NO)
        
    {
        
        isLoadingMore = YES;
        
        UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)];
        UILabel *loading = [[UILabel alloc]initWithFrame:CGRectMake(100, 12, 60, 20)];
        loading.text = @"正在加载...";
        loading.font = [UIFont systemFontOfSize:12];
        loading.textColor = [UIColor lightGrayColor];
        
        
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        [tableFooterActivityIndicator startAnimating];
        [_tableView.tableFooterView setHidden:NO];
        [_tableView.tableFooterView addSubview:tableFooterActivityIndicator];
        [_tableView.tableFooterView addSubview:loading];
        [self loadDataing];
        
    }
}

- (void)loadDataing
{
    [self getAllTop];
}


- (void)redoExam
{

    if([_delegate respondsToSelector:@selector(redoExam)])
    {
        [_delegate redoExam];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void) checkAnlysis
{
    if([_delegate respondsToSelector:@selector(checkAnalysis)])
    {
//        [_delegate checkAnalysis];
        LSAnalysisViewController *vc = [[LSAnalysisViewController alloc]init];
        vc.questionList = _questionList;
        [self.navigationController pushViewController:vc animated:YES];
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

    NSArray *array = self.navigationController.viewControllers;
    LSWrapPracticeViewController *vc = [[LSWrapPracticeViewController alloc]init];
    for (UIViewController *vv in array) {
        if ([vv isKindOfClass:vc.class]) {
            vc = (LSWrapPracticeViewController*)vv;
        }
    }
    [self.navigationController popToViewController:vc animated:YES];
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
