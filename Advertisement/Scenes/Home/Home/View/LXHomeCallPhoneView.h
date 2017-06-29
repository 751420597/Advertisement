//
//  LXHomeCallPhoneView.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/9.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXHomeCallPhoneView : UIView

- (instancetype)initWithCancelBlock:(dispatch_block_t)cancelBlock callUp:(dispatch_block_t)callUpBlock;

@end
