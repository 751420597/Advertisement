//
//  LXOrganizationViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/7.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrganizationViewModel.h"

#import "HHNetworkAPIRecorder.h"

@interface LXOrganizationViewModel ()

@property (nonatomic, strong) HHNetworkAPIRecorder *apiRecorder;

@end

@implementation LXOrganizationViewModel

- (NSNumber *)getOrganizationListWithParameters:(NSDictionary *)parametersDict
                              completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    return [self fetchOrganizaitonListWithParameters:parametersDict completionHandler:completionHandler];
}

/**
 加载更多
 
 @param completionHandler Hander
 @return taskIdentifer
 */
- (NSNumber *)loadmoreOrganizationListWithParameters:(NSDictionary *)parametersDict
                                   completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    self.apiRecorder.currentPage++;
    
    return [self fetchOrganizaitonListWithParameters:parametersDict completionHandler:completionHandler];
}


#pragma mark - Public

- (NSNumber *)fetchOrganizaitonListWithParameters:(NSDictionary *)dict
                                 completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = OrganizationAPIList;
    config.requestParameters = @{ @"page" : @(self.apiRecorder.currentPage),
                                  @"pageSize" : @(self.apiRecorder.pageSize) };
    
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


#pragma mark - Getter 

- (HHNetworkAPIRecorder *)apiRecorder {
    if (!_apiRecorder) {
        _apiRecorder = [[HHNetworkAPIRecorder alloc] init];
        _apiRecorder.pageSize = 10;
    }
    return _apiRecorder;
}

@end
