//
//  LSUserManager.h
//  金标尺
//
//  Created by Jiao on 14-5-26.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Utility.h"
#import "UIImage+Utility.h"

@interface LSUserManager : NSObject

// set user data
+ (void)setIsLogin:(BOOL)status;
+ (void)setUid:(int)uid;
+ (void)setKey:(int)key;
+ (void)setIsVip:(int)is_vip;
+ (void)setCid:(int)cid;
+ (void)setTCid:(int)Tcid;
+ (void)setLastqid:(int)qid;
+ (void)setTid:(int)tid;
+ (void)setTk:(int)tk;
+ (void)setUserImg:(NSString *)url;
+ (void)setUserName:(NSString *)name;
+ (void)setUserTel:(NSString *)tel;
+ (void)setUserQQ:(NSString *)qq;
+ (void)setUserEmail:(NSString *)email;
+ (void)setEndTime:(NSString *)endTime;
+ (void)setUserCity:(NSString *)city;
+ (void)setPush:(int)push;
+ (void)setRevPush:(BOOL)status;
+ (void)setHidePay:(int)iospb;

// get user data
+ (BOOL)getIsLogin;
+ (NSInteger)getUid;
+ (NSInteger)getKey;
+ (BOOL)getIsVip;
+ (NSInteger)getCid;
+ (NSInteger)getTCid;
+ (NSInteger)getLastqid;
+ (NSInteger)getTid;
+ (NSInteger)getTk;
+ (UIImage *)getUserImg;
+ (NSString *)getUserName;
+ (NSString *)getUserTel;
+ (NSString *)getUserEmail;
+ (NSString *)getuserQQ;
+ (NSString *)getEndTime;
+ (NSString *)getUserCity;
+ (BOOL)getPush;
+ (BOOL)RevPush;
+ (BOOL)getHidePay;

@end
