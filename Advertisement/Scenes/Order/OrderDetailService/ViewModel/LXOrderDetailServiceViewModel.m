//
//  LXOrderDetailServiceViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/22.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrderDetailServiceViewModel.h"

@implementation LXOrderDetailServiceViewModel

- (NSNumber *)getServiceList1WithParameters:(NSDictionary *)parametersDict
                         completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = OrderAPIServiceProject;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

@end
