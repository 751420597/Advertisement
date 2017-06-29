//
//  LXConfirmOrderView.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/10.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXConfirmOrderView : UIView

@property (nonatomic, copy) NSString *totalSum;
@property (nonatomic, copy) NSArray *dataSource;

- (instancetype)initWithDetailBlock:(dispatch_block_t)dBlock confirmBlock:(dispatch_block_t)cBlock;

@end
