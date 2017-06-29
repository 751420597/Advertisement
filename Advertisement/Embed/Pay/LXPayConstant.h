//
//  LXPayConstant.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/26.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#ifndef LXPayConstant_h
#define LXPayConstant_h

typedef NS_ENUM(NSInteger, PayErrorType) {
    PayErrorTypeFailure = 1,  // 失败
    PayErrorTypeUnknown,      // 支付状态未知
    PayErrorTypeRepayment,    // 第三方支付成功，但是余额不足，需要还款
    PayErrorTypeDoublePayment,// 订单已支付过，重复支付
    PayErrorTypeBanlace,      // 纯余额支付余额不足
    PayErrorTypeCancelPay,    // 明确的取消支付操作
    PayErrorTypeNoInstallWX   // 未安装微信时选择微信支付
};

#endif /* LXPayConstant_h */
