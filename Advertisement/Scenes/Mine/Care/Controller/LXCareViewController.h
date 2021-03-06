//
//  LXCareViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

typedef void(^CareSelect)(NSString *careID, NSString *name);

@interface LXCareViewController : LXRootTableViewController

@property (nonatomic, copy) CareSelect selectBlock;
@property (nonatomic, copy) NSString* careID_0;
@property (nonatomic,assign)BOOL isOrder;
- (instancetype)initWithIsAddCare:(BOOL)isAdd;

@end
