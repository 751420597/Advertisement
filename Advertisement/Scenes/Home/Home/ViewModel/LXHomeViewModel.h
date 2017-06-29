//
//  LXHomeViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/5.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LXHomeViewModelSuccessBlock)(void);
typedef void (^LXHomeViewModelFailureBlock)(void);

@interface LXHomeViewModel : NSObject

// 数据数组，可以通过KVO更新View
@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)loadDataSourceWithDictionary:(NSDictionary *)parameters
                        successBlock:(LXHomeViewModelSuccessBlock)successBlock
                        failureBlock:(LXHomeViewModelFailureBlock)failureBlock;

@end
