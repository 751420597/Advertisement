//
//  LXReservationViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/9.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootViewController.h"

#import "ZJScrollPageViewDelegate.h"


@interface LXReservationViewController : LXRootViewController <ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *orderId;

@end
