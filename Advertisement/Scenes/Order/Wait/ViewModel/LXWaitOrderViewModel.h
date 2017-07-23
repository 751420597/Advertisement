//
//  LXWaitOrderViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXWaitOrderViewModel : HHAPIManager

// 订单状态—0:待接单 1:已接单 2:已完成 3:已取消
- (NSNumber *)getOrderListWithParameters:(NSDictionary *)parametersDict
                  completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
- (NSNumber *)tousuWithParameters:(NSDictionary *)parametersDict
                completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
@end
