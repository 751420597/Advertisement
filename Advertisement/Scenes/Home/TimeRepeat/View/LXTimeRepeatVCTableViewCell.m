//
//  LXTimeRepeatVCTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXTimeRepeatVCTableViewCell.h"

@implementation LXTimeRepeatVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.indexB setBackgroundImage:[UIImage imageNamed:@"Order_repeat_normal"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    }

@end
