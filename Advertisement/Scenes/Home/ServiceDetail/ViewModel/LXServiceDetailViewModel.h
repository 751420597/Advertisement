//
//  LXServiceDetailViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/22.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXServiceDetailViewModel : HHAPIManager

- (NSNumber *)getServiceDetailWithParameters:(NSDictionary *)parametersDict
                           completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
