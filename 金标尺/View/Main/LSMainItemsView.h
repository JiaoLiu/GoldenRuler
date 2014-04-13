//
//  LSMainItemsView.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSMainItemsViewDelegate <NSObject>

@required
- (void)clickedOnItem:(UIButton *)sender;

@end

@interface LSMainItemsView : UIView

@property (nonatomic, assign)id<LSMainItemsViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame Items:(NSArray *)items;

@end
