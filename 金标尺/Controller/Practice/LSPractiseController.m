//
//  LSPractiseController.m
//  金标尺
//
//  Created by wzq on 14/6/19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPractiseController.h"
#import "LSExam.h"
#import "LSQuestion.h"
#import "UITextViewWithPlaceholder.h"


#define QTABLE_TAG 0
#define CTABLE_TAG 1

@interface LSPractiseController ()
{
    LSExam *exam;
    NSMutableArray *questionList;
    UITabBar *tabBar;
    LSQuestion *currQuestion;
    NSArray *currAnswers;
    NSMutableArray *currComments;
    NSMutableArray *historyQst;
    
    LSExamView *eview;
    LSCommentsView *cview;
    int currIndex;
    int selectedRow;
    
    BOOL isExamView;//当前界面是否是考试题目详情界面默认yes
    
}
@end

@implementation LSPractiseController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedRow = -1;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"练习板块";
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
    
    historyQst = [NSMutableArray arrayWithCapacity:0];
    questionList = [NSMutableArray arrayWithCapacity:0];
    
    if (_isContinue) {
        
        [self getContinuePaper];
        
    } else
    {
        [self getPaper];
        [self saveExamInfo];
    }
    
//    [self getQuestionsWithId:@"10"];
    
    
//    [self initExamView];
    [self initTabBarView];
}

- (void)saveExamInfo
{
    [LSUserManager setCid:_cid.intValue];
    [LSUserManager setTid:_tid.intValue];
    [LSUserManager setTk:_testType == LSWrapTypeSimulation?1:2];
    
}

- (void)initTabBarView
{
    
    tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49-64, SCREEN_WIDTH, 49)];
    tabBar.delegate = self;
    
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:@"加入收藏" image:[UIImage imageNamed:@"f_1.png"] tag:0];
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"考友评论" image:[UIImage imageNamed:@"f_2.png"] tag:1];
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:@"我要纠错" image:[UIImage imageNamed:@"f_3.png"] tag:2];

    
    
    tabBar.items= @[item1,item2,item3];
    tabBar.backgroundImage = [UIImage imageNamed:@"f_bg.png"];
    tabBar.selectedImageTintColor = [UIColor whiteColor];
    
    [self.view addSubview:tabBar];
}

//考试界面
- (void)initExamView
{
    isExamView = YES;
    [self clearAllView];
    
    switch (currQuestion.tid.intValue) {
        case 1:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"单选"];
            _qTypeString =@"单选";
            break;
        case 2:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"多选"];
            _qTypeString =@"多选";
            break;
        case 3:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"判断"];
            _qTypeString =@"判断";
            break;
        case 4:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"填空"];
            _qTypeString =@"填空";
            break;
        case 5:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"简答"];
            _qTypeString =@"简答";
            break;
        case 6:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"论述"];
            _qTypeString =@"论述";
            break;
        default:
            break;
    }
    
    
    eview = [[LSExamView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) withQuestion:currQuestion];
    eview.testType.text =[NSString stringWithFormat:@"[%@]",_qTypeString];
    [eview.selectBtn setTitle:[NSString stringWithFormat:@"%d/%d",currIndex+1,questionList.count] forState:UIControlStateNormal];
    
    if([_qTypeString isEqualToString:@"单选"] || [_qTypeString isEqualToString:@"判断"]){
        [eview.currBtn setTitle:[NSString stringWithFormat:@"%d/%d",currIndex+1,questionList.count] forState:UIControlStateNormal];
    }
    
    if (currQuestion.myAser != nil && ![currQuestion.myAser isEqualToString:@""]) {
        [eview.operTop setHidden:NO];
        eview.myAnswer.text = [NSString stringWithFormat:@"你的答案:%@",currQuestion.myAser];
        if (currQuestion.rightOrWrong) {
           
            [eview.rightImage setHidden:NO];
            [eview.wrongImage setHidden:YES];
        } else {
            
            [eview.rightImage setHidden:YES];
            [eview.wrongImage setHidden:NO];
        }
        [eview.textLabel setHidden:NO];
        
    }
    
    eview.questionView.delegate = self;
    eview.questionView.dataSource = self;
    eview.questionView.tag = QTABLE_TAG;
    eview.delegate = self;
    
    [self.view addSubview:eview];
    [self.view bringSubviewToFront:tabBar];
     [SVProgressHUD dismiss];
    
}

//评论界面
- (void)initCommentsView
{
    isExamView = NO;
    [self clearAllView];
    self.title = @"考友评论";
//    [self getComments];
    cview = [[LSCommentsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height - 49) withComments:currComments withTitle:currQuestion.title];
    cview.cTableView.delegate = self;
    cview.cTableView.dataSource =self;
    cview.cTableView.tag = CTABLE_TAG;
    
    
    cview.delegate = self;
    [self.view addSubview:cview];
    [self.view bringSubviewToFront:tabBar];
}

//查看答案界面
- (void)initAnswerView
{
    [self clearAllView];
    
}

//纠错界面
- (void)initCorrectionView
{
    isExamView = NO;
    [self clearAllView];
    self.title = @"我要纠错";
    LSCorrectionView *crView = [[LSCorrectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400) withTitle:currQuestion.title];
    crView.userInteractionEnabled = YES;
    crView.delegate = self;
    
    [self.view addSubview:crView];
    [self.view bringSubviewToFront:tabBar];

}

//加入收藏
- (void)addToFav
{
    if (isExamView) {//触发加入收藏功能
        [self addFavToServer];
    }
    
    [self clearAllView];
    [self initExamView];

    
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


- (void)getComments
{
    [SVProgressHUD showWithStatus:@"正在加载评论"];
    currComments = [NSMutableArray arrayWithCapacity:0];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/myComment?uid=%d&key=%d&page=%d&pagesize=%d&type=%d&qid=%@",[LSUserManager getUid],[LSUserManager getKey],1,50,2,currQuestion.qid]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
     [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         NSDictionary *dic = [data mutableObjectFromJSONData];
         NSInteger ret = [[dic objectForKey:@"status"] integerValue];
         NSString *msg = [dic objectForKey:@"msg"];
         if (ret == 1) {
             NSDictionary *dt = [dic objectForKey:@"data"];
             int count = [[dt objectForKey:@"count"] intValue];
             NSArray *list = [dt objectForKey:@"list"];
             for (NSDictionary *cmt in list) {
                 LSComments *comments = [[LSComments alloc]init];
                 comments.username = [cmt objectForKey:@"name"];
                 comments.dateStr = [cmt objectForKey:@"addtime"];
                 comments.content = [cmt objectForKey:@"content"];
                 [currComments addObject:comments];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
//                 [cview.cTableView reloadData];
                 [self initCommentsView];
             });

             
         } else
         {
             [SVProgressHUD dismiss];
             [SVProgressHUD showWithStatus:msg];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
             });

         }
         
     }];
}


- (void)getPaper{
    
    exam = [[LSExam alloc]init];
   
    [SVProgressHUD showWithStatus:@"正在获取考题，请稍候..."];
    int uid = [LSUserManager getUid];
    int key = [LSUserManager getKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/testQuestionList?uid=%d&key=%d&tk=%@&cid=%@&tid=%@",uid,key,_testType==LSWrapTypeSimulation ? @"1":@"2",_cid,_tid]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        NSString *msg = [dic objectForKey:@"msg"];
        if (ret == 1) {
            NSDictionary *dt = [dic objectForKey:@"data"];
            NSArray *questions = [dt objectForKey:@"list"];
            
            for (NSDictionary *qd in questions) {
                LSQuestion *q = [LSQuestion initWithDictionary:qd];
                [questionList addObject:q];
            }
            
            
         dispatch_async(dispatch_get_main_queue(), ^{
             currQuestion = [questionList objectAtIndex:0];
             currIndex = 0;
             [self initExamView];
             
            });
            
            
        } else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showWithStatus:msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
        }
        
        
        
    }];
    
    
}

- (void)getContinuePaper
{
    exam = [[LSExam alloc]init];
    
    [SVProgressHUD showWithStatus:@"正在获取考题，请稍候..."];
    int uid = [LSUserManager getUid];
    int key = [LSUserManager getKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/testQuestionList?uid=%d&key=%d&tk=%d&cid=%d&tid=%d",uid,key,[LSUserManager getTk],[LSUserManager getCid],[LSUserManager getTid]]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *dic = [data mutableObjectFromJSONData];
        NSInteger ret = [[dic objectForKey:@"status"] integerValue];
        NSString *msg = [dic objectForKey:@"msg"];
        if (ret == 1) {
            NSDictionary *dt = [dic objectForKey:@"data"];
            NSArray *questions = [dt objectForKey:@"list"];
            if ([[dt objectForKey:@"count"] intValue]<1) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"暂无历史纪录，请先做题"];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            for (NSDictionary *qd in questions) {
                LSQuestion *q = [LSQuestion initWithDictionary:qd];
                [questionList addObject:q];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                int lastQid = [LSUserManager getLastqid];
                for (int i = 0; i<questionList.count; i++) {
                    LSQuestion *q = [questionList objectAtIndex:i];
                    if (q.qid.intValue == lastQid) {
                        currQuestion = q;
                        currIndex = i;
                    }
                    else
                    {
                        [historyQst addObject:q];
                    }
                }
                
                
                [self initExamView];
                
            });
            
            
        } else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showWithStatus:msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
        }
        
        
        
    }];
    



}


//- (void)getQuestionsWithId:(NSString *)qid
//{
//    int uid = [LSUserManager getUid];
//    int key = [LSUserManager getKey];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIGETQUESTION stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&qid=%@",uid,key,qid]]]];
//    
//    NSOperationQueue *queue = [NSOperationQueue currentQueue];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *dict = [data mutableObjectFromJSONData];
//        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
//        if (ret == 1) {
//            NSDictionary *d = [dict objectForKey:@"data"];
//            LSQuestion *q = [LSQuestion initWithDictionary:d];
//            currQuestion = q;
//            [self initExamView];
//            [SVProgressHUD dismiss];
//        }
//        
//        
//    }];
//}

- (void)addFavToServer
{
    [SVProgressHUD showWithStatus:@"加入收藏"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/checkCollect?uid=%d&key=%d&qid=%@&act=add&tpye=1",[LSUserManager getUid],[LSUserManager getKey],currQuestion.qid]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
       [SVProgressHUD dismiss];
        if (ret == 1)
        {
            NSLog(@"add fav success");
            
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }else{
            NSLog(@"add fav fail:%@",[dict objectForKey:@"msg"]);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",[dict objectForKey:@"msg"]]];
        }
    
    }];
}

- (void)addPractice
{

    int uid = [LSUserManager getUid];
    int key = [LSUserManager getKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/addPractice?uid=%d&key=%d&qid=%@&answer=%@&right=%d&tk=%d",uid,key,currQuestion.qid,currQuestion.myAser,currQuestion.rightOrWrong,_testType==LSWrapTypeSimulation ? 1:2]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        if (ret == 1)
        {
            NSLog(@"add practice success");
        }else{
            NSLog(@"add practice fail");
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
            [self getComments];
            
        }
            NSLog(@"click item2");
            break;
        case 2:
            [self initCorrectionView];
            NSLog(@"click item3");
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
            cview.numLabel.text = [NSString stringWithFormat:@"共%d条评论",currComments.count];
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
            NSString *asContent = [answers objectAtIndex:indexPath.row];
            cell.textLabel.text = asContent;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize rect = [asContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.x, rect.width, rect.height);
            
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
//            if ([currQuestion.myAser isEqualToString:[[answers objectAtIndex:indexPath.row] substringToIndex:1]]) {
//                [cell setSelected:YES];
//            }
            
            if (currQuestion.myAser != nil && [currQuestion.myAser rangeOfString:[[answers objectAtIndex:indexPath.row] substringToIndex:1]].location != NSNotFound) {
                NSLog(@"%@",currQuestion.myAser);
                [cell setSelected:YES];
                tableView.userInteractionEnabled = NO;
            }
            
            return cell;
        }
            break;
        case CTABLE_TAG:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
            LSComments *cms = [currComments objectAtIndex:indexPath.row];
            cell.textLabel.text =  [NSString stringWithFormat:@"%@发表于：%@",cms.username,cms.dateStr];
            cell.textLabel.font = [UIFont systemFontOfSize:10];
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            cell.detailTextLabel.text = cms.content;
             CGSize rect = [cms.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            cell.detailTextLabel.frame = CGRectMake(cell.detailTextLabel.frame.origin.x, cell.detailTextLabel.frame.origin.x, rect.width, rect.height);
            
            
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
        {
            
            NSArray *answers = [currQuestion.answer componentsSeparatedByString:@"|"];
            NSString *asContent = [answers objectAtIndex:indexPath.row];
            CGSize rect = [asContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            
            return rect.height+20;
        }
            
            break;
        case CTABLE_TAG:
        {
            LSComments *cms = [currComments objectAtIndex:indexPath.row];
            CGSize rect = [cms.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            return 30+rect.height;
        }

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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == selectedRow) {
        selectedRow = -1;
    }
//    [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    //单选和判断 点击一次就提交服务器
    if ([_qTypeString isEqualToString:@"单选"] || [_qTypeString isEqualToString:@"判断"])
    {
        
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:NO];
        selectedRow = indexPath.row;
        
        [eview.operTop setHidden:NO];
        [eview.textLabel setHidden:NO];
        eview.myAnswer.text = [NSString stringWithFormat:@"你的答案:%@",[cell.textLabel.text substringToIndex:1]];
        
        if ([cell.textLabel.text hasPrefix:currQuestion.right]) {//答案正确
            currQuestion.myAser = currQuestion.right;
            [eview.rightImage setHidden:NO];
            [eview.wrongImage setHidden:YES];
            currQuestion.rightOrWrong = YES;
        }else {//答案错误
            currQuestion.myAser = [cell.textLabel.text substringToIndex:1];
            [eview.wrongImage setHidden:NO];
            [eview.rightImage setHidden:YES];
            currQuestion.rightOrWrong = NO;
        }
//        tableView.allowsMultipleSelectionDuringEditing = NO;
        [self addPractice];
        
    } else {//多选
        
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -exam delegate
- (void)prevQuestion
{
    selectedRow = -1;
    NSLog(@"上一题");
    
    currIndex = currIndex < 0 ? 0:currIndex;
    if (currIndex > 0) {
        
        currQuestion = [historyQst objectAtIndex:--currIndex];
        [self initExamView];
    }
    
    NSLog(@"历史考题个数：%d",historyQst.count);
}

- (void)nextQuestion
{
    selectedRow = -1;
    NSLog(@"下一题");

    currIndex += 1;
    currIndex = currIndex > questionList.count ? questionList.count : currIndex;
    
    // 当前index大于题目总数 并且历史考题的数量等于题目总数
    if (currIndex >= questionList.count && historyQst.count == questionList.count) {
        [SVProgressHUD dismiss];
        return;
    }
    
    if (currIndex >= historyQst.count) {
        [historyQst addObject:currQuestion];
        if (currIndex < questionList.count) {
            currQuestion = [questionList objectAtIndex:currIndex];
            [self initExamView];
//            return;
        }else{
            [SVProgressHUD dismiss];
        }
    }else if (currIndex < historyQst.count) {
        currQuestion = [historyQst objectAtIndex:currIndex];
        [self initExamView];
    }
    
    
    NSLog(@"历史考题个数：%d",historyQst.count);
    
}

- (void)smtAnswer
{
    NSString *myAnswer = @"";
    if ([_qTypeString isEqualToString:@"多选"]) {
        NSArray *array = [eview.questionView indexPathsForSelectedRows];
        array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
           NSIndexPath *o1 = (NSIndexPath *)obj1;
           NSIndexPath *o2 = (NSIndexPath *)obj2;
           
           return o1.row > o2.row ? NSOrderedDescending:NSOrderedAscending;
           
       }];
        
        NSArray *answers = [currQuestion.answer componentsSeparatedByString:@"|"];
        for (NSIndexPath *path in array) {
            NSString *s = [answers objectAtIndex:path.row];
            myAnswer = [myAnswer stringByAppendingString:[s substringToIndex:1]];
        }
        NSLog(@"我的答案：%@",myAnswer);
        [eview.operTop setHidden:NO];
        eview.myAnswer.text = myAnswer;
        currQuestion.myAser = myAnswer;
        if ([myAnswer isEqualToString:currQuestion.right]) {
            currQuestion.rightOrWrong = YES;
            [eview.rightImage setHidden:NO];
            [eview.wrongImage setHidden:YES];
        } else
        {
            currQuestion.rightOrWrong = NO;
            [eview.rightImage setHidden:YES];
            [eview.wrongImage setHidden:NO];
        }
        [eview.textLabel setHidden:NO];
        [self addPractice];
    }
    
    
    
}

#pragma mark -correction btn click

- (void)correctionBtnClick:(NSString *)content
{
    [SVProgressHUD showWithStatus:@"正在提交,请稍侯..."];
    NSString *url = [APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/addqerror?uid=%d&key=%d&qid=%@&rid=0&content=%@",[LSUserManager getUid],[LSUserManager getKey],currQuestion.qid,content]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        
        if (ret == 1)
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            
        } else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
           
        }
        
        
        
    }];


}

#pragma mark - comments delegate
//评论
- (void)commentsBtnClick:(NSString *)content
{
    NSLog(@"%@",content);
    [SVProgressHUD
     showWithStatus:@"正在提交,请稍侯..."];
    NSString *url =[APIADDCOMMENT stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&qid=%@&rid=0&content=%@",[LSUserManager getUid],[LSUserManager getKey],currQuestion.qid,content]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        [SVProgressHUD dismiss];
        if (ret == 1)
        {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            
        } else
        {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",[dict objectForKey:@"msg"]]];
        }
        
        
    }];
    
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [LSUserManager setLastqid:currQuestion.qid.intValue];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD dismiss];
        [LSSheetNotify dismiss];
    }
}

#pragma mark -| nav btn click
- (void)homeBtnClicked
{
    [SVProgressHUD dismiss];
    if (historyQst.count < questionList.count) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"题目暂未做完，退出将保存！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD dismiss];
        [LSSheetNotify dismiss];
    }

    
}

- (void)backBtnClicked
{
    [SVProgressHUD dismiss];
    if (historyQst.count < questionList.count) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"题目暂未做完，退出将保存！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];

    }else {
    
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD dismiss];
        [LSSheetNotify dismiss];
    }

}
@end
