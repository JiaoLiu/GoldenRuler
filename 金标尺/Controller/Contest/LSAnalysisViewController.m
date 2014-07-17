//
//  LSAnalysisViewController.m
//  金标尺
//
//  Created by wzq on 14/7/2.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSAnalysisViewController.h"

@interface LSAnalysisViewController ()
{
    int currIndex;
    LSContestView *eview;//考题view
    NSString *qTypeString;
    
    NSMutableArray *filterQuetions;
}
@end

@implementation LSAnalysisViewController

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
    self.title = @"查看答案及解析";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self filterQuetions];
   
}

- (void)filterQuetions
{
    filterQuetions = [NSMutableArray arrayWithCapacity:0];
    
    
    for (LSQuestion *q  in _questionList) {
        if (q.myAser != nil && ![q.myAser isEqualToString:@""]) {
            [filterQuetions addObject:q];
        }
    }
    
    if (filterQuetions.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂未答题"];
    }
    else
    {
        _currQuestion = [filterQuetions objectAtIndex:0];
        currIndex = 0;
        [self initExamView];
    }

}


//考试界面
- (void)initExamView
{

    [self clearAllView];
    
    eview = [[LSContestView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) withQuestion:_currQuestion withIndex:currIndex+1];
    [eview.selectBtn setTitle:[NSString stringWithFormat:@"%d/%d",currIndex+1,filterQuetions.count] forState:UIControlStateNormal];
    [eview.smtBtn setTitle:[NSString stringWithFormat:@"%d/%d",currIndex+1,filterQuetions.count] forState:UIControlStateNormal];
    
    
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
    [eview.questionView setEditing:NO];

    eview.delegate = self;
    [eview.operTop setHidden:NO];
   
    [eview.yellowBtn setHidden:NO];
    [eview.smtBtn setEnabled:NO];
    [self.view addSubview:eview];

    
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


#pragma mark -exam delegate
- (void)prevQuestion
{
    NSLog(@"上一题");
    if (currIndex==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已是第一题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    currIndex = currIndex < 0 ? 0:currIndex;
   
    if (currIndex > 0) {
        
        _currQuestion = [filterQuetions objectAtIndex:--currIndex];
        [self initExamView];
    }
    

}

- (void)nextQuestion
{
    NSLog(@"下一题");
    

    currIndex += 1;
    currIndex = currIndex > filterQuetions.count ? filterQuetions.count : currIndex;
    
    // 当前index大于题目总数 并且历史考题的数量等于题目总数
    if (currIndex >= filterQuetions.count )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最后一题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [SVProgressHUD dismiss];
        return;
    }
    
    
        
        if (currIndex < filterQuetions.count)
        {
            _currQuestion = [filterQuetions objectAtIndex:currIndex];
            [self initExamView];
        }
        else
        {
            
            [SVProgressHUD dismiss];
            
        }
    

    
}

-(void)chooseQuestion
{
    LSChooseQuestionViewController *vc = [[LSChooseQuestionViewController alloc]init];
    vc.questions = filterQuetions;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showAnalysis
{
    if (![LSUserManager getIsVip]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您现在是普通会员不能查看解析，充值称为VIP会员即可查看解析" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"马上充值", nil];
        alert.tag = 99;
        [alert show];
        return;
    }
    [eview.textLabel setHidden:NO];
}

#pragma mark - alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 99) {
        //TODO 充值
    }
}


#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
   NSArray *answers = [_currQuestion.answer componentsSeparatedByString:@"|"];
   return answers.count;
        

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            cell.userInteractionEnabled = NO;
    
            return cell;
        
          
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  UITableViewCell *cell  =  [tableView cellForRowAtIndexPath:indexPath];
//    cell.userInteractionEnabled = NO;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//    return UITableViewCellEditingStyleNone;
// 
//}

#pragma mark - choosequestion delegate
- (void)seletedQuestion:(int)index
{
    _currQuestion = [filterQuetions objectAtIndex:index];
    currIndex = index;
    [self initExamView];
}


- (void)backBtnClicked
{
    [SVProgressHUD dismiss];
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
