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
@property (nonatomic,assign)int states;//0.申请长护险  1//有长护险 2.//没有

@end
