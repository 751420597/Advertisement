//
//  LXConfirmInfoViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

#import "LXConfirmInfoModel.h"

typedef void(^ConfirmInfo)(LXConfirmInfoModel *confirmInfoModel);

@interface LXConfirmInfoViewController : LXRootTableViewController

@property (nonatomic, copy) ConfirmInfo infoBlock;

@end
