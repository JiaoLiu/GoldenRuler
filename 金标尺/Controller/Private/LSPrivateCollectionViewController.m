//
//  LSPrivateCollectionViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-22.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateCollectionViewController.h"

@interface LSPrivateCollectionViewController ()
{
    NSMutableArray *dataArray;
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
        [self loadData];

    }
    return self;
}

- (void)loadData
{
    for (int i = 0; i < 100; i++) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"-%d-政治（多选题）第9题",i],@"title",@"2014年4月24 10:21:34",@"time", nil];
        [dataArray insertObject:dic atIndex:i];
    }
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
}

- (void)homeBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)checkBtnClicked:(UIButton *)sender
{
    NSLog(@"check-%d",sender.tag);
}

- (void)deleteBtnClicked:(UIButton *)sender
{
    NSLog(@"delete-%d",sender.tag);
    [dataArray removeObjectAtIndex:sender.tag];
    [collectionTable reloadData];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

@end
