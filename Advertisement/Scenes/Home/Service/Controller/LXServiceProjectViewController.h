//
//  LXServiceProjectViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

@interface LXServiceProjectViewController : LXRootTableViewController
@property(nonatomic,copy)NSString *careID;
@property (nonatomic,copy) void(^addBlock)(NSArray *arr);
@end
