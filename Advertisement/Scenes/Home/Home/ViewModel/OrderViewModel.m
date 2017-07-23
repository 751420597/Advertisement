//
//  OrderViewModel.m
//  Advertisement
//
//  Created by 翟凤禄 on 2017/6/30.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "OrderViewModel.h"
#import "HHNetworkAPIRecorder.h"
@implementation OrderViewModel
- (NSNumber *)getOrderWithParameters:(NSDictionary *)dict
                                completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = AlipayApi;
    config.requestParameters = dict;
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
- (NSNumber *)upDataOrderWithParameters:(NSDictionary *)dict
                      completionHandler:(HHNetworkTaskCompletionHander)completionHandler{
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = upDataOrder;
    config.requestParameters = dict;
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
- (NSNumber *)speakOrderWithParameters:(NSDictionary *)dict
                     completionHandler:(HHNetworkTaskCompletionHander)completionHandler{
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = speakOrder;
    config.requestParameters = dict;
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
- (NSNumber *)cancleOrderWithParameters:(NSDictionary *)dict
                      completionHandler:(HHNetworkTaskCompletionHander)completionHandler{
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = cancleOrder;
    config.requestParameters = dict;
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
- (NSNumber *)deleteOrderWithParameters:(NSDictionary *)dict
                      completionHandler:(HHNetworkTaskCompletionHander)completionHandler{
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = deleteOrder;
    config.requestParameters = dict;
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
