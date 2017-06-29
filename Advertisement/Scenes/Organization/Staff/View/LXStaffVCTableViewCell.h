//
//  LXStaffVCTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/10.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWStarRateView.h"

#import "LXStaffModel.h"

@interface LXStaffVCTableViewCell : UITableViewCell

@property (nonatomic, strong) LXStaffModel *sModel;

@property (weak, nonatomic) IBOutlet UIView *customeView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *sexualL;
@property (weak, nonatomic) IBOutlet UILabel *workingYearsL;

@property (weak, nonatomic) IBOutlet CWStarRateView *starView;


@end
