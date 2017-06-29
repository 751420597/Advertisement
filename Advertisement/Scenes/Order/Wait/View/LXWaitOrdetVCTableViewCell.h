//
//  LXWaitOrdetVCTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/7.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXOrderListModel.h"

@interface LXWaitOrdetVCTableViewCell : UITableViewCell

@property (nonatomic, strong) LXOrderListModel *orderListModel;

@property (weak, nonatomic) IBOutlet UIView *customeView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *waitOrder;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *orderSum;

@end
