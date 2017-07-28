//
//  LXServiceProjectVCTableCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXServiceProjectVCTableCell.h"

@implementation LXServiceProjectVCTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    if (selected) {
//        [self.arrowBtn setBackgroundImage:[UIImage imageNamed:@"Home_cell_selected"] forState:UIControlStateNormal];
//    }
//    else {
//        [self.arrowBtn setBackgroundImage:[UIImage imageNamed:@"Home_cell_normal"] forState:UIControlStateNormal];
//    }
//}

- (void)setServiceProjectModel:(LXServiceProjectModel *)serviceProjectModel {
    _serviceProjectModel = serviceProjectModel;
    
    [self.leadingL setText:serviceProjectModel.goodsName];
    
    [self.middleL setText:[NSString stringWithFormat:@"￥：%@", serviceProjectModel.price]];
}

-(void)setOrderDetailSeriviceModel:(LXOrderDetailSeriviceModel *)orderDetailSeriviceModel{
    _orderDetailSeriviceModel = orderDetailSeriviceModel;
    self.leadingL.text = orderDetailSeriviceModel.careItemName;
    self.middleL.text =[NSString stringWithFormat:@"￥：%@", orderDetailSeriviceModel.careItemPrice];
}
- (IBAction)selectBtnClick:(id)sender {
    if (self.cellSelectBlock) {
        self.cellSelectBlock();
    }
}

@end
