//
//  LXCareDetailViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/24.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXCareDetailViewModel.h"

@implementation LXCareDetailViewModel

- (NSNumber *)getCareDetailWithParameters:(NSDictionary *)parametersDict
                        completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = MineAPICareDetail;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

@end
