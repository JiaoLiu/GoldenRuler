//
//  LSPrivateInfoViewController.h
//  金标尺
//
//  Created by Jiao Liu on 14-4-20.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSPrivateInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)UITableView *table;
@property (nonatomic, strong)UIImageView *imgView;

@end
