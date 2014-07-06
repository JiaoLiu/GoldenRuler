//
//  LSCityViewController.m
//  金标尺
//
//  Created by wzq on 14/6/5.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSCityViewController.h"
#import "LSWrapInfoViewController.h"

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
    
    self.title = @"套卷测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;

//    // filterBtn
//    UIButton *filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
//    [filterBtn addTarget:self action:@selector(filterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [filterBtn setTitle:@"筛选"forState:UIControlStateNormal];
//    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;

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
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
             
                [self buildView];
                
            });
            
        }
        
        if (ret == 0) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });

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
        [btn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = cid.intValue;
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

- (void)cityBtnClick:(UIButton *)sender
{
    UIButton *btn = sender;
    NSString *city = btn.titleLabel.text;
    
    LSWrapInfoViewController *vc = [[LSWrapInfoViewController alloc]init];
    vc.city = city;
    vc.cid = self.cid;
    vc.wrapType = LSWrapTypeReal;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
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
