//
//  LXAddCareViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/24.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXAddCareViewModel : HHAPIManager

- (NSNumber *)addCareWithParameters:(NSDictionary *)parametersDict
                  completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
