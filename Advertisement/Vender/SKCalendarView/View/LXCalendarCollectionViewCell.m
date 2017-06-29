//
//  LXCalendarCollectionViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/14.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXCalendarCollectionViewCell.h"

@implementation LXCalendarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected {
    if (self.selected) {
        [self.dateLabel setTextColor:LXMainColor];
    }
}

@end
