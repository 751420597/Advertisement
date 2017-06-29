//
//  LXOderDealView.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/14.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXOderDealView : UIView

@property (nonatomic, copy) NSString *leadingString;
@property (nonatomic, copy) NSString *trailingString;

- (instancetype)initWithTrailingClick:(dispatch_block_t)block;

@end
