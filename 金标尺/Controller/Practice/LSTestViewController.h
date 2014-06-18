//
//  LSTestViewController.h
//  金标尺
//
//  Created by wzq on 14/6/13.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCommentsView.h"
#import "LSCorrectionView.h"
#import "LSExamDelegate.h"

@interface LSTestViewController : UIViewController<UITabBarDelegate,
                                                UITableViewDataSource,
                                                UITableViewDelegate,
                                                LSCorrectionDelegate,
                                                LSCommentsDelegate,
                                                LSExamDelegate>
@property (nonatomic) LSWrapType examType;
@end
