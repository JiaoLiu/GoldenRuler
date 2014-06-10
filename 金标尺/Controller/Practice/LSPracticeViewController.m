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
#import "UITextViewWithPlaceholder.h"

#define QTABLE_TAG 0
#define CTABLE_TAG 1

@interface LSPracticeViewController ()
{
    LSExam *exam;
    NSMutableArray *questionList;
    UITabBar *tabBar;
    LSQuestion *currQuestion;
    NSArray *currAnswers;
    
    NSMutableArray *currComments;
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
    currAnswers = [currQuestion.answer componentsSeparatedByString:@"|"];

    _questionView.delegate = self;
    _questionView.dataSource = self;
    _questionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _questionView.editing = YES;
    
    [self initExamView];
    [self initTabBarView];
    
    
    
    
    

    
}

- (void)initTabBarView
{
    
    //tabBar view
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

//考试界面
- (void)initExamView
{
    CGRect frame = CGRectMake(10, 0, 0, 0);
    CGSize size = [currQuestion.title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    frame.size = size;
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = currQuestion.title;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14];
    UIView *hv = [[UIView alloc]initWithFrame:frame];
    [hv addSubview:label];
    _questionView.tableHeaderView = hv;
    _questionView.frame = CGRectMake(0, 31, SCREEN_WIDTH, 35*currAnswers.count+hv.frame.size.height);
    _questionView.tag = QTABLE_TAG;
    
    CGRect oframe = _operView.frame;
    oframe.origin.y = _questionView.frame.origin.y + _questionView.frame.size.height;
    _operView.frame = oframe;
    
    CGRect yFrame = _yellowBtn.frame;
    yFrame.origin.y = oframe.origin.y + oframe.size.height+20;
    _yellowBtn.frame = yFrame;
    
    CGRect tFrame = _textView.frame;
    tFrame.origin.y = yFrame.origin.y+yFrame.size.height +20;
    _textView.frame = tFrame;
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, tFrame.origin.y + tFrame.size.height +140);

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
    titleLabel.textColor = RGB(4, 121, 202);
    [self.view addSubview:titleLabel];
    
    UITextViewWithPlaceholder *textView = [[UITextViewWithPlaceholder alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height+10, SCREEN_WIDTH-40, 100)];
    textView.placeholder = @"建议内容，可输入0/200个字符";
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.cornerRadius = 5;
    [self.view addSubview:textView];
    
    UIButton *cmtBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.origin.x, textView.frame.origin.y+textView.frame.size.height+10, SCREEN_WIDTH-40, 40)];
    
    cmtBtn.backgroundColor = RGB(3, 121, 202);
    [cmtBtn setTitle:@"提交" forState:UIControlStateNormal];
    [cmtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cmtBtn.layer.cornerRadius = 2;
    [cmtBtn addTarget:self action:@selector(commontsSmt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cmtBtn];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, cmtBtn.frame.origin.y+cmtBtn.frame.size.height+5, SCREEN_WIDTH, 30)];
    UILabel *uc = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 30)];
    uc.text = @"用户评论";
    [view addSubview:uc];
    
    UILabel *uc2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 30)];
    uc2.text = @"共12条";
    uc2.textColor = [UIColor grayColor];
    [view addSubview:uc2];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    //添加评论列表
    LSComments *cms = [[LSComments alloc]init];
    cms.username = @"jeanky wang";
    cms.dateStr = @"2014-06-10";
    cms.content = @"题目：题目内容是什么东西？恩阳古镇 ；雨中的恩阳古镇更显古朴宁静，到了恩阳古镇不可错过的当然就是“恩阳十大碗”，每一碗都是肉劲十足。";
    LSComments *cms2 = [[LSComments alloc]init];
    cms2.username = @"jeanky wang";
    cms2.dateStr = @"2014-06-10";
    cms2.content = @"题目：题目内容是什么东西？恩阳古镇 ；雨中的恩阳古镇更显古朴宁静，到了恩阳古镇不可错过的当然就是“恩阳十大碗”，每一碗都是肉劲十足。";
    LSComments *cms3 = [[LSComments alloc]init];
    cms3.username = @"jeanky wang";
    cms3.dateStr = @"2014-06-10";
    cms3.content = @"题目：题目内容是什么东西？恩阳古镇 ；雨中的恩阳古镇更显古朴宁静，到了恩阳古镇不可错过的当然就是“恩阳十大碗”，每一碗都是肉劲十足。";
    currComments = [NSMutableArray arrayWithCapacity:0];
    [currComments addObjectsFromArray:@[cms,cms2,cms3]];
    
    CGRect tFrame = CGRectMake(0,view.frame.origin.y + view.frame.size.height , SCREEN_WIDTH, SCREEN_HEIGHT-view.frame.origin.y - view.frame.size.height - 5);
    UITableView *cTableView = [[UITableView alloc]initWithFrame:tFrame style:UITableViewStylePlain];
    cTableView.delegate = self;
    cTableView.dataSource =self;
    cTableView.tag = CTABLE_TAG;
    cTableView.tableFooterView = [UIView new];
    [self.view addSubview:cTableView];
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


- (void)commontsSmt:(UIButton *)btn
{
    NSLog(@"提交评论");

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
    switch (tableView.tag) {
        case QTABLE_TAG:
        {
            NSArray *answers = [currQuestion.answer componentsSeparatedByString:@"|"];
            return answers.count;
        }
            break;
        case CTABLE_TAG:

            return currComments.count;
        default:
            return 0;
            break;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case QTABLE_TAG:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            NSArray *answers = [currQuestion.answer componentsSeparatedByString:@"|"];
            cell.textLabel.text = [answers objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            return cell;
        }
            break;
        case CTABLE_TAG:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            LSComments *cms = [currComments objectAtIndex:indexPath.row];
            cell.textLabel.text =  [NSString stringWithFormat:@"%@发表于：%@",cms.username,cms.dateStr];
            cell.textLabel.font = [UIFont systemFontOfSize:10];
            
            cell.detailTextLabel.text = cms.content;
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
   
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case QTABLE_TAG:
            return 35;
            break;
        case CTABLE_TAG:
            return 50;
            break;
        default:
            return 44;
            break;
    }

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case QTABLE_TAG:
             return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
            break;
            
        default:
            return UITableViewCellEditingStyleNone;
            break;
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

@end
