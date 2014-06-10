//
//  LSQuestionView.h
//  金标尺
//
//  Created by wzq on 14/6/7.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSQuestion.h"

@interface LSQuestionView : UIView
@property (nonatomic,strong) LSQuestion *question;
@property (strong, nonatomic)  UILabel *questionTitle;
@property (strong, nonatomic) NSString *answer;
- (void)refresh;
@end


@interface LSAnswerView : UIView
@property (nonatomic,strong) UIButton *checkBtn;
@property (nonatomic,strong) UILabel *contentLabel;
- (id)initWithFrame:(CGRect)frame answer:(NSString *)answer;
@end