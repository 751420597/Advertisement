//
//  LXCareDetailViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

@interface LXCareDetailViewController : LXRootTableViewController

@property (nonatomic, copy) NSString *careId;
@property (nonatomic, assign) BOOL isPass;
@property (nonatomic,copy)NSString *checkStateId;
@property(nonatomic,copy)void (^reloadBlock)();
@end
