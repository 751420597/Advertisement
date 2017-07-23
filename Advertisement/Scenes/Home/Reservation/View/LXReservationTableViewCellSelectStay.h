//
//  LXReservationTableViewCellSelectStay.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXReservationTableViewCellSelectStay : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leadingL;
@property (weak, nonatomic) IBOutlet UIButton *arrowB;
@property (weak, nonatomic) IBOutlet UILabel *trailingL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingLConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowBtnTrailingConstraint;
-(void)selectBt:(BOOL)isSelect;
@end
