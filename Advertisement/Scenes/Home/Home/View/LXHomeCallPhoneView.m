//
//  LXHomeCallPhoneView.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/9.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXHomeCallPhoneView.h"

@interface LXHomeCallPhoneView ()

@property (nonatomic, copy) dispatch_block_t cancelB;
@property (nonatomic, copy) dispatch_block_t confirmB;

@end


@implementation LXHomeCallPhoneView

- (instancetype)initWithCancelBlock:(dispatch_block_t)cancelBlock callUp:(dispatch_block_t)callUpBlock {
    if (self = [super init]) {
        self.cancelB = cancelBlock;
        self.confirmB = cancelBlock;
        
        [self setUpSubViews];
    }
    return self;
}


#pragma mark - Set Up

- (void)setUpSubViews {
    
}

@end
