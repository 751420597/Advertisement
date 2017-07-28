//
//  LXTimeSelectViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/14.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootViewController.h"

typedef void(^TimeSelect)(NSArray *timeArray, NSString *repeat);

@interface LXTimeSelectViewController : LXRootViewController
@property(nonatomic ,strong)NSMutableArray *timeStringArr;
@property (nonatomic, copy) TimeSelect selectBlock;
@property (nonatomic) NSInteger repeatTimeInter;
@end
