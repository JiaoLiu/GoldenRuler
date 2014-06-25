//
//  LSTestViewController.m
//  金标尺
//
//  Created by wzq on 14/6/13.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSTestViewController.h"




#define QTABLE_TAG 0
#define CTABLE_TAG 1


@interface LSTestViewController ()
{
    int uid;
    int key;
    
    UITabBar *tabBar;
    NSArray *currAnswers;
    
    NSMutableArray *currComments;
    NSMutableArray *historyQst;
    int currIndex;
    
    LSContestView *eview;//考题view
    NSString *qTypeString;
    
    int selectedRow;
    NSDate *startTime;
    NSDate *smtTime;
}
@end

@implementation LSTestViewController

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
    self.title = self.examType == LSWrapTypeReal ? @"模拟考试" : @"真题考试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;

    // homeBtn
    UIButton *smtExmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
    [smtExmBtn addTarget:self action:@selector(smtExam) forControlEvents:UIControlEventTouchUpInside];
    [smtExmBtn setTitle:@"交卷" forState:UIControlStateNormal];
    smtExmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:smtExmBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    uid = [LSUserManager getUid];
    key = [LSUserManager getKey];
    NSDate *date = [NSDate date];
    startTime = [NSDate dateWithTimeIntervalSinceNow:date.timeIntervalSinceNow];
    
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
    
    historyQst = [NSMutableArray arrayWithCapacity:0];
    
    [self getQuestionsWithId:[_questionList objectAtIndex:0]];
    currIndex = 0;
    
//    [self initTabBarView];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCounter) userInfo:nil repeats:YES];
    [timer fire];
    [self timeCounter];
}

- (void)initTabBarView
{
    
    //tabBar view
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
    [self clearAllView];

    eview = [[LSContestView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) withQuestion:_currQuestion];
    [eview.selectBtn setTitle:[NSString stringWithFormat:@"%d/%d",currIndex+1,_questionList.count] forState:UIControlStateNormal];
    [eview.smtBtn setTitle:[NSString stringWithFormat:@"%d/%d",currIndex+1,_questionList.count] forState:UIControlStateNormal];
        
    if (_currQuestion.myAser != nil && ![_currQuestion.myAser isEqualToString:@""]) {
        eview.myAnswer.text = [NSString stringWithFormat:@"你的答案:%@",_currQuestion.myAser];
        if (_currQuestion.rightOrWrong) {
            [eview.rightImage setHidden:NO];
            [eview.wrongImage setHidden:YES];
        } else {
            [eview.rightImage setHidden:YES];
            [eview.wrongImage setHidden:NO];
        }
    }
    
    switch (_currQuestion.tid.intValue) {
        case 1:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"单选"];
            qTypeString =@"单选";
            break;
        case 2:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"多选"];
            qTypeString =@"多选";
            break;
        case 3:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"判断"];
            qTypeString =@"判断";
            break;
        case 4:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"填空"];
            qTypeString =@"填空";
            break;
        case 5:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"简答"];
            qTypeString =@"简答";
            break;
        case 6:
            eview.testType.text = [NSString stringWithFormat:@"[%@]",@"论述"];
            qTypeString =@"论述";
            break;
        default:
            break;
    }
    eview.questionView.delegate = self;
    eview.questionView.dataSource = self;
    eview.delegate = self;
    eview.questionView.tag = QTABLE_TAG;
    [self.view addSubview:eview];
//    [self.view bringSubviewToFront:tabBar];
    
}

- (void)timeCounter
{
    NSDate *now = [NSDate date];
    NSTimeInterval t = now.timeIntervalSince1970 - startTime.timeIntervalSince1970;

    int min = (int)t / 60;
    int sec = (int)t % 60;
    
    eview.usedTime.text = [NSString stringWithFormat:@"已用时 %02d:%02d",min,sec];
    
}

//评论界面
- (void)initCommentsView
{
    [self clearAllView];
    self.title = @"考友评论";
    LSCommentsView *cview = [[LSCommentsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height - 49) withComments:currComments withTitle:_currQuestion.title];
    cview.cTableView.delegate = self;
    cview.cTableView.dataSource =self;
    cview.cTableView.tag = CTABLE_TAG;
    cview.delegate = self;
    [self.view addSubview:cview];
//    [self.view bringSubviewToFront:tabBar];
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
    self.title = @"我要纠错";
    LSCorrectionView *crView = [[LSCorrectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400) withTitle:_currQuestion.title];
    crView.userInteractionEnabled = YES;
    crView.delegate = self;
    
    [self.view addSubview:crView];
//    [self.view bringSubviewToFront:tabBar];
}

//加入收藏
- (void)addToFav
{
    self.title = self.examType == LSWrapTypeReal ? @"模拟考试" : @" 练习模块";
    [self clearAllView];
    [self initExamView];
    
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



- (void)getQuestionsWithId:(NSString *)qid
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIGETQUESTION stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&qid=%@",uid,key,qid]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        if (ret == 1) {
            NSDictionary *d = [dict objectForKey:@"data"];
            _currQuestion = [LSQuestion initWithDictionary:d];
            [self initExamView];
            [SVProgressHUD dismiss];
        }
        
        
    }];
}

- (void)addFavToServer
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/checkCollect?uid=%d&key=%d&qid=%@&act=add&tpye=1",[LSUserManager getUid],[LSUserManager getKey],_currQuestion.qid]]]];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        if (ret == 1)
        {
            NSLog(@"add fav success");
        }else{
            NSLog(@"add fav fail");
        }
        
    }];
}

#pragma mark - correction Delegate
//纠错
- (void)correctionBtnClick:(NSString *)content
{
    NSLog(@"%@",content);
    [SVProgressHUD showWithStatus:@"正在提交,请稍侯..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIADDQERROR stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&qid=%@&content=%@",uid,key,_currQuestion.qid,content]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        
        if (ret == 1)
        {
            [SVProgressHUD setStatus:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        else
        {
            [SVProgressHUD setStatus:@"提交失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
            
        }
        
        
    }];
    
    
}


#pragma mark - comments delegate
//评论
- (void)commentsBtnClick:(NSString *)content
{
    NSLog(@"%@",content);
    [SVProgressHUD showWithStatus:@"正在提交,请稍侯..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIADDCOMMENT stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&qid=%@&rid=0&content=%@",uid,key,_currQuestion.qid,content]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        
        if (ret == 1)
        {
            [SVProgressHUD setStatus:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        
        
    }];

}


#pragma mark -exam delegate
- (void)prevQuestion
{
    NSLog(@"上一题");
    selectedRow = -1;
    currIndex = currIndex < 0 ? 0:currIndex;
    if (currIndex > 0) {
        
         _currQuestion = [historyQst objectAtIndex:--currIndex];
        [self initExamView];
    }
    
    NSLog(@"历史考题个数：%d",historyQst.count);
}

- (void)nextQuestion
{
    NSLog(@"下一题");
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
    selectedRow = -1;
    currIndex += 1;
    currIndex = currIndex > _questionList.count ? _questionList.count : currIndex;
    // 当前index大于题目总数 并且历史考题的数量等于题目总数
    if (currIndex >= _questionList.count && historyQst.count == _questionList.count) {
        [SVProgressHUD dismiss];
        return;
    }
    
    if (currIndex >= historyQst.count) {
        [historyQst addObject:_currQuestion];
        if (currIndex < _questionList.count) {
            NSString *qid = [_questionList objectAtIndex:currIndex];
            [self getQuestionsWithId:qid];
        }else{
        [SVProgressHUD dismiss];
        }
    }
    
    if (currIndex < historyQst.count) {
        _currQuestion = [historyQst objectAtIndex:currIndex];
        [self initExamView];
    }
    
    
    NSLog(@"历史考题个数：%d",historyQst.count);
    
}

- (void)smtExam
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定交卷吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    NSLog(@"交卷");
}

#pragma mark -alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"取消交卷");
        }
            break;
        case 1:
        {
            [self computeScore];
            NSLog(@"确定交卷");
        }
            break;
        default:
            break;
    }
}

//确定交卷
- (void)computeScore
{
    int total = 0;
    for (LSQuestion *q in historyQst) {
        total += q.rightOrWrong * 1;
    }
    
    [SVProgressHUD showWithStatus:@"正在交卷,请稍侯..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/subExam?uid=%d&key=%d&mid=%@&addtime=0&tk=%d&score=100&etime=100&questions=%@",uid,key,_exam.mid,2,[historyQst JSONString]]]]];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
    }];
    

    NSLog(@"总得分：%d",total);
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
            NSArray *answers = [_currQuestion.answer componentsSeparatedByString:@"|"];
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
            NSArray *answers = [_currQuestion.answer componentsSeparatedByString:@"|"];
            cell.textLabel.text = [answers objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            if ([_currQuestion.myAser isEqualToString:[[answers objectAtIndex:indexPath.row] substringToIndex:1]]) {
                [cell setSelected:YES];
            }
            
            
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == selectedRow) {
        selectedRow = -1;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([qTypeString isEqualToString:@"单选"] || [qTypeString isEqualToString:@"判断"])
    {
        
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:NO];
        selectedRow = indexPath.row;
        
        NSString *myAsr =[cell.textLabel.text substringToIndex:1];
        eview.myAnswer.text = [NSString stringWithFormat:@"你的答案:%@",myAsr];
        _currQuestion.myAser = myAsr;
        if ([cell.textLabel.text hasPrefix:_currQuestion.right]) {
            _currQuestion.rightOrWrong = YES;
            [eview.rightImage setHidden:NO];
            [eview.wrongImage setHidden:YES];
        }else {
            _currQuestion.rightOrWrong = NO;
            [eview.wrongImage setHidden:NO];
            [eview.rightImage setHidden:YES];
        }
        
        [self addFavToServer];
    } else {//多选
        
    }
    
}



#pragma mark -| nav btn click
- (void)homeBtnClicked
{
    [self smtExam];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
    [LSSheetNotify dismiss];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
