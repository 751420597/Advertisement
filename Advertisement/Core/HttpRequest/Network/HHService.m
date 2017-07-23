//
//  HHService.m
//  HeiHuaBaiHua
//
//  Created by HeiHuaBaiHua on 16/6/2.
//  Copyright © 2016年 HeiHuaBaiHua. All rights reserved.
//

#import "HHService.h"


@interface HHServiceX : HHService
@end

@interface HHServiceY : HHService
@end

@interface HHServiceZ : HHService
@end


#pragma mark - HHServiceX

@implementation HHServiceX

- (NSString *)testEnvironmentBaseUrl {
    return @"http://112.74.38.196:8081/ihealthcare";
}

- (NSString *)developEnvironmentBaseUrl {
    return @"http://112.74.38.196:8081/ihealthcare";//http://112.74.38.196:8081/ihealthcare
}

- (NSString *)releaseEnvironmentBaseUrl {
    return @"http://112.74.38.196:8081/ihealthcare";
}

@end

#pragma mark - HHServiceY

@implementation HHServiceY

- (NSString *)testEnvironmentBaseUrl {
    return @"testEnvironmentBaseUrl_Y";
}

- (NSString *)developEnvironmentBaseUrl {
    return @"developEnvironmentBaseUrl_Y";
}

- (NSString *)releaseEnvironmentBaseUrl {
    return @"releaseEnvironmentBaseUrl_Y";
}

@end

#pragma mark - HHServiceZ

@implementation HHServiceZ

- (NSString *)testEnvironmentBaseUrl {
    return @"testEnvironmentBaseUrl_Z";
}

- (NSString *)developEnvironmentBaseUrl {
    return @"developEnvironmentBaseUrl_Z";
}

- (NSString *)releaseEnvironmentBaseUrl {
    return @"releaseEnvironmentBaseUrl_Z";
}

@end


@interface HHService ()

@property (assign, nonatomic) HHServiceType type;
@property (assign, nonatomic) HHServiceEnvironment environment;

@end


@implementation HHService

#pragma mark - Interface

static HHService *currentService;
static dispatch_semaphore_t lock;

+ (HHService *)currentService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lock = dispatch_semaphore_create(1);
        currentService = [HHService serviceWithType:HHService0];
    });
    
    return currentService;
}

+ (void)switchService {
    [self switchToService:self.currentService.type + 1];
}

+ (void)switchToService:(HHServiceType)serviceType {
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    currentService = [HHService serviceWithType:(serviceType % ServiceCount)];
    dispatch_semaphore_signal(lock);
}

+ (HHService *)serviceWithType:(HHServiceType)type {
    HHService *service;
    switch (type) {
        case HHService0: service = [HHServiceX new];  break;
        case HHService1: service = [HHServiceY new];  break;
        case HHService2: service = [HHServiceZ new];  break;
    }
    
    service.type = type;
    service.environment = BulidServiceEnvironment;
    
    return service;
}

- (NSString *)baseUrl {
    switch (self.environment) {
        case HHServiceEnvironmentTest: return [self testEnvironmentBaseUrl];
        case HHServiceEnvironmentDevelop: return [self developEnvironmentBaseUrl];
        case HHServiceEnvironmentRelease: return [self releaseEnvironmentBaseUrl];
    }
}

@end
