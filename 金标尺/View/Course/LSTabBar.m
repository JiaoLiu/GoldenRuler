//
//  LSTabBar.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-27.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSTabBar.h"

@implementation LSTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _selectedItem = -1;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSInteger count = _items.count;
    for (int i = 0; i < count; i++) {
        UIImageView *item = [[UIImageView alloc] initWithFrame:CGRectMake(0 + i * rect.size.width / count, 0, rect.size.width / count, rect.size.height)];
        if (_selectedItem == i) {
            item.image = [[UIImage imageNamed:@"tabbg_on"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
        else
        {
            item.image = [[UIImage imageNamed:@"tabbg_off"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
        item.tag = i;
        item.userInteractionEnabled = YES;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, item.frame.size.width, item.frame.size.height)];
        title.text = [_items objectAtIndex:i];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        [item addSubview:title];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SelectItem:)];
        [item addGestureRecognizer:tapGes];
        [self addSubview:item];
    }
}

- (void)SelectItem:(UITapGestureRecognizer *)tapGes
{
    CGFloat width = self.frame.size.width / _items.count;
    if (tapGes.state == UIGestureRecognizerStateEnded) {
        CGPoint endPoint = [tapGes locationInView:self];
        _selectedItem =  endPoint.x / width;
    }
//    for (UIImageView *item in [self subviews]) {
//        if (item.tag == _selectedItem) {
//            item.image = [[UIImage imageNamed:@"tabbg_on"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//        }
//        else
//        {
//            item.image = [[UIImage imageNamed:@"tabbg_off"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//        }
//    }
    [self setSelectedItem:_selectedItem];
    if (_delegate && [_delegate respondsToSelector:@selector(SelectItemAtIndex:)]) {
        [_delegate performSelector:@selector(SelectItemAtIndex:) withObject:[NSNumber numberWithInt:_selectedItem]];
    }
}

- (void)setSelectedItem:(NSInteger)selectedItem
{
    for (UIImageView *item in [self subviews]) {
        if (item.tag == selectedItem) {
            item.image = [[UIImage imageNamed:@"tabbg_on"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
        else
        {
            item.image = [[UIImage imageNamed:@"tabbg_off"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
    }
}

@end
