//
//  LXServiceProjectViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXServiceProjectViewModel : HHAPIManager

- (NSNumber *)getServiceListWithParameters:(NSDictionary *)parametersDict
                         completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
