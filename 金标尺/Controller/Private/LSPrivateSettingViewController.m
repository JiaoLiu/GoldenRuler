//
//  LSPrivateSettingViewController.m
//  金标尺
//
//  Created by Jiao on 14-4-21.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateSettingViewController.h"

@interface LSPrivateSettingViewController ()
{
    NSArray *titleArray;
}

@end

@implementation LSPrivateSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArray = @[@"消息推送",@"意见反馈",@"关于",@"版本更新检测"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // tableView
    NSInteger height = 35;
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, titleArray.count * height)];
    table.rowHeight = height;
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    
    if (IOS_VERSION >= 7.0) {
        table.separatorInset = UIEdgeInsetsZero;
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

- (void)switchBtnClicked:(UISwitch *)sender
{
    NSLog(@"%@",sender.isOn ? @"On" : @"Off");
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        Cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(Cell.frame.size.width - 70 , 0, 50, 35)];
                if (IOS_VERSION < 7.0) {
                    CGRect frame = switchBtn.frame;
                    frame.origin.x -= 20;
                    switchBtn.frame = frame;
                }
                [switchBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventValueChanged];
                [Cell.contentView addSubview:switchBtn];
            }
                break;
            case 1:
            {
                Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 2:
            {
                Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 3:
            {
                Cell.detailTextLabel.text = [NSString stringWithFormat:@"最新版本号V%@",@"4.2.4"];
                Cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
                Cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            }
                break;
                
            default:
                break;
        }
    }
    
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

@end
