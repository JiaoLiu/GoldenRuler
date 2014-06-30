//
//  LSMainAdScrollView.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-13.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMainAdScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong)UIPageControl *scrollPageControl;
@property (nonatomic, strong)NSDictionary *items;

- (id)initWithFrame:(CGRect)frame;

@end
