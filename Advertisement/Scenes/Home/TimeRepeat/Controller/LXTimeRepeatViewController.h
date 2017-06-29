//
//  LXTimeRepeatViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

typedef void(^TimeRepeat)(NSInteger);

@interface LXTimeRepeatViewController : LXRootTableViewController

@property (nonatomic, copy) TimeRepeat myblock;

@end
