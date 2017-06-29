//
//  LXServiceDetailViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/22.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXServiceDetailViewModel.h"

@implementation LXServiceDetailViewModel


- (NSNumber *)getServiceDetailWithParameters:(NSDictionary *)parametersDict
                           completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = HomeAPIServiceDetail;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

@end
