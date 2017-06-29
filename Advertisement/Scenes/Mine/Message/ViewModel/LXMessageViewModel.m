//
//  LXMessageViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/23.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXMessageViewModel.h"

@implementation LXMessageViewModel

- (NSNumber *)getMessageListWithParameters:(NSDictionary *)parametersDict
                         completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = MessageList;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

@end
