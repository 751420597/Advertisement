//
//  LXWaitOrderViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXWaitOrderViewModel.h"

@implementation LXWaitOrderViewModel

- (NSNumber *)getOrderListWithParameters:(NSDictionary *)parametersDict
                           completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = OrderAPIList;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

- (NSNumber *)tousuWithParameters:(NSDictionary *)parametersDict
                       completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = feedback;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        
        completionHandler ? completionHandler(error, result) : nil;
    }];
}


//- (NSNumber *)getOrderServiceWithParameters:(NSDictionary *)parametersDict
//                          completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
//    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
//    config.requestType = HHNetworkRequestTypePost;
//    config.urlPath = OrderAPIService;
//    config.requestParameters = parametersDict;
//    
//    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
//        if (!error) {
//        }
//        
//        completionHandler ? completionHandler(error, result) : nil;
//    }];
//}

@end
