//
//  LSImageButton.h
//  金标尺
//
//  Created by Jiao on 14-5-8.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSImageButton : UIButton

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) UIFont *titleFont;

- (void)setImage:(UIImage *)image;
- (void)setTitle:(NSString *)title;
- (void)setTitleFont:(UIFont *)titleFont;

@end
