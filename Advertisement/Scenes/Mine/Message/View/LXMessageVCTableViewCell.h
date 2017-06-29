//
//  LXMessageVCTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/8.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXMessageModel.h"

@interface LXMessageVCTableViewCell : UITableViewCell

@property (nonatomic, strong) LXMessageModel *messageModel;

@property (weak, nonatomic) IBOutlet UIView *customeView;
@property (weak, nonatomic) IBOutlet UILabel *leadingL;
@property (weak, nonatomic) IBOutlet UILabel *bottomL;
@property (weak, nonatomic) IBOutlet UIButton *redButton;

@end
