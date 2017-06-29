//
//  LXMessageViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/23.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXMessageViewModel : HHAPIManager

- (NSNumber *)getMessageListWithParameters:(NSDictionary *)parametersDict
                        completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
