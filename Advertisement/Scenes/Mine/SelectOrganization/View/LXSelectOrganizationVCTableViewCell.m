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
    if(organizationModel.corAddr==nil){
        organizationModel.corAddr = @"";
    }
    if(organizationModel.distance==nil){
        organizationModel.distance = @"*";
    }
    [self.nameL setText:organizationModel.corName];
    
    [self.addressL setText:[NSString stringWithFormat:@"地址：%@", organizationModel.corAddr]];
    
    if(organizationModel.distance.floatValue>1000&&organizationModel.distance.floatValue<=2000){
        [self.distanceL setText:[NSString stringWithFormat:@"%.1fkm",organizationModel.distance.floatValue/1000]];
    }else if (organizationModel.distance.floatValue>2000){
        [self.distanceL setText:[NSString stringWithFormat:@"大于2km"]];
    }else{
        [self.distanceL setText:[NSString stringWithFormat:@"%.1fm", organizationModel.distance.floatValue ]];
    }
    
}


@end
