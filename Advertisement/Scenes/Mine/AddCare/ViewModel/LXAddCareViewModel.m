//
//  LXAddCareViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/24.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXAddCareViewModel.h"

@implementation LXAddCareViewModel

- (NSNumber *)addCareWithParameters:(NSDictionary *)parametersDict
                  completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = MineAPICareAddProject;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        
        completionHandler ? completionHandler(error, result) : nil;
    }];
}
- (NSNumber *)upDataCareWithParameters:(NSDictionary *)parametersDict
                  completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = upDataCareObj;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

@end
