//
//  LXOrganizationViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/7.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXOrganizationViewModel : HHAPIManager

@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 请求第一页

 @param completionHandler handle
 @return taskIdentifer
 */
- (NSNumber *)getOrganizationListWithParameters:(NSDictionary *)parametersDict
                              completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

/**
 加载更多

 @param completionHandler Hander
 @return taskIdentifer
 */
- (NSNumber *)loadmoreOrganizationListWithParameters:(NSDictionary *)parametersDict
                                   completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
