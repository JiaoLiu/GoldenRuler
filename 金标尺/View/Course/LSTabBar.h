//
//  LSTabBar.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-27.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSTabBarDelegate <NSObject>

@required
- (void)SelectItemAtIndex:(NSNumber *)index;

@end

@interface LSTabBar : UIView

@property (nonatomic, copy)NSArray *items;
@property (nonatomic, assign)NSInteger selectedItem;

@property(nonatomic,assign) id<LSTabBarDelegate> delegate;

@end
