//
//  UITextViewWithPlaceholder.h
//  MOfficeNGUI
//
//  Created by wzq on 14-5-23.
//  Copyright (c) 2014年 infowarelab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextViewWithPlaceholder : UITextView

@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
