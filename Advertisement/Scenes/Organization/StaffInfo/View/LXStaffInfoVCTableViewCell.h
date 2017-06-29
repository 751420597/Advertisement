//
//  LXStaffInfoVCTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/10.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWStarRateView.h"

#import "LXStaffCommentModel.h"

@interface LXStaffInfoVCTableViewCell : UITableViewCell

@property (nonatomic, strong) LXStaffCommentModel *commentModel;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet CWStarRateView *starView;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *statisfyL;

@end
