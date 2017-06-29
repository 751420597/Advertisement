//
//  LXCareDetailVCTableViewCell.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/24.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXCareDetailVCTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trailingL;
@property (weak, nonatomic) IBOutlet UILabel *leadingL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingBConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingBConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingLConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingLConstraint;

@end
