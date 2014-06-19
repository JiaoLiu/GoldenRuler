//
//  LSCourseRecommendViewController.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-27.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTabBar.h"

@interface LSCourseRecommendViewController : UIViewController<LSTabBarDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong)UIButton *dateSelectBtn;
@property (nonatomic, strong)UIButton *catSelectBtn;
@property (nonatomic, strong)UIActionSheet *pickerSheet;
@property (nonatomic, strong)UITableView *courseTable;

@end
