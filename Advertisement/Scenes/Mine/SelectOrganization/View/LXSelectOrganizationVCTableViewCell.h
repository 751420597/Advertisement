//
//  LXSelectOrganizationVCTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXOrganizaitonModel.h"

@interface LXSelectOrganizationVCTableViewCell : UITableViewCell

@property (nonatomic, strong) LXOrganizaitonModel *organizationModel;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;

@end
