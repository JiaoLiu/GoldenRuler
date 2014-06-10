//
//  LSExam.h
//  金标尺
//
//  Created by wzq on 14/6/7.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSExam : NSObject
@property (nonatomic,strong) NSString *mid;
@property (nonatomic,assign) int time;
@property (nonatomic,assign) int score;
@property (nonatomic,assign) int num;
@property (nonatomic,strong) NSArray *list;
@end
