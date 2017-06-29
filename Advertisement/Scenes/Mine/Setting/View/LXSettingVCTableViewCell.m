//
//  LXSettingVCTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/8.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXSettingVCTableViewCell.h"

@implementation LXSettingVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.customeView lx_setViewCornerRadius:3.f borderColor:LXVCBackgroundColor borderWidth:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
