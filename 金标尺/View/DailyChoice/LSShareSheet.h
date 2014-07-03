//
//  LSShareSheet.h
//  金标尺
//
//  Created by Jiao on 14-7-3.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

typedef enum : NSUInteger {
    kShareWeibo = 100,
    kShareSina,
    kShareWeixin
} kShareType;

@interface LSShareSheet : UIActionSheet<UIActionSheetDelegate>

@property (nonatomic, strong)NSDictionary *items;

- (id)initWithDelegate:(id)delegate;

@end
