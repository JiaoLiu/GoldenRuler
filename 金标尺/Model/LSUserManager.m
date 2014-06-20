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

+ (void)setTCid:(int)Tcid
{
    [USER_DEFAULT setObject:[NSNumber numberWithInt:Tcid] forKey:@"_USER_TCID_"];
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

+ (void)setUserImg:(NSString *)url
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",[LSUserManager getUid]]];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//    NSLog(@"%@",path);
    NSString *filePath = [path stringByAppendingPathComponent:@"header.jpg"];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    
    [USER_DEFAULT setObject:filePath forKey:@"_USER_IMG_"];
    [USER_DEFAULT synchronize];
}

+ (void)setUserTel:(NSString *)tel
{
    [USER_DEFAULT setObject:tel forKey:@"_USER_TEL_"];
    [USER_DEFAULT synchronize];
}

+ (void)setUserQQ:(NSString *)qq
{
    [USER_DEFAULT setObject:qq forKey:@"_USER_QQ_"];
    [USER_DEFAULT synchronize];
}

+ (void)setUserEmail:(NSString *)email
{
    [USER_DEFAULT setObject:email forKey:@"_USER_EMAIL_"];
    [USER_DEFAULT synchronize];
}

+ (void)setUserName:(NSString *)name
{
    [USER_DEFAULT setObject:name forKey:@"_USER_NAME_"];
    [USER_DEFAULT synchronize];
}

+ (void)setEndTime:(NSString *)endTime
{
    [USER_DEFAULT setObject:endTime forKey:@"_USER_ENDTIME_"];
    [USER_DEFAULT synchronize];
}

+ (void)setPush:(int)push
{
    if (push == 1) {
        [USER_DEFAULT setObject:@"Y" forKey:@"_USER_PUSH_"];
    }
    else [USER_DEFAULT setObject:@"N" forKey:@"_USER_PUSH_"];
    [USER_DEFAULT synchronize];
}

+ (void)setRevPush:(BOOL)status
{
    NSString *key = [NSString stringWithFormat:@"_USER_PUSH_REV_%d",[LSUserManager getUid]];
    if (status) {
        [USER_DEFAULT setObject:@"Y" forKey:key];
    }
    else [USER_DEFAULT setObject:@"N" forKey:key];
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

+ (NSInteger)getTCid
{
    return [[USER_DEFAULT objectForKey:@"_USER_TCID_"] integerValue];
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

+ (UIImage *)getUserImg
{
    NSString *filePath = [USER_DEFAULT objectForKey:@"_USER_IMG_"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

+ (NSString *)getUserEmail
{
    return [USER_DEFAULT objectForKey:@"_USER_EMAIL_"];
}

+ (NSString *)getUserName
{
    return [USER_DEFAULT objectForKey:@"_USER_NAME_"];
}

+ (NSString *)getuserQQ
{
    return [USER_DEFAULT objectForKey:@"_USER_QQ_"];
}

+ (NSString *)getUserTel
{
    return [USER_DEFAULT objectForKey:@"_USER_TEL_"];
}

+ (NSString *)getEndTime
{
    return [USER_DEFAULT objectForKey:@"_USER_ENDTIME_"];
}

+ (BOOL)getPush
{
    if ([[USER_DEFAULT objectForKey:@"_USER_PUSH_"] isEqualToString:@"Y"]) {
        return TRUE;
    }
    else return FALSE;
}

+ (BOOL)RevPush
{
    NSString *key = [NSString stringWithFormat:@"_USER_PUSH_REV_%d",[LSUserManager getUid]];
    if ([[USER_DEFAULT objectForKey:key] isEqualToString:@"Y"]) {
        return TRUE;
    }
    else return FALSE;
}

@end
