//
//  LXTimeRepeatVCTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXTimeRepeatVCTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *indexB;
@property (weak, nonatomic) IBOutlet UILabel *repeatL;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end
