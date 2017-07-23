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
    
    if(orderListModel.tmUserName.length>0){
        [self.name setText:orderListModel.tmUserName];
    }else{
        [self.name setText:orderListModel.tmUserCode];
    }
    
    
    [self.orderTime setText:[NSString stringWithFormat:@"下单时间：%@", orderListModel.crtTime]];
    
    [self.orderSum setText:[NSString stringWithFormat:@"服务金额：%@", orderListModel.ordAmt]];
     [self.serveTimeLB setText:[NSString stringWithFormat:@"服务时间：%@", orderListModel.serveTime]];
    
    if ([orderListModel.ordStatId isEqualToString:@"1"]) {
        [self.waitOrder setText:@"待接单"];
    }
    else if ([orderListModel.ordStatId isEqualToString:@"2"]) {
        [self.waitOrder setText:@"待服务"];
    }
    else if ([orderListModel.ordStatId isEqualToString:@"3"]) {
        [self.waitOrder setText:@"服务中"];
    }
    else if ([orderListModel.ordStatId isEqualToString:@"4"]) {
       [self.waitOrder setText:@"待支付"];
    }else if ([orderListModel.ordStatId isEqualToString:@"5"]) {
        [self.waitOrder setText:@"待评价"];
    }else if ([orderListModel.ordStatId isEqualToString:@"6"]) {
        [self.waitOrder setText:@"已评价"];
    }else{
         [self.waitOrder setText:@"已取消"];
    }
}

@end
