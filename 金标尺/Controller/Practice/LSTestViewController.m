//
//  LSTestViewController.m
//  金标尺
//
//  Created by wzq on 14/6/13.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSTestViewController.h"
#import "LSTestResultViewController.h"
#import "SBJSON.h"



#define QTABLE_TAG 0
#define CTABLE_TAG 1

#define ALERT_BACK_TAG 10
#define ALERT_SMT_TAG 11

//@interface QuestionSimple : NSObject<NSCoding>
//@property (nonatomic) int qid;
//@property (nonatomic,strong) NSString *myanswer;
//@property (nonatomic) BOOL right;
//@end
//
//@implementation QuestionSimple
//@end

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
    
    NSTimer *timer;
    NSMutableArray *smtQst;
    
    BOOL isSmt;
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
    
   
    
    historyQst = [NSMutableArray arrayWithCapacity:0];
    if (_questionList != nil && _questionList.count>0) {
        _currQuestion = [_questionList objectAtIndex:0];
        currIndex = 0;
        [self initExamView];
    }
    
    

    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCounter) userInfo:nil repeats:YES];
    selectedRow = -1;
    [self timeCounter];
}


//考试界面
- (void)initExamView
{
    isSmt = NO;
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

////评论界面
//- (void)initCommentsView
//{
//    [self clearAllView];
//    self.title = @"考友评论";
//    LSCommentsView *cview = [[LSCommentsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height - 49) withComments:currComments withTitle:_currQuestion.title];
//    cview.cTableView.delegate = self;
//    cview.cTableView.dataSource =self;
//    cview.cTableView.tag = CTABLE_TAG;
//    cview.delegate = self;
//    [self.view addSubview:cview];
////    [self.view bringSubviewToFront:tabBar];
//}


////查看答案界面
//- (void)initAnswerView
//{
//    [self clearAllView];
//    
//}

////纠错界面
//- (void)initCorrectionView
//{
//    [self clearAllView];
//    self.title = @"我要纠错";
//    LSCorrectionView *crView = [[LSCorrectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400) withTitle:_currQuestion.title];
//    crView.userInteractionEnabled = YES;
//    crView.delegate = self;
//    
//    [self.view addSubview:crView];
////    [self.view bringSubviewToFront:tabBar];
//}

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

//#pragma mark - correction Delegate
////纠错
//- (void)correctionBtnClick:(NSString *)content
//{
//    NSLog(@"%@",content);
//    [SVProgressHUD showWithStatus:@"正在提交,请稍侯..."];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIADDQERROR stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&qid=%@&content=%@",uid,key,_currQuestion.qid,content]]]];
//    
//    NSOperationQueue *queue = [NSOperationQueue currentQueue];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *dict = [data mutableObjectFromJSONData];
//        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
//        
//        if (ret == 1)
//        {
//            [SVProgressHUD setStatus:@"提交成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
//        }
//        else
//        {
//            [SVProgressHUD setStatus:@"提交失败"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
//            
//            
//        }
//        
//        
//    }];
//    
//    
//}


//#pragma mark - comments delegate
////评论
//- (void)commentsBtnClick:(NSString *)content
//{
//    NSLog(@"%@",content);
//    [SVProgressHUD showWithStatus:@"正在提交,请稍侯..."];
//    
//    NSString *url =[APIADDCOMMENT stringByAppendingString:[NSString stringWithFormat:@"?uid=%d&key=%d&qid=%@&rid=0&content=%@",uid,key,_currQuestion.qid,content]];
//    
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    NSOperationQueue *queue = [NSOperationQueue currentQueue];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *dict = [data mutableObjectFromJSONData];
//        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
//        
//        if (ret == 1)
//        {
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
//           
//        }
//        else
//        {
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
//        }
//        
//        
//    }];
//
//}


#pragma mark -exam delegate
- (void)prevQuestion
{
    NSLog(@"上一题");
    selectedRow = -1;
    currIndex = currIndex < 0 ? 0:currIndex;
    if (currIndex > 0) {
        
         _currQuestion = [_questionList objectAtIndex:--currIndex];
        [self initExamView];
    }
    
    NSLog(@"历史考题个数：%d",historyQst.count);
}

- (void)nextQuestion
{
    NSLog(@"下一题");

    if (!isSmt) {
        [self smtAnswer];
    }
    
    selectedRow = -1;
    currIndex += 1;
    currIndex = currIndex > _questionList.count ? _questionList.count : currIndex;
    
    // 当前index大于题目总数 并且历史考题的数量等于题目总数
    if (currIndex >= _questionList.count && historyQst.count == _questionList.count)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"本次考试已做完" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [SVProgressHUD dismiss];
        return;
    }
    
    if (currIndex >= historyQst.count)
    {
        [historyQst addObject:_currQuestion];
        
        if (currIndex < _questionList.count)
        {
            _currQuestion = [_questionList objectAtIndex:currIndex];
            [self initExamView];
        }
        else
        {
            
            [SVProgressHUD dismiss];
            
        }
    }
    else  if (currIndex < historyQst.count)
        
    {
        _currQuestion = [_questionList objectAtIndex:currIndex];
        [self initExamView];
    }
    
    
    NSLog(@"历史考题个数：%d",historyQst.count);
    
}

- (void)smtAnswer
{
    NSString *myAnswer = @"";
    if ([qTypeString isEqualToString:@"多选"])
    {
        NSArray *array = [eview.questionView indexPathsForSelectedRows];
        array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *o1 = (NSIndexPath *)obj1;
            NSIndexPath *o2 = (NSIndexPath *)obj2;
            
            return o1.row > o2.row ? NSOrderedDescending:NSOrderedAscending;
            
        }];
        
        NSArray *answers = [_currQuestion.answer componentsSeparatedByString:@"|"];
        for (NSIndexPath *path in array) {
            NSString *s = [answers objectAtIndex:path.row];
            myAnswer = [myAnswer stringByAppendingString:[s substringToIndex:1]];
        }
        NSLog(@"我的答案：%@",myAnswer);


        _currQuestion.myAser = myAnswer;
        
        if ([myAnswer isEqualToString:_currQuestion.right])
        {
            _currQuestion.rightOrWrong = YES;

        }
        else
        {
            _currQuestion.rightOrWrong = NO;
        }


    }
    
    if ([qTypeString isEqualToString:@"填空"])
    {
        NSString *myAnswer = [eview.textFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSLog(@"我的答案：%@",myAnswer);

        eview.myAnswer.text = myAnswer;
        _currQuestion.myAser = myAnswer;
        [eview.textFiled resignFirstResponder];
        [eview.textFiled setEnabled:NO];
        
        if ([myAnswer isEqualToString:_currQuestion.right])
        {
            _currQuestion.rightOrWrong = YES;
        }
        else
        {
            _currQuestion.rightOrWrong = NO;
        }


    }
    
}

- (void)smtExam
{
    NSString *alertContent = nil;
    if ((_questionList.count - historyQst.count) == 0) {
        alertContent = [NSString stringWithFormat:@"确定交卷吗？"];
    }
    else
    {
       alertContent = [NSString stringWithFormat:@"您还有%d道题没做，确定交卷吗？",_questionList.count - historyQst.count];
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:alertContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = ALERT_SMT_TAG;
    [alert show];
    
    NSLog(@"交卷");
}



-(void)chooseQuestion
{
    LSChooseQuestionViewController *vc = [[LSChooseQuestionViewController alloc]init];
    vc.questions = _questionList;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - choosequestion delegate
- (void)seletedQuestion:(int)index
{
    _currQuestion = [_questionList objectAtIndex:index];
    currIndex = index;
    [self initExamView];
}
#pragma mark -alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
//            NSLog(@"取消交卷");
        }
            break;
        case 1:
        {
            NSLog(@"确定交卷");
            if (alertView.tag == ALERT_SMT_TAG) {
                [timer invalidate];
                [self computeScore];
            }
            else if (alertView.tag == ALERT_BACK_TAG)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
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
        total += q.rightOrWrong * q.qScore;
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *addTime = [fmt stringFromDate:startTime];
    NSDate *now = [NSDate date];
    NSTimeInterval t = now.timeIntervalSince1970 - startTime.timeIntervalSince1970;
    [self questionToQuestionSimple:historyQst ];
    

    //?uid=%d&key=%d&mid=%@&addtime=%@&tk=%d&score=%d&etime=%d&questions=%@",uid,key,_exam.mid,addTime,1,total,(int)t,[smtQst JSONString]]
    
    [SVProgressHUD showWithStatus:@"正在交卷,请稍侯..."];
    NSString *url =[APIURL stringByAppendingString:[NSString stringWithFormat:@"Demand/subExam"]];
    //    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSMutableURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[NSNumber numberWithInt:[LSUserManager getUid]] forKey:@"uid"];
    [parameters setValue:[NSNumber numberWithInt:[LSUserManager getKey]] forKey:@"key"];
    [parameters setValue:_exam.mid forKeyPath:@"mid"];
    [parameters setValue:addTime forKeyPath:@"addtime"];
    [parameters setValue:_examType == LSWrapTypeReal ? @"2":@"1" forKeyPath:@"tk"];
    [parameters setValue:[NSNumber numberWithInt:total] forKeyPath:@"score"];
    [parameters setValue:[NSNumber numberWithInt:t] forKeyPath:@"etime"];
    [parameters setValue:[[SBJsonWriter new] stringWithObject:smtQst] forKeyPath:@"question"];
    
    // add params (all params are strings)
    for (NSString *param in parameters) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [data mutableObjectFromJSONData];
        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
        if (ret == 1)
        {
            int examId = [[dict objectForKey:@"data"] intValue];
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"交卷成功"];

            LSTestResultViewController *vc = [[LSTestResultViewController alloc]init];
            vc.usedtime = t;
            vc.myscore = total;
            vc.totalscore = _exam.score;
            vc.time = _exam.time;
            vc.mid = _exam.mid.intValue;
            vc.examId = examId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
            LSTestResultViewController *vc = [[LSTestResultViewController alloc]init];
            vc.usedtime = t;
            vc.myscore = total;
            vc.totalscore = _exam.score;
            vc.time = _exam.time;
            vc.mid = _exam.mid.intValue;

            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
//    NSOperationQueue *queue = [NSOperationQueue currentQueue];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *dict = [data mutableObjectFromJSONData];
//        NSInteger ret = [[dict objectForKey:@"status"] integerValue];
//        if (ret == 1) {
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showSuccessWithStatus:@"交卷成功"];
//            
//            LSTestResultViewController *vc = [[LSTestResultViewController alloc]init];
//            vc.usedtime = t;
//            vc.myscore = total;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else
//        {
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
//            LSTestResultViewController *vc = [[LSTestResultViewController alloc]init];
//            vc.usedtime = t;
//            vc.myscore = total;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }];
    

    NSLog(@"总得分：%d",total);
}

- (void)questionToQuestionSimple:(NSMutableArray *)array
{
    smtQst = [NSMutableArray arrayWithCapacity:0];
    
    for (LSQuestion *qst in array) {
//        QuestionSimple *sq = [[QuestionSimple alloc]init];
//        sq.qid = qst.qid.intValue;
//        sq.myanswer = qst.myAser;
//        sq.right = qst.rightOrWrong;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setValue:qst.qid forKey:@"qid"];
        [dict setValue:qst.myAser forKey:@"myanswer"];
        [dict setValue:[NSString stringWithFormat:@"%d",qst.rightOrWrong ] forKey:@"right"];
        [smtQst addObject:dict];
    }
    

}


//#pragma mark - tabbar delegate
//
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    switch (item.tag) {
//        case 0:
//            [self addToFav];
//            NSLog(@"click item1");
//            break;
//        case 1:
//        {
//            
//            //现实评论view
//            [self initCommentsView];
//            
//        }
//            NSLog(@"click item2");
//            break;
//        case 2:
//            [self initCorrectionView];
//            NSLog(@"click item3");
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//    
//    
//}


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
            NSString *asContent = [answers objectAtIndex:indexPath.row];
            cell.textLabel.text = asContent;
            
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize rect = [asContent sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.x, rect.width, rect.height);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = asContent;
            
            if ([_currQuestion.myAser isEqualToString:[[answers objectAtIndex:indexPath.row] substringToIndex:1]]) {
                [cell setSelected:YES];
                tableView.userInteractionEnabled = NO;
            }
            
            
            return cell;
        }
            break;
        case CTABLE_TAG:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
               cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
               
            }
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
            {
                
                NSArray *answers = [_currQuestion.answer componentsSeparatedByString:@"|"];
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

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([qTypeString isEqualToString:@"单选"] || [qTypeString isEqualToString:@"判断"] || [qTypeString isEqualToString:@"简答"] ||  [qTypeString isEqualToString:@"论述"])
    {
        
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:NO];
       
        selectedRow = indexPath.row;
        
        NSString *myAsr = nil;
        
        if ([qTypeString isEqualToString:@"单选"]) {
            myAsr =[cell.textLabel.text substringToIndex:1];
        }
        else
        {
            myAsr = cell.textLabel.text;
        }
        
        eview.myAnswer.text = [NSString stringWithFormat:@"你的答案:%@",myAsr];
        _currQuestion.myAser = myAsr;
        
        
        if ([myAsr isEqualToString:_currQuestion.right]) {
            _currQuestion.rightOrWrong = YES;

        }else {
            _currQuestion.rightOrWrong = NO;

        }
        
        [self addFavToServer];
    } else {//多选
        
    }
    
}



#pragma mark -| nav btn click
- (void)homeBtnClicked
{
    [SVProgressHUD dismiss];
    [self smtExam];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)backBtnClicked
{
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有提交试卷，本次考试不生效！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = ALERT_BACK_TAG;
    [alert show];
    
//    [self.navigationController popViewControllerAnimated:YES];
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
