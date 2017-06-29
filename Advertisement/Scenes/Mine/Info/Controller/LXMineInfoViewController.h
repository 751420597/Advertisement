//
//  LXMineInfoViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

#import "LXMineModel.h"

@interface LXMineInfoViewController : LXRootTableViewController

@property (nonatomic, strong) LXMineModel *mineModel;
@property (nonatomic, strong) void (^okBlock)();
@end
