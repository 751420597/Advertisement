//
//  LXStaffViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/20.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXStaffViewModel.h"

@implementation LXStaffViewModel

- (NSNumber *)getStaffListWithParameters:(NSDictionary *)parametersDict
                              completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = OrganizationAPIStaffs;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
            //            if ([result[@"code"] count] == 0) {
            //                if (self.apiRecorder.currentPage == 1) {
            //                    error = HHError(HHNoDataErrorNotice, HHNetworkTaskErrorNoData);
            //                }
            //                else {
            //                    error = HHError(HHNoMoreDataErrorNotice, HHNetworkTaskErrorNoMoreData);
            //                }
            //            }
            //            else {
            //                // 解析Json
            //            }
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

@end
