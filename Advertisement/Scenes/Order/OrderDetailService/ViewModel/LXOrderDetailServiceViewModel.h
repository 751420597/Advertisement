//
//  LXOrderDetailServiceViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/22.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXOrderDetailServiceViewModel : HHAPIManager

- (NSNumber *)getServiceList1WithParameters:(NSDictionary *)parametersDict
                         completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
