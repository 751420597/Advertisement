//
//  LXServiceProjectVCTableCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXServiceProjectModel.h"
#import "LXOrderDetailSeriviceModel.h"

@interface LXServiceProjectVCTableCell : UITableViewCell

@property (nonatomic, strong) LXServiceProjectModel *serviceProjectModel;
@property (nonatomic, strong) LXOrderDetailSeriviceModel *orderDetailSeriviceModel;
@property (nonatomic, copy) dispatch_block_t cellSelectBlock;


@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UILabel *leadingL;
@property (weak, nonatomic) IBOutlet UILabel *middleL;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

- (IBAction)selectBtnClick:(id)sender;


@end
