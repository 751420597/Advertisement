//
//  LXCareDetailViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/24.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXCareDetailViewModel : HHAPIManager

- (NSNumber *)getCareDetailWithParameters:(NSDictionary *)parametersDict
                  completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
