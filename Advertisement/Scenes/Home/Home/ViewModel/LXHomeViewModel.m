//
//  LXHomeViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/5.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXHomeViewModel.h"

@implementation LXHomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.dataSource = [NSMutableArray new];
    }
    return self;
}

- (void)loadDataSourceWithDictionary:(NSDictionary *)parameters
                        successBlock:(LXHomeViewModelSuccessBlock)successBlock
                        failureBlock:(LXHomeViewModelFailureBlock)failureBlock {
    
}

@end
