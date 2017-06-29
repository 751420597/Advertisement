//
//  LXServiceRecordeViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXServiceRecordeViewModel : HHAPIManager

- (NSNumber *)getRecordeWithParameters:(NSDictionary *)parametersDict
                     completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
