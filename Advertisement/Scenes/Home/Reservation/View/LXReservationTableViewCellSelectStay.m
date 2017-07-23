//
//  LXReservationTableViewCellSelectStay.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXReservationTableViewCellSelectStay.h"

@implementation LXReservationTableViewCellSelectStay

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)selectBt:(BOOL)isSelect{
    if (isSelect) {
        [self.trailingL setTextColor:LXColorHex(0x4c4c4c)];
        [self.arrowB setBackgroundImage:[UIImage imageNamed:@"Home_reservation_selected"] forState:UIControlStateNormal];
    }
    else {
        [self.trailingL setTextColor:LXColorHex(0xB2B2B2)];
        [self.arrowB setBackgroundImage:[UIImage imageNamed:@"Home_reservation_noamal"] forState:UIControlStateNormal];
    }

}


@end
