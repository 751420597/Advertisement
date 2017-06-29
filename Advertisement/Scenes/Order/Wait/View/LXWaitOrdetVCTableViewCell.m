//
//  LXWaitOrdetVCTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/7.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXWaitOrdetVCTableViewCell.h"

@implementation LXWaitOrdetVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.customeView.layer.cornerRadius = 3.f;
    self.customeView.layer.borderColor = LXColorHex(0xebebeb).CGColor;
    self.customeView.layer.borderWidth = 1.5;
    
    self.waitOrder.layer.cornerRadius = 3.f;
    self.waitOrder.layer.borderColor = LXMainColor.CGColor;
    self.waitOrder.layer.borderWidth = 1.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderListModel:(LXOrderListModel *)orderListModel {
    _orderListModel = orderListModel;
    
    [self.name setText:orderListModel.tmUserName];
    
    [self.orderTime setText:[NSString stringWithFormat:@"下单时间：%@", orderListModel.crtTime]];
    
    [self.orderSum setText:[NSString stringWithFormat:@"服务金额：%@", orderListModel.ordAmt]];
    
    if (orderListModel.type == 0) {
        [self.waitOrder setText:@"待接单"];
    }
    else if (orderListModel.type == 1) {
        [self.waitOrder setText:@"待服务"];
    }
    else if (orderListModel.type == 2) {
        [self.waitOrder setText:@"已完成"];
    }
    else if (orderListModel.type == 3) {
        [self.waitOrder setText:@"已取消"];
    }
}

@end
