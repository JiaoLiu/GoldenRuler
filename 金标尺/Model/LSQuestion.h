//
//  LSQuestion.h
//  金标尺
//
//  Created by wzq on 14/6/7.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSQuestion : NSObject
@property (nonatomic,strong) NSString *qid;
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *tid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *answer;
@property (nonatomic,strong) NSString *right;
@property (nonatomic,strong) NSString *analysis;
@property (nonatomic) int qScore;
@property (nonatomic,strong) NSString *myAser;
@property (nonatomic) BOOL rightOrWrong;

+ (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
