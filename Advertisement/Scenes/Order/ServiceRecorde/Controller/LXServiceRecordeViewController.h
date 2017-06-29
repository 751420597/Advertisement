//
//  LXServiceRecordeViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/13.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

#import "ZJScrollPageViewDelegate.h"
#import "LXOrderDetailInfoViewController.h"

@interface LXServiceRecordeViewController : LXRootTableViewController <ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *orderId;
- (instancetype)initWithBottomType:(LXReservationBottomType)bottomeType;

@end
