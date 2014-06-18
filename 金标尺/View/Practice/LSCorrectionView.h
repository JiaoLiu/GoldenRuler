//
//  LSCorrectionView.h
//  金标尺
//
//  Created by wzq on 14/6/14.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextViewWithPlaceholder.h"

@protocol LSCorrectionDelegate <NSObject>

- (void)correctionBtnClick:(NSString *)content;

@end

@interface LSCorrectionView : UIView
@property (nonatomic,assign) id<LSCorrectionDelegate> delegate;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *smtBtn;
@property (nonatomic,strong) UITextViewWithPlaceholder *textView;
- (id)initWithFrame:(CGRect)frame withTitle:(NSString*) title;
@end
