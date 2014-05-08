//
//  LSImageButton.m
//  金标尺
//
//  Created by Jiao on 14-5-8.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSImageButton.h"

@implementation LSImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    imgView.image = self.image;
    imgView.center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0 - 10);
    [self addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y + imgView.frame.size.height + 5, rect.size.width, 20)];
    label.text = self.title;
    label.font = self.titleFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [self addSubview:label];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
}

@end
