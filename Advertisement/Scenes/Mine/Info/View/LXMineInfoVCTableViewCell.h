//
//  LXMineInfoVCTableViewCellID.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXMineInfoVCTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leadingL;
//@property (weak, nonatomic) IBOutlet UILabel *trailingL;
@property (weak, nonatomic) IBOutlet UIButton *arrowB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConstrait;
@property (weak, nonatomic) IBOutlet UITextField *trailingL;

@end
