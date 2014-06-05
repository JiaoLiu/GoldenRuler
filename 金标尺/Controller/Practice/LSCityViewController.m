//
//  LSCityViewController.m
//  金标尺
//
//  Created by wzq on 14/6/5.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSCityViewController.h"

@interface LSCityViewController ()
{
    NSDictionary *cityInfo;
}
@end

@implementation LSCityViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

    // filterBtn
    UIButton *filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
    [filterBtn addTarget:self action:@selector(filterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [filterBtn setTitle:@"筛选"forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self getCitys];

    
    
    
}

- (void)getCitys{
    [SVProgressHUD showWithStatus:@"正在获取城市列表，请稍候..."];
    int uid = [LSUserManager getUid];
    int key = [LSUserManager getKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIGETCITY stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d",uid,key]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        if (ret == 1) {
            cityInfo = dic;
            [self buildView];
            [SVProgressHUD dismiss];
        }
        
    }];
    

}



- (void)buildView
{
    NSArray *data = [cityInfo objectForKey:@"data"];
    NSLog(@"%@",data);
    int i = 0;
    for (NSDictionary *dic in data) {
        NSString *cid = [dic objectForKey:@"id"];
        NSString *name = [dic objectForKey:@"name"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1;
        [btn.layer setCornerRadius:5];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        CGRect frame = CGRectMake(70*(i%4) + 10*(i%4) +10, 44*(i/4) + 10*(i/4) +10, 65, 40);
        btn.frame = frame;
        [self.view addSubview:btn];
        i++;
    }

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
