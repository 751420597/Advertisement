//
//  LXLogInViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/13.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXLogInViewModel.h"

@implementation LXLogInViewModel

- (NSNumber *)getVerifyCodeWithParameters:(NSDictionary *)parametersDict
                        completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = LoginAPIGetVerify;
    config.requestParameters = parametersDict;
    config.useHttps = NO;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
            
        }
        else {
            
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

- (NSNumber *)verifyCodeWithParameters:(NSDictionary *)parametersDict
                     completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = LoginAPICheckVerify;
    config.requestParameters = parametersDict;
    config.useHttps = NO;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
            
        }
        else {
            
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

- (NSNumber *)logInWithWithParameters:(NSDictionary *)parametersDict
                    completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = LoginAPILogIn;
    config.requestParameters = parametersDict;
    config.useHttps = NO;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
            
        }
        else {
            
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];
}
- (NSNumber *)logOutWithWithParameters:(NSDictionary *)parametersDict
                     completionHandler:(HHNetworkTaskCompletionHander)completionHandler{
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = LoginAPILogOut;
    config.requestParameters = parametersDict;
    config.useHttps = NO;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
            
        }
        else {
            
        }
        completionHandler ? completionHandler(error, result) : nil;
    }];

}
@end
