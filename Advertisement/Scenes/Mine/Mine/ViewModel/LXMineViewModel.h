//
//  LXMineViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/20.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXMineViewModel : HHAPIManager

- (NSNumber *)getMineWithParameters:(NSDictionary *)parametersDict
                  completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
