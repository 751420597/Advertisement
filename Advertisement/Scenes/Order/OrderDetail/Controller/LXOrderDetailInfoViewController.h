//
//  LXOrderDetailInfoViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/13.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootViewController.h"

#import "ZJScrollPageViewDelegate.h"

typedef enum : NSUInteger {
    LXReservationBottomTypeCancelOrder,
    LXReservationBottomTypeWaitPayOrder,
    LXReservationBottomTypeWaitCommentOrder,
    LXReservationBottomTypeHavenCommentOrder,
    LXReservationBottomTypeDeleteOrder,
    LXReservationBottomTypeNone
} LXReservationBottomType;


@interface LXOrderDetailInfoViewController : LXRootViewController <ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *orderId;

- (instancetype)initWithBottomType:(LXReservationBottomType)bottomeType;

@end
