//
//  LXMineInfoViewModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/20.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXMineInfoViewModel.h"

@implementation LXMineInfoViewModel

- (NSNumber *)updateMineInfoWithParameters:(NSDictionary *)parametersDict
                         completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHDataAPIConfiguration *config = [HHDataAPIConfiguration new];
    config.requestType = HHNetworkRequestTypePost;
    config.urlPath = MineAPIMineUpdate;
    config.requestParameters = parametersDict;
    
    return [super dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        if (!error) {
        }
        
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

- (NSNumber *)uploadImageWithParameters:(NSDictionary *)parametersDict
                              imageData:(NSData *)imageData
                      completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    HHUploadAPIConfiguration *uploadConfigure = [HHUploadAPIConfiguration new];
    uploadConfigure.requestType = HHNetworkRequestTypePost;
    uploadConfigure.urlPath = MineAPIUploadImage;
    uploadConfigure.requestParameters = parametersDict;
    uploadConfigure.uploadContents = @[[HHUploadFile pngImageWithFileData:imageData imageName:[NSUUID UUID].UUIDString]];
    
    return [super dispatchUploadTaskWithConfiguration:uploadConfigure progressHandler:^(CGFloat progress) {
        
    } completionHandler:^(NSError *error, id result) {
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

@end
