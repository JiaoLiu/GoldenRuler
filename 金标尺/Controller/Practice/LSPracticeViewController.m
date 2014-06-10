//
//  LSPracticeViewController.m
//  金标尺
//
//  Created by wzq on 14/6/4.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPracticeViewController.h"
#import "LSExam.h"
#import "LSQuestion.h"

@interface LSPracticeViewController ()
{
    LSExam *exam;
    NSMutableArray *questionList;
    UITabBar *tabBar;
    LSQuestion *currQuestion;
}
@end

@implementation LSPracticeViewController

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
    [self getPaper];
    
    [self getQuestionsWithId:@"10"];
    
    currQuestion = [[LSQuestion alloc]init];
    currQuestion.title = @"kaojjijiofjisafjisjfi;jfi;sjfi;sjf;sjfs;jfs;jf;sdfjios;fjiosd;jfiosfjidsjfjfisjfijiojf;oajif;jf;";
    currQuestion.answer = @"A:nihoa|B:jfjff|C:fasfasf|D:fasfsdf|E:fasfsdf|F:fasfsdf";
    currQuestion.right = @"A";

    _questionView.delegate = self;
    _questionView.dataSource = self;
    _questionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _questionView.editing = YES;
//    _questionView.allowsSelectionDuringEditing = YES;
//    _questionView.allowsMultipleSelectionDuringEditing = YES;
    _questionView.scrollEnabled = YES;
//    _questionView.tableFooterView = [UIView new];
    _questionView.frame = [_questionView superview].frame;
    
    CGRect frame = CGRectMake(20, 0, 0, 0);
    CGSize size = [currQuestion.title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    frame.size = size;
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = currQuestion.title;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14];
    _questionView.tableHeaderView = label;

    
    
    
    
    tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49-64, SCREEN_WIDTH, 49)];
    tabBar.delegate = self;
    tabBar.backgroundColor = [UIColor grayColor];
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:2];
    UITabBarItem *item4 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:3];

    
    tabBar.items= @[item1,item2,item3,item4];
    [self.view addSubview:tabBar];
    
    
    

    
}

//评论界面
- (void)initCommentsView
{
    [self clearAllView];
    NSString *title = @"题目：题目内容是什么东西？恩阳古镇 ；雨中的恩阳古镇更显古朴宁静，到了恩阳古镇不可错过的当然就是“恩阳十大碗”，每一碗都是肉劲十足。";
    CGRect frame = CGRectMake(20, 0, 0, 0);
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    frame.size = size;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:frame];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blueColor];
    [self.view addSubview:titleLabel];
    


}

//查看答案界面
- (void)initAnswerView
{
    [self clearAllView];
    
}

//纠错界面
- (void)initCorrectionView
{
    [self clearAllView];
    
}

//加入收藏
- (void)addToFav
{


}

//清除view中的元素

- (void)clearAllView
{
    NSArray *array = self.view.subviews;
    for (UIView *view in array) {
        
        //排除tabBar类型
        if (![view isKindOfClass:[UITabBar class]]) {
            [view removeFromSuperview];
        }
        
    }

}



- (void)getPaper{

        exam = [[LSExam alloc]init];
        questionList = [NSMutableArray arrayWithCapacity:0];
    
        [SVProgressHUD showWithStatus:@"正在获取考题，请稍候..."];
        int uid = [LSUserManager getUid];
        int key = [LSUserManager getKey];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIGETEXAM stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&tk=1&cid=1",uid,key]]]];
        
        NSOperationQueue *queue = [NSOperationQueue currentQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSDictionary *dic = [data mutableObjectFromJSONData];
            NSInteger ret = [[dic objectForKey:@"status"] integerValue];
            if (ret == 1) {
                NSDictionary *dt = [dic objectForKey:@"data"];
                NSArray *list = [dt objectForKey:@"list"];
                NSString *totalScore = [dt objectForKey:@"score"];
                NSString *time = [dt objectForKey:@"time"];
                NSString *num  = [dt objectForKey:@"num"];
                NSString *mid = [dt objectForKey:@"mid"];
                
                exam.score = [totalScore intValue];
                exam.num = [num intValue];
                exam.mid = mid;
                exam.time = [time intValue];
                
                for (NSDictionary *qs in list) {

                    NSString *tid = [qs objectForKey:@"tid"];
                    NSString *score = [qs objectForKey:@"score"];
                    NSString *qids = [qs objectForKey:@"qid"];
                    if ( [qids respondsToSelector:@selector(rangeOfString:)]) {
                    
                    if ([qids rangeOfString:@","].location != NSNotFound) {
                        NSArray *qidList = [[qs objectForKey:@"qid"] componentsSeparatedByString:@","];
                        [questionList addObjectsFromArray:qidList];
                    } else {
                        [questionList addObject:qids];
                    }
                        
                    }
                    
                }
                
                
                
                [SVProgressHUD dismiss];
            }
            
        }];
        
    
}

- (void)getQuestionsWithId:(NSString *)qid
{
    int uid = [LSUserManager getUid];
    int key = [LSUserManager getKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIGETQUESTION stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&qid=%@",uid,key,qid]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSDictionary *d = [dict objectForKey:@"data"];
            LSQuestion *q = [LSQuestion initWithDictionary:d];
        }
        
    
    }];
}




#pragma mark - tabbar delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
            [self addToFav];
            NSLog(@"click item1");
            break;
        case 1:
        {
            
            //现实评论view
            [self initCommentsView];
            
        }
             NSLog(@"click item2");
            break;
        case 2:
            [self initCorrectionView];
             NSLog(@"click item3");
            break;
        case 3:
            [self initAnswerView];
             NSLog(@"click item4");
            break;
            
        default:
            break;
    }




}


#pragma mark -tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *answers = [currQuestion.answer componentsSeparatedByString:@"|"];
    return answers.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    }
    NSArray *answers = [currQuestion.answer componentsSeparatedByString:@"|"];
    cell.textLabel.text = [answers objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
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
