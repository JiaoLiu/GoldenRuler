//
//  LSPrivateCommentDetailViewController.h
//  金标尺
//
//  Created by Jiao on 14-6-25.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCommentsView.h"
#import "LSComments.h"

@interface LSPrivateCommentDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LSCommentsDelegate>

@property (nonatomic, assign)NSInteger qid;
@property (nonatomic, strong)LSComments *myComment;

@end
