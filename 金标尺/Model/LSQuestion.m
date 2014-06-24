//
//  LSQuestion.m
//  金标尺
//
//  Created by wzq on 14/6/7.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSQuestion.h"

@implementation LSQuestion

+ (LSQuestion* )initWithDictionary:(NSDictionary *)dict
{
    LSQuestion *question = nil;
    
    if (dict != nil) {
        question = [[super alloc]init];
        question.qid = [dict objectForKey:@"qid"];
        question.cid = [dict objectForKey:@"cid"];
        question.tid = [dict objectForKey:@"tid"];
        question.title = [dict objectForKey:@"title"];
        question.answer = [dict objectForKey:@"answer"];
        question.right = [dict objectForKey:@"right"];
        question.analysis = [dict objectForKey:@"analysis"];
        question.myAser = [dict objectForKey:@"myanswer"];
    }
    
    
    return question;
}
@end
