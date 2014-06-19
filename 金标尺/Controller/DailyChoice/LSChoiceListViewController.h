//
//  LSChoiceListViewController.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-23.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSChoiceListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong)UIButton *dateSelectBtn;
@property (nonatomic, strong)UIButton *catSelectBtn;
@property (nonatomic, strong)UIActionSheet *pickerSheet;
@property (nonatomic, strong)UITableView *choiceTable;

@end
