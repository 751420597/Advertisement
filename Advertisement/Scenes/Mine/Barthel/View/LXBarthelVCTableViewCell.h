//
//  LXBarthelVCTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXBarthelModel.h"
#import "CareDetailBartherModel.h"
@interface LXBarthelVCTableViewCell : UITableViewCell

@property (nonatomic, strong) LXBarthelModel *barthelModel;
@property (nonatomic, strong) CareDetailBartherModel *careDetailBartherModel;
@property (weak, nonatomic) IBOutlet UILabel *leadingL;
@property (weak, nonatomic) IBOutlet UILabel *vuleLB;

@end
