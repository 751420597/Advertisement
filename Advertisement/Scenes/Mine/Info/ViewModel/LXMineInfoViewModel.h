//
//  LXMineInfoViewModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/20.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXMineInfoViewModel : HHAPIManager

- (NSNumber *)updateMineInfoWithParameters:(NSDictionary *)parametersDict
                         completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

- (NSNumber *)uploadImageWithParameters:(NSDictionary *)parametersDict
                              imageData:(NSData *)imageData
                      completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
    

@end
