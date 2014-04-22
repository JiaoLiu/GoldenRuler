//
//  LSPrivateCollectionViewController.h
//  金标尺
//
//  Created by Jiao on 14-4-22.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSPrivateCollectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *collectionTable;

@end
