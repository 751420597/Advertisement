//
//  LXOrganizationTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/6.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXOrganizaitonModel.h"

@interface LXOrganizationTableViewCell : UITableViewCell

@property (nonatomic, strong) LXOrganizaitonModel *oModel;

@property (weak, nonatomic) IBOutlet UIView *customeView;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *careL;

@end
