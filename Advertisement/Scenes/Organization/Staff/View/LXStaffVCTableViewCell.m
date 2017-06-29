//
//  LXStaffVCTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/10.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXStaffVCTableViewCell.h"

@implementation LXStaffVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.starView setScorePercent:0.8];
    [self.starView setAllowIncompleteStar:YES];
    [self.starView setHasAnimation:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSModel:(LXStaffModel *)sModel {
    _sModel = sModel;
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@", GetImage, sModel.avatarImageId];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:requestString] placeholderImage:[UIImage imageNamed:@"Mine_male"]];
    
    [self.nameL setText:sModel.userName];
    
    [self.sexualL setText:[NSString stringWithFormat:@"性别：%@", sModel.sex]];
    
    [self.workingYearsL setText:[NSString stringWithFormat:@"工作年限：%@",sModel.workYears]];
    
    [self.starView setScorePercent:sModel.overallMerit.integerValue];
}

@end
