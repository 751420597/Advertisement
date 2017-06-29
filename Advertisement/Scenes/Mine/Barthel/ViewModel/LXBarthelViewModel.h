//
//  LXBarthelViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/20.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXBarthelViewModel : HHAPIManager

- (NSNumber *)getBarthelListWithParameters:(NSDictionary *)parametersDict
                         completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

- (NSNumber *)getBarthelLevelWithParameters:(NSDictionary *)parametersDict
                         completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
