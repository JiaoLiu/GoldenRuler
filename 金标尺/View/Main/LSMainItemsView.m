//
//  LSMainItemsVIew.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-12.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSMainItemsVIew.h"

@implementation LSMainItemsView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame Items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger count = items.count;
        NSInteger col = (count + 1) / 2;
        CGFloat heigt = (frame.size.height - (col - 1) * 10) / col;
        CGFloat width = (frame.size.width - 10) / 2;
        for (int i = 0; i < col; i++) {
            for (int j = 0; j < 2; j ++) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(j * (width + 10), i * (heigt + 10), width, heigt)];
                btn.backgroundColor = RGB(100 + j*200, 135, 50 + i*300);
                [btn setTitle:[items objectAtIndex:j + i * 2] forState:UIControlStateNormal];
                btn.tag = j + i * 2;
                [btn addTarget:self action:@selector(clickedOnItem:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
    }
    return self;
}

- (void)clickedOnItem:(UIButton *)sender
{
    if (delegate && [delegate respondsToSelector:@selector(clickedOnItem:)]) {
        [delegate performSelector:@selector(clickedOnItem:) withObject:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
