//
//  HHNetworkConfig.h
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/11.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#ifndef HHNetworkConfig_h
#define HHNetworkConfig_h

#import <UIKit/UIKit.h>

#define ServiceCount 1
#define HHSwitchServiceNotification @"HHSwitchServiceNotification"
#define BulidServiceEnvironment HHServiceEnvironmentRelease
#define RequestTimeoutInterval 8

// 不同的服务器
typedef enum : NSUInteger {
    HHService0,
    HHService1,
    HHService2
} HHServiceType;

// 不同的开发环境
typedef enum : NSUInteger {
    HHServiceEnvironmentTest,
    HHServiceEnvironmentDevelop,
    HHServiceEnvironmentRelease
} HHServiceEnvironment;

// 不同的请求
typedef enum : NSUInteger {
    HHNetworkRequestTypeGet,
    HHNetworkRequestTypePost
} HHNetworkRequestType;

#endif
