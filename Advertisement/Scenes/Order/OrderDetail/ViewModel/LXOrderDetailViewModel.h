//
//  LXOrderDetailViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/22.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXOrderDetailViewModel : HHAPIManager

- (NSNumber *)getDetailWithParameters:(NSDictionary *)parametersDict
                    completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
