//
//  LXAddCareViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

@interface LXAddCareViewController : LXRootTableViewController
@property(nonatomic,copy)void (^reloadBlock)();
@property (nonatomic, copy) NSString *careId;

@end
