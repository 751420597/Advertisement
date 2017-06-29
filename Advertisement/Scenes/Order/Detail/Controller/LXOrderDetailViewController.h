//
//  LXOrderDetailViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/13.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootViewController.h"

#import "LXOrderDetailInfoViewController.h"

@interface LXOrderDetailViewController : LXRootViewController

@property (nonatomic, copy) NSString *orderId;
- (instancetype)initWithType:(LXReservationBottomType)bottomeType;

@end
