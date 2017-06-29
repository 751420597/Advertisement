//
//  LXConfirmLevelViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

#import "LXConfirmLevelModel.h"

typedef void(^ConfirmLevel)(LXConfirmLevelModel *levelModel);

@interface LXConfirmLevelViewController : LXRootTableViewController

@property (nonatomic, copy) ConfirmLevel levelBlock;

@end
