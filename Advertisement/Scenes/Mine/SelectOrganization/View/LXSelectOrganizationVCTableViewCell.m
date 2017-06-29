//
//  LXSelectOrganizationVCTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXSelectOrganizationVCTableViewCell.h"

@implementation LXSelectOrganizationVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrganizationModel:(LXOrganizaitonModel *)organizationModel {
    _organizationModel = organizationModel;
    
    [self.nameL setText:organizationModel.corName];
    
    [self.addressL setText:[NSString stringWithFormat:@"地址：%@", organizationModel.corAddr]];
    
    [self.distanceL setText:[NSString stringWithFormat:@"%@米", organizationModel.distance ]];
}


@end
