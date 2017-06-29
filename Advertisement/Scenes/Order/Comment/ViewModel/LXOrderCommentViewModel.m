//
//  LXOrderCommentViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrderCommentViewModel.h"

@implementation LXOrderCommentViewModel

- (NSNumber *)updateCommentWithParameters:(NSDictionary *)parametersDict
                        completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = OrderAPIComment;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

@end
