//
//  LSCommentsView.h
//  金标尺
//
//  Created by wzq on 14/6/14.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextViewWithPlaceholder.h"

@protocol LSCommentsDelegate <NSObject>

-(void)commentsBtnClick:(NSString *)content;

@end

@interface LSCommentsView : UIView
@property (nonatomic,assign) id<LSCommentsDelegate> delegate;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *smtBtn;
@property (nonatomic,strong) UITextViewWithPlaceholder *textView;
@property (nonatomic,strong) UITableView *cTableView;
- (id)initWithFrame:(CGRect)frame withComments:(NSMutableArray *)comments withTitle:(NSString *)title;
@end
