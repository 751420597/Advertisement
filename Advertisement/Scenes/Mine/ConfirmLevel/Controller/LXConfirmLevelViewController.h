//
//  LXConfirmLevelViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

#import "LXConfirmLevelModel.h"
#import "RatingLeedInfor.h"
typedef void(^ConfirmLevel)(LXConfirmLevelModel *levelModel);

@interface LXConfirmLevelViewController : LXRootTableViewController
@property (nonatomic,strong) RatingLeedInfor *ratingModel;
@property (nonatomic, copy) ConfirmLevel levelBlock;
@property (nonatomic)BOOL enableEdits;
@end
