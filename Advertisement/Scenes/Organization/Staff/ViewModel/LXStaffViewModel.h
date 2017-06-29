//
//  LXStaffViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/20.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXStaffViewModel : HHAPIManager

/**
 请求第一页
 
 @param completionHandler handle
 @return taskIdentifer
 */
- (NSNumber *)getStaffListWithParameters:(NSDictionary *)parametersDict
                              completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
