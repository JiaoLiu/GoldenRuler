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
            
            UILabel *title = [[UILabel alloc] initWithFrame:imgView.frame];
            title.backgroundColor = [UIColor clearColor];
            title.text = [items objectAtIndex:i];
            title.textAlignment = NSTextAlignmentCenter;
            [self addSubview:title];
        }
        
        // init pageControl
        scrollPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.size.width - 100, frame.size.height - 40, 100, 30)];
        scrollPageControl.numberOfPages = items.count;
        scrollPageControl.pageIndicatorTintColor = [UIColor whiteColor];
        scrollPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [scrollPageControl addTarget:self action:@selector(scrollPage) forControlEvents:UIControlEventValueChanged];
        [self addSubview:scrollPageControl];
        
        self.contentSize = CGSizeMake(frame.size.width * items.count, frame.size.height);
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.pagingEnabled = YES;
        self.clipsToBounds = YES;
        self.delegate = self;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (scrollPageControl.currentPage != page) {
        scrollPageControl.currentPage = page;
    }
    CGRect frame = scrollPageControl.frame;
    frame.origin.x = scrollView.contentOffset.x + pageWidth - 100;
    scrollPageControl.frame = frame;
}

- (void)scrollPage
{
    int page  = scrollPageControl.currentPage;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentOffset = CGPointMake(page * self.frame.size.width, 0);
    }];
}

@end
