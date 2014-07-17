//
//  LSPrivateChargeViewController.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-19.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kDatePickerTag,
    kPaymentPickerTag
}pickerViewTag;

@interface LSPrivateChargeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    SEL _result;
}

@property (nonatomic, strong)UITableView *table;
@property (nonatomic, strong)UIButton *dateBtn;
@property (nonatomic, strong)UIButton *paymentBtn;
@property (nonatomic, strong)UIActionSheet *pickerSheet;
@property (nonatomic, strong)NSDate *expireDate;
@property (nonatomic, strong)NSString *lastDate;

@property (nonatomic, assign)NSInteger totalNum;
@property (nonatomic, assign)NSInteger price;
@property (nonatomic, assign)NSInteger kDateSelected;
@property (nonatomic, assign)NSInteger kPaymentSelected;
@property (nonatomic, assign)BOOL isVip;
@property (nonatomic, assign)SEL result;//这里声明为属性方便在于外部传入。

-(void)paymentResultDelegate:(NSString *)result;

@end
