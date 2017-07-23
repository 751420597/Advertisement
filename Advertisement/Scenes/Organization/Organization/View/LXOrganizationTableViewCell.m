//
//  LXOrganizationTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/6.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrganizationTableViewCell.h"

@implementation LXOrganizationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.customeView.layer.cornerRadius = 5.f;
    self.customeView.layer.borderWidth = .5f;
    self.customeView.layer.borderColor = LXColorHex(0xE8E8E8).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOModel:(LXOrganizaitonModel *)oModel {
    _oModel = oModel;
    if(oModel.corAddr==nil){
        oModel.corAddr = @"";
    }
    if(oModel.phone1==nil){
        oModel.phone1 = @"";
    }
    [self.addressL setText:oModel.corName];
    [self.detailAddressL setText:[NSString stringWithFormat:@"地址：%@", oModel.corAddr]];
    [self.phoneL setText:[NSString stringWithFormat:@"电话：%@", oModel.phone1]];
    [self.careL setText:[NSString stringWithFormat:@"护工：%@", oModel.agencyCount]];
}

@end
