//
//  NSString+Utility.m
//  金标尺
//
//  Created by Jiao on 14-4-25.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

+ (NSString *)stringFromDate:(NSDate *)date Formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)str Formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:str];
}

@end
