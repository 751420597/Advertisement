//
//  LXHomeRemindView.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/6.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXHomeRemindView : UIView

- (instancetype)initWithRemindString:(NSString *)string didClosedBlock:(dispatch_block_t)block;

@end
