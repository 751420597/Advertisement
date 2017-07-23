//
//  OrderViewModel.h
//  Advertisement
//
//  Created by 翟凤禄 on 2017/6/30.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface OrderViewModel : HHAPIManager
//获取订单
- (NSNumber *)getOrderWithParameters:(NSDictionary *)dict
                   completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
//支付完成后
- (NSNumber *)upDataOrderWithParameters:(NSDictionary *)dict
                   completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
//评价订单
- (NSNumber *)speakOrderWithParameters:(NSDictionary *)dict
                      completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
//取消订单
- (NSNumber *)cancleOrderWithParameters:(NSDictionary *)dict
                     completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
//删除订单
- (NSNumber *)deleteOrderWithParameters:(NSDictionary *)dict
                      completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
@end
