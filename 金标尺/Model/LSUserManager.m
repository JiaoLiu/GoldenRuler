//
//  LSUserManager.m
//  金标尺
//
//  Created by Jiao on 14-5-26.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSUserManager.h"

@implementation LSUserManager

#pragma mark - set User Info
+ (void)setIsLogin:(BOOL)status
{
    if (status) {
        [USER_DEFAULT setObject:@"Y" forKey:isLoginKey];
    }
    else [USER_DEFAULT setObject:@"N" forKey:isLoginKey];
    [USER_DEFAULT synchronize];
}

+ (void)setCid:(int)cid
{
    [USER_DEFAULT setObject:[NSNumber numberWithInt:cid] forKey:@"_USER_CID_"];
    [USER_DEFAULT synchronize];
}

+ (void)setKey:(int)key
{
    [USER_DEFAULT setObject:[NSNumber numberWithInt:key] forKey:@"_USER_KEY_"];
    [USER_DEFAULT synchronize];
}

+ (void)setLastqid:(int)qid
{
    [USER_DEFAULT setObject:[NSNumber numberWithInt:qid] forKey:@"_USER_QID_"];
    [USER_DEFAULT synchronize];
}

+ (void)setTid:(int)tid
{
    [USER_DEFAULT setObject:[NSNumber numberWithInt:tid] forKey:@"_USER_TID_"];
    [USER_DEFAULT synchronize];
}

+ (void)setUid:(int)uid
{
    [USER_DEFAULT setObject:[NSNumber numberWithInt:uid] forKey:@"_USER_UID_"];
    [USER_DEFAULT synchronize];
}

+ (void)setTk:(int)tk
{
    [USER_DEFAULT setObject:[NSNumber numberWithInt:tk] forKey:@"_USER_TK_"];
    [USER_DEFAULT synchronize];
}

+ (void)setIsVip:(int)is_vip
{
    if (is_vip == 1) {
        [USER_DEFAULT setObject:@"Y" forKey:@"_USER_VIP_"];
    }
    else [USER_DEFAULT setObject:@"N" forKey:@"_USER_VIP_"];
    [USER_DEFAULT synchronize];
}

#pragma mark - get User Info
+ (BOOL)getIsLogin
{
    if ([[USER_DEFAULT objectForKey:isLoginKey] isEqualToString:@"Y"]) {
        return TRUE;
    }
    else return FALSE;
}

+ (BOOL)getIsVip
{
    if ([[USER_DEFAULT objectForKey:@"_USER_VIP_"] isEqualToString:@"Y"]) {
        return TRUE;
    }
    else return FALSE;
}

+ (NSInteger)getUid
{
    return [[USER_DEFAULT objectForKey:@"_USER_UID_"] integerValue];
}

+ (NSInteger)getTid
{
    return [[USER_DEFAULT objectForKey:@"_USER_TID_"] integerValue];
}

+ (NSInteger)getCid
{
    return [[USER_DEFAULT objectForKey:@"_USER_CID_"] integerValue];
}

+ (NSInteger)getLastqid
{
    return [[USER_DEFAULT objectForKey:@"_USER_QID_"] integerValue];
}

+ (NSInteger)getKey
{
    return [[USER_DEFAULT objectForKey:@"_USER_KEY_"] integerValue];
}

+ (NSInteger)getTk
{
    return [[USER_DEFAULT objectForKey:@"_USER_TK_"] integerValue];
}

@end
