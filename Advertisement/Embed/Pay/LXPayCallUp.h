//
//  LXPayManager.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/26.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LXWeixinPayModel.h"
#import "LXZhiFuBaoPayModel.h"
#import "LXPayConstant.h"


@interface LXPayCallUp : NSObject

/**
 *  1.支付宝支付
 *
 *  @param zhiFuBaoModel 签名字符串
 *  @param successBlock  成功Block
 *  @param failureBlock  失败Block
 */
+ (void)gotoZhiFuBaoPayWithModel:(LXZhiFuBaoPayModel *)zhiFuBaoModel
                    successBlock:(void (^)(NSDictionary *))successBlock
                    failureBlock:(void (^)(NSDictionary *))failureBlock;

/**
 *  2.微信支付
 *
 *  @param weixinPayModel 服务端返回的Model
 *  @param successBlock   成功Block
 *  @param failureBlock   失败Block
 */
+ (void)gotoWeixinPayWithModel:(LXWeixinPayModel *)weixinPayModel
                  successBlock:(void (^)(NSDictionary *))successBlock
                  failureBlock:(void (^)(NSDictionary *))failureBlock;

@end
