//
//  LSExamDelegate.h
//  金标尺
//
//  Created by wzq on 14/6/14.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSExamDelegate <NSObject>

- (void)nextQuestion;
- (void)prevQuestion;
- (void)smtExam;
@optional
- (void)smtAnswer;

@end


