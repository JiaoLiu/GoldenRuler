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
        _items = items;
        // subViews
        for (int i = 0; i < items.count; i++) {
            UIButton *imgView = [[UIButton alloc] initWithFrame:CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height)];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[items objectAtIndex:i] objectForKey:@"path"]]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imgView setImage:img forState:UIControlStateNormal];
                });
            });
            imgView.tag = i;
            [imgView addTarget:self action:@selector(clickOnAd:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:imgView];
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

- (void)clickOnAd:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[_items objectAtIndex:sender.tag] objectForKey:@"url"]]];
}

@end
