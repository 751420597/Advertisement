//
//  LXPayCallBack.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/26.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXPayCallBack.h"

@implementation LXPayCallBack

- (BOOL)handleOpenURL:(NSURL *)url {
    if (url != nil && [url host] != nil && [[url host] compare:@"safepay"] == 0)  {
        // 支付宝支付
        // return [self checkUrl:url];
    }
    else if (url != nil &&  [url host] != nil && [[url host] compare:@"pay"] == 0) {
        // 微信支付
        // return  [WXApi handleOpenURL:url delegate:self];
    }
    
    return NO ;
}

// 支付宝处理
- (void)checkUrl:(NSURL *)url {
    __block __weak typeof(self) weakSelf = self;
    
    // 对resultStatus结果进行处理
//    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getAliPayDeletegateWithCode:)]) {
//            [weakSelf.delegate getAliPayDeletegateWithCode:[[resultDic objectForKey:@"resultStatus" ] intValue]];
//        }
//    }];
    
}

// 微信支付处理
//- (BOOL)onResp:(BaseResp *)resp {
//    // 对resultStatus结果进行处理
//    if ([resp isKindOfClass:[PayResp class]]) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(getWeixinPayDelegateWithCode:)]) {
//            [self.delegate getWeixinPayDelegateWithCode:resp.errCode];
//        }
//    }
//}

@end
