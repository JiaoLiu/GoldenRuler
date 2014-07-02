//
//  LSContestRankViewController.m
//  金标尺
//
//  Created by Jiao on 14-7-2.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSContestRankViewController.h"
#import "LSTopTableViewCell.h"

@interface LSContestRankViewController ()
{
    NSMutableArray *topList;
    BOOL isLoadingMore;
    NSInteger currPage;
}

@end

@implementation LSContestRankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        topList = [[NSMutableArray alloc] init];
        currPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"排行榜";
    
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
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UIView *sp = [[UIView alloc]initWithFrame:CGRectMake(0, 29.5, SCREEN_WIDTH, 0.5)];
    sp.backgroundColor = [UIColor grayColor];
    [header addSubview:sp];
    
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
    placeLabel.textColor = [UIColor darkGrayColor];
    placeLabel.font = [UIFont systemFontOfSize:14];
    placeLabel.text =@"排名";
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 100, 30)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.text =@"用户名";
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 80, 30)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor darkGrayColor];
    timeLabel.text = @"作答时间";
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 0, 50, 30)];
    scoreLabel.font = [UIFont systemFontOfSize:14];
    scoreLabel.textColor = [UIColor darkGrayColor];
    scoreLabel.text = @"得分";
    
    [header addSubview:placeLabel];
    [header addSubview:nameLabel];
    [header addSubview:timeLabel];
    [header addSubview:scoreLabel];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = header;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    if (IOS_VERSION >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsZero;
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

//排行榜
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
        }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"服务器繁忙"];
        }
    }];
}

#pragma mark - tableview delegate
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

@end
