//
//  LXLogInViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/13.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXLogInViewModel : HHAPIManager

- (NSNumber *)getVerifyCodeWithParameters:(NSDictionary *)parametersDict
                        completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

- (NSNumber *)verifyCodeWithParameters:(NSDictionary *)parametersDict
                     completionHandler:(HHNetworkTaskCompletionHander)completionHandler;


- (NSNumber *)logInWithWithParameters:(NSDictionary *)parametersDict
                    completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
