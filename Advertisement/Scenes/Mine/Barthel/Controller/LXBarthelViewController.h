//
//  LXBarthelViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

typedef void(^BarthelConfirm)(NSDictionary *itemArray, NSString *barthelLevel);

@interface LXBarthelViewController : LXRootTableViewController

@property (nonatomic, copy) BarthelConfirm barthelBlock;

@end
