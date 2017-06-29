//
//  LXStaffInfoVCTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/10.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXStaffInfoVCTableViewCell.h"

@implementation LXStaffInfoVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starView.scorePercent = 0.3;
    self.starView.allowIncompleteStar = YES;
    self.starView.hasAnimation = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentModel:(LXStaffCommentModel *)commentModel {
    _commentModel = commentModel;
    
    NSString *phoneString = commentModel.tmUserCode;
    NSString *leadString = [phoneString substringToIndex:phoneString.length - 8];
    NSString *trailingString = [phoneString substringFromIndex:phoneString.length - 4];
    NSString *replaceString = [NSString stringWithFormat:@"%@%@%@", leadString, @"****", trailingString];
    [self.phoneNumber setText:replaceString];
    
    self.starView.scorePercent = commentModel.starLvlAll.integerValue;
    
    self.statisfyL.text = commentModel.evContent;
    
    self.timeL.text = commentModel.updTime;
}

@end
