//
//  LSPrivateCommentViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-22.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateCommentViewController.h"
#import "LSPrivateCommentDetailViewController.h"

@interface LSPrivateCommentViewController ()
{
    NSMutableArray *dataArray;
    NSInteger msgPage;
    BOOL hasMore;
    UILabel *emptyLabel;
}

@end

@implementation LSPrivateCommentViewController

@synthesize commentTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        dataArray = [[NSMutableArray alloc] init];
//        msgPage = 1;
//        [self loadDataWithPage:msgPage size:0];
//        [SVProgressHUD showWithStatus:@"加载中"];
    }
    return self;
}

- (void)loadDataWithPage:(int)page size:(int)pageSize
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/myComment?key=%d&uid=%d&page=%d&pagesize=%d&type=1",[LSUserManager getKey],[LSUserManager getUid],page,pageSize]]]];
    if (pageSize == 0) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/myComment?key=%d&uid=%d&page=%d&type=1",[LSUserManager getKey],[LSUserManager getUid],page]]]];
    }
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSArray *tempArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            NSInteger num = tempArray.count;
            if (num >= pageSize) {
                msgPage += 1;
                hasMore = YES;
                [LSSheetNotify dismiss];
            }
            else
            {
                hasMore = NO;
                [LSSheetNotify showOnce:@"暂无更多评论"];
            }
            for (int i = 0; i < num; i++) {
                NSDictionary *dic = [tempArray objectAtIndex:i];
                if (![dataArray containsObject:dic]) {
                    [dataArray addObject:dic];
                }
            }
            [commentTable reloadData];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];

//    for (int i = 0; i < 100; i++) {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"-%d-大家觉得这个有道理么11111111111",i],@"title",@"2014年4月24 10:21:34",@"time", nil];
//        [dataArray insertObject:dic atIndex:i];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的评论";
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
    
    // msgTable
    commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT - 20)];
    commentTable.delegate = self;
    commentTable.dataSource = self;
    commentTable.tableFooterView = [UIView new];
    [self.view addSubview:commentTable];
    
    if (IOS_VERSION >= 7.0) {
        commentTable.separatorInset = UIEdgeInsetsZero;
    }
    
    // emptyLabel
    int y = (commentTable.frame.size.height - 20) / 2;
    emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 20)];
    emptyLabel.font = [UIFont systemFontOfSize:16];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"暂无评论";
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
    [commentTable addSubview:emptyLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [dataArray removeAllObjects];
    msgPage = 1;
    [self loadDataWithPage:msgPage size:0];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
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

- (void)redBtnClicked:(UIButton *)sender
{
    [LSSheetNotify dismiss];
    LSPrivateCommentDetailViewController *detailVC = [[LSPrivateCommentDetailViewController alloc] init];
    detailVC.qid = [[[dataArray objectAtIndex:sender.tag] objectForKey:@"qid"] integerValue];
    detailVC.myComment.username = [[dataArray objectAtIndex:sender.tag] objectForKey:@"name"];
    detailVC.myComment.dateStr = [[dataArray objectAtIndex:sender.tag] objectForKey:@"addtime"];
    detailVC.myComment.content = [[dataArray objectAtIndex:sender.tag] objectForKey:@"content"];
    [self.navigationController pushViewController:detailVC animated:YES];
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
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 70, 44)];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = 100;
        [Cell.contentView addSubview:titleLabel];
        
        UIButton *redBtn = [[UIButton alloc] initWithFrame:CGRectMake(Cell.frame.size.width - 50, 11, 37.5, 22)];
        [redBtn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [redBtn setTitle:@"查看" forState:UIControlStateNormal];
        [redBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [redBtn addTarget:self action:@selector(redBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        redBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [Cell.contentView addSubview:redBtn];
    }
    
    for (UIView *view in [Cell.contentView subviews]) {
        if (view.tag == 100 && [view isKindOfClass:[UILabel class]]) {
            UILabel *title = (UILabel *)view;
            title.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        }
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.tag = indexPath.row;
        }
    }
    
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGSize size = scrollView.contentSize;
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + scrollView.frame.size.height > size.height + 50 && hasMore) {
        [self loadDataWithPage:msgPage size:10];
        [LSSheetNotify showProgress:@"加载更多"];
    }
}

@end
