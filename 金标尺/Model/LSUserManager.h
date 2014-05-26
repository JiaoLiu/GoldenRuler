//
//  LSUserManager.h
//  金标尺
//
//  Created by Jiao on 14-5-26.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUserManager : NSObject

// set user data
+ (void)setIsLogin:(BOOL)status;
+ (void)setUid:(int)uid;
+ (void)setKey:(int)key;
+ (void)setIsVip:(int)is_vip;
+ (void)setCid:(int)cid;
+ (void)setLastqid:(int)qid;
+ (void)setTid:(int)tid;
+ (void)setTk:(int)tk;

// get user data
+ (BOOL)getIsLogin;
+ (NSInteger)getUid;
+ (NSInteger)getKey;
+ (BOOL)getIsVip;
+ (NSInteger)getCid;
+ (NSInteger)getLastqid;
+ (NSInteger)getTid;
+ (NSInteger)getTk;

@end
