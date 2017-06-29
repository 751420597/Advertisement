//
//  LXConfirmViewTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXConfirmViewTableViewCell.h"

@implementation LXConfirmViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.dotBtn setBackgroundColor:LXMainColor];
    [self.dotBtn lx_setViewCornerRadius:5 borderColor:nil borderWidth:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setServiceModel:(LXServiceProjectModel *)serviceModel {
    [self.leadingL setText:serviceModel.goodsName];
    [self.middleL setText:@"x1"];
    [self.trailingL setText:serviceModel.price];
}

@end
