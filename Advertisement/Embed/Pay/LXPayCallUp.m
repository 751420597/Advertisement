//
//  LXPayManager.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/26.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXPayCallUp.h"

@implementation LXPayCallUp

// errorMessage
// payCode

// 支付宝支付
+ (void)gotoZhiFuBaoPayWithModel:(LXZhiFuBaoPayModel *)zhiFuBaoModel
                    successBlock:(void (^)(NSDictionary *))successBlock
                    failureBlock:(void (^)(NSDictionary *))failureBlock; {
    if (!zhiFuBaoModel.signedString) {
        NSMutableDictionary*errorDic = [NSMutableDictionary dictionary];
        
        [errorDic setObject:@"获取支付宝调用URL失败" forKey:@"errorMessage"];
        [errorDic setObject:[NSString stringWithFormat:@"%zd",PayErrorTypeFailure] forKey:@"payCode"];
        
        failureBlock(errorDic);
        
        return;
    }
    
    if (zhiFuBaoModel.signedString != nil) {
        // 发起支付宝调用
//        [[AlipaySDK defaultService] payOrder:signedString fromScheme:AppScheme callback:^(NSDictionary *resultDic) {
//            
//        }];
    }
    else {
        
    }
}

// 微信支付
+ (void)gotoWeixinPayWithModel:(LXWeixinPayModel *)weixinPayModel
                  successBlock:(void (^)(NSDictionary *))successBlock
                  failureBlock:(void (^)(NSDictionary *))failureBlock {
    // 判断微信APP有没有安装
//    if ([WXApi isWXAppInstalled] == NO){
//        NSMutableDictionary*errorDic = [NSMutableDictionary dictionary];
//        
//        [errorDic setObject:@"您未安装微信" forKey:@"errorMessage"];
//        [errorDic setObject:[NSString stringWithFormat:@"%zd",PayErrorTypeNoInstallWX] forKey:@"payCode"];
//        
//        failureBlock(errorDic);
//        
//        return;
//    }
    
    // 判断WeixinOrderModel信息符不符合要求
//    if ((weixinPayModel == nil) || (weixinPayModel.prepayid == nil) ||(weixinPayModel.partnerid == nil) ){
//        
//        NSMutableDictionary*errorDic = [NSMutableDictionary dictionary];
//        
//        [errorDic setObject:@"订单信息不正确!" forKey:@"errorMessage"];
//        [errorDic setObject:[NSString stringWithFormat:@"%zd",PayErrorTypeNoInstallWX] forKey:@"payCode"];
//        
//        failureBlock(errorDic);
//        
//        return;
//    }
    
    // 设置PayRequest
//    PayReq *request   = [[PayReq alloc] init];
//    
//    request.sign = weixinPayModel.sign;
//    request.nonceStr = weixinPayModel.noncestr;
//    request.partnerId = weixinPayModel.partnerid;
//    request.timeStamp = (UInt32)[weixinPayModel.timestamp longLongValue];
//    request.prepayId = weixinPayModel.prepayid;
//    request.package = @"Sign=WXPay";
    
//    [WXApi sendReq:request];
}

@end
