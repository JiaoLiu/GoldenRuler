//
//  LSPrivateCommentDetailViewController.m
//  金标尺
//
//  Created by Jiao on 14-6-25.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateCommentDetailViewController.h"

@interface LSPrivateCommentDetailViewController ()
{
    NSMutableArray *commentArray;
    LSCommentsView *cView;
}

@end

@implementation LSPrivateCommentDetailViewController

@synthesize qid;
@synthesize myComment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        commentArray = [[NSMutableArray alloc] init];
        myComment = [[LSComments alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadComments];
    
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadComments
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/myComment?uid=%d&key=%d&page=0&pagesize=0&type=2&qid=%d",[LSUserManager getUid],[LSUserManager getKey],qid]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        NSString *msg = [dic objectForKey:@"msg"];
        if (ret == 1) {
            NSDictionary *dt = [dic objectForKey:@"data"];
            [commentArray addObject:myComment];
            [self initCommentViewWithTitle:[dt objectForKey:@"title"]];
            [SVProgressHUD dismiss];
        }
        else {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    }];
}

- (void)initCommentViewWithTitle:(NSString *)title
{
    cView = [[LSCommentsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) withComments:commentArray withTitle:title];
    cView.cTableView.delegate = self;
    cView.cTableView.dataSource =self;
    if (IOS_VERSION > 7.0) {
        cView.cTableView.separatorInset = UIEdgeInsetsZero;
    }
    cView.delegate = self;
    [self.view addSubview:cView];
}

- (void)tapDismissKeyboard
{
    [cView endEditing:YES];
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

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    cView.numLabel.text = [NSString stringWithFormat:@"共%d条评论",commentArray.count];
    return commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LSComments *comment = [commentArray objectAtIndex:indexPath.row];
    cell.textLabel.text =  [NSString stringWithFormat:@"%@发表于：%@",comment.username,comment.dateStr];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.detailTextLabel.text = comment.content;
    CGSize rect = [comment.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    cell.detailTextLabel.frame = CGRectMake(cell.detailTextLabel.frame.origin.x, cell.detailTextLabel.frame.origin.x, rect.width, rect.height);
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSComments *comment = [commentArray objectAtIndex:indexPath.row];
    CGSize rect = [comment.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return 30 + rect.height;
}

#pragma mark - LSCommentDelegaet
- (void)commentsBtnClick:(NSString *)content
{
    [SVProgressHUD showWithStatus:@"正在提交,请稍侯..."];
    NSString *url =[APIADDCOMMENT stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&qid=%d&rid=0&content=%@",[LSUserManager getUid],[LSUserManager getKey],qid,content]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        if (ret == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            LSComments *newCom = [[LSComments alloc] init];
            newCom.content = content;
            newCom.username = myComment.username;
            newCom.dateStr = [NSString stringFromDate:[NSDate date] Formatter:@"yyyy-MM-dd:HH:mm:ss"];
            [commentArray insertObject:newCom atIndex:0];
            [cView.cTableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
        }
    }];
}

@end
