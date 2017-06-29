//
//  LXBarthelVCTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXBarthelModel.h"

@interface LXBarthelVCTableViewCell : UITableViewCell

@property (nonatomic, strong) LXBarthelModel *barthelModel;

@property (weak, nonatomic) IBOutlet UILabel *leadingL;

@end
