//
//  LXConfirmViewTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXServiceProjectModel.h"

@interface LXConfirmViewTableViewCell : UITableViewCell

@property (nonatomic, strong) LXServiceProjectModel *serviceModel;

@property (weak, nonatomic) IBOutlet UIButton *dotBtn;
@property (weak, nonatomic) IBOutlet UILabel *leadingL;
@property (weak, nonatomic) IBOutlet UILabel *middleL;
@property (weak, nonatomic) IBOutlet UILabel *trailingL;

@end
