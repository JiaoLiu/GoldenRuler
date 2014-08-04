//
//  LSPrivateCollectionViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-22.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateCollectionViewController.h"
#import "LSPrivateCollectionDetailViewController.h"

@interface LSPrivateCollectionViewController ()
{
    NSMutableArray *dataArray;
    NSInteger msgPage;
    NSInteger deleteRow;
    BOOL hasMore;
    UILabel *emptyLabel;
}

@end

@implementation LSPrivateCollectionViewController

@synthesize collectionTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        dataArray = [[NSMutableArray alloc] init];
        msgPage = 1;
        deleteRow = 0;
        [self loadDataWithPage:msgPage size:0];
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    return self;
}

- (void)loadDataWithPage:(int)page size:(int)pageSize
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/myCollect?key=%d&uid=%d&page=%d&pagesize=%d",[LSUserManager getKey],[LSUserManager getUid],page,pageSize]]]];
    if (pageSize == 0) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/myCollect?key=%d&uid=%d&page=%d",[LSUserManager getKey],[LSUserManager getUid],page]]]];
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
                [LSSheetNotify showOnce:@"暂无更多收藏"];
            }
            for (int i = 0; i < num; i++) {
                NSDictionary *dic = [tempArray objectAtIndex:i];
                if (![dataArray containsObject:dic]) {
                    [dataArray addObject:dic];
                }
            }
            [collectionTable reloadData];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    }];

//    for (int i = 0; i < 100; i++) {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"-%d-政治（多选题）第9题",i],@"title",@"2014年4月24 10:21:34",@"time", nil];
//        [dataArray insertObject:dic atIndex:i];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
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
    collectionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT - 20)];
    collectionTable.delegate = self;
    collectionTable.dataSource = self;
    collectionTable.tableFooterView = [UIView new];
    [self.view addSubview:collectionTable];
    
    if (IOS_VERSION >= 7.0) {
        collectionTable.separatorInset = UIEdgeInsetsZero;
    }
    
    // emptyLabel
    int y = (collectionTable.frame.size.height - 20) / 2;
    emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 20)];
    emptyLabel.font = [UIFont systemFontOfSize:16];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"暂无收藏";
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
    [collectionTable addSubview:emptyLabel];

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

- (void)checkBtnClicked:(UIButton *)sender
{
    [LSSheetNotify dismiss];
    LSPrivateCollectionDetailViewController *collectionDetailVC = [[LSPrivateCollectionDetailViewController alloc] init];
    collectionDetailVC.qid = [[[dataArray objectAtIndex:sender.tag] objectForKey:@"qid"] integerValue];
    [self.navigationController pushViewController:collectionDetailVC animated:YES];
}

- (void)deleteBtnClicked:(UIButton *)sender
{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlert show];
    deleteRow = sender.tag;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            [SVProgressHUD showWithStatus:@"删除中..."];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"/Demand/checkCollect?key=%d&uid=%d&qid=%d&act=del&tpye=1",[LSUserManager getKey],[LSUserManager getUid],[[[dataArray objectAtIndex:deleteRow] objectForKey:@"qid"] integerValue]]]]];
            NSOperationQueue *queue = [NSOperationQueue currentQueue];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                NSDictionary *dic = [data mutableObjectFromJSONData];
                NSInteger ret = [[dic objectForKey:@"status"] integerValue];
                if (ret == 1) {
                    [dataArray removeObjectAtIndex:deleteRow];
                    [collectionTable reloadData];
                    [SVProgressHUD dismiss];
                    msgPage = dataArray.count % 10 + 1;
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
                }
            }];
        }
            break;
        default:
            break;
    }
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
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 120, 44)];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = 100;
        [Cell.contentView addSubview:titleLabel];
        
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(Cell.frame.size.width - 100, 11, 37.5, 22)];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [checkBtn setTitle:@"查看" forState:UIControlStateNormal];
        [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [checkBtn addTarget:self action:@selector(checkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [Cell.contentView addSubview:checkBtn];

        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(Cell.frame.size.width - 50, 11, 37.5, 22)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [Cell.contentView addSubview:deleteBtn];
    }
    
    for (UIView *view in [Cell.contentView subviews]) {
        if (view.tag == 100 && [view isKindOfClass:[UILabel class]]) {
            UILabel *title = (UILabel *)view;
            title.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
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
