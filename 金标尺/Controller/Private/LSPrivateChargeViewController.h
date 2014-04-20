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

@property (nonatomic, strong)UITableView *table;
@property (nonatomic, strong)UIButton *dateBtn;
@property (nonatomic, strong)UIButton *paymentBtn;
@property (nonatomic, strong)UIActionSheet *pickerSheet;
@property (nonatomic, strong)NSDate *expireDate;

@property (nonatomic, assign)NSInteger totalNum;
@property (nonatomic, assign)NSString *lastDate;
@property (nonatomic, assign)NSInteger kDateSelected;
@property (nonatomic, assign)NSInteger kPaymentSelected;

@end
