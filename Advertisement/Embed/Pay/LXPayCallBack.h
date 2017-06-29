//
//  LXPayCallBack.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/26.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LXPayCallBackDelegate <NSObject>

- (void)getAliPayDeletegateWithCode:(int)code;
- (void)getWeixinPayDelegateWithCode:(int)code;

@end


@interface LXPayCallBack : NSObject

@property (nonatomic, weak) id <LXPayCallBackDelegate> delegate;

- (BOOL)handleOpenURL:(NSURL *)url ;  // 处理支付宝和微信的的结果

@end


