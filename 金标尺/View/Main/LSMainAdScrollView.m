//
//  LSMainAdScrollView.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-13.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSMainAdScrollView.h"

@implementation LSMainAdScrollView

@synthesize scrollPageControl;

- (id)initWithFrame:(CGRect)frame Items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        // subViews
        for (int i = 0; i < items.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height)];
            imgView.backgroundColor = RGBA(100, 30, 41, i/items.count);
            [self addSubview:imgView];
        }
        
        // init pageControl
        scrollPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.size.width - 100, frame.size.height - 40, 100, 30)];
        scrollPageControl.numberOfPages = items.count;
        scrollPageControl.backgroundColor = [UIColor blackColor];
        [scrollPageControl addTarget:self action:@selector(scrollPage) forControlEvents:UIControlEventValueChanged];
        [self addSubview:scrollPageControl];
        
        self.contentSize = CGSizeMake(frame.size.width * (items.count + 1), frame.size.height);
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.pagingEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)scrollPage
{
    
}

@end
