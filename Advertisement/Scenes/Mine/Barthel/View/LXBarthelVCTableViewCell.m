//
//  LXBarthelVCTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXBarthelVCTableViewCell.h"

@implementation LXBarthelVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBarthelModel:(LXBarthelModel *)barthelModel {
    _barthelModel = barthelModel;
    
    [self.leadingL setText:barthelModel.evaItem];
}

@end
