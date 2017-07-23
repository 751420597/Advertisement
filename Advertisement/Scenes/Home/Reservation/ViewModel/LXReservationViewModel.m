//
//  LXReservationViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXReservationViewModel.h"

@implementation LXReservationViewModel

- (NSNumber *)setUpReservationWithParameters:(NSDictionary *)parametersDict
                           completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = HomeAPIReservation;
    config.requestParameters = parametersDict;
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}
- (NSNumber *)getAddressReservationWithParameters:(NSDictionary *)parametersDict
                                completionHandler:(HHNetworkTaskCompletionHander)completionHandler{
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = HomeAPIGetAddress;
    config.requestParameters = parametersDict;
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}
@end
