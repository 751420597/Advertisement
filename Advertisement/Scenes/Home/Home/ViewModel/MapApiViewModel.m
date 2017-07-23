//
//  MapApiViewModel.m
//  Advertisement
//
//  Created by 翟凤禄 on 2017/6/30.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "MapApiViewModel.h"
#import "HHNetworkAPIRecorder.h"
@implementation MapApiViewModel

- (NSNumber*)loadMapSourceWithDictionaryfetchOrganizaitonListWithParameters:(NSDictionary *)dict completionHandler:(HHNetworkTaskCompletionHander)completionHandler{
    
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = MapApiGetWorker;
    config.requestParameters = dict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        
        completionHandler ? completionHandler(error, result) : nil;
    }];
    
    
    
}

@end
