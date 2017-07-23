//
//  MapApiViewModel.h
//  Advertisement
//
//  Created by 翟凤禄 on 2017/6/30.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface MapApiViewModel : HHAPIManager
- (NSNumber*)loadMapSourceWithDictionaryfetchOrganizaitonListWithParameters:(NSDictionary *)dict completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
@end
