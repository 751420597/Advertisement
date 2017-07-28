//
//  AppDelegate.m
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "AppDelegate.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "LXRootTabbarViewController.h"
#import "LXLogInViewController.h"
#import "LXRootNavViewController.h"

#import "LXTimeSelectViewController.h"
#import "LXCareViewController.h"
#import "LXOrganizationViewController.h"
#import "LXSelectOrganizationViewController.h"
#import "LXMineViewController.h"
#import "LXBarthelViewController.h"
#import "LXOrderViewController.h"
#import "LXReservationViewController.h"
#import "LXAddCareViewController.h"
#import "LXServiceProjectViewController.h"
#import "LXConfirmLevelViewController.h"
#import "LXLogInViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderViewModel.h"
@interface AppDelegate () <JPUSHRegisterDelegate>

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    sleep(2);
    
    NSString *userId=[LXStandardUserDefaults objectForKey:@"userId"];
    [AMapServices sharedServices].apiKey = AMapAPIKey;
    
    NSString *key = (NSString *)kCFBundleVersionKey;
    //新版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //老版本号
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults]valueForKey:@"firstLanch"];
    LXLogInViewController *login = [[LXLogInViewController alloc]init];
    
    if ([version isEqualToString:oldVersion]&&userId.length>0)
    {
        self.window.rootViewController = [LXRootTabbarViewController new];
    }
    else
    {
        self.window.rootViewController =[[LXRootNavViewController alloc] initWithRootViewController:login];
        [[NSUserDefaults standardUserDefaults]setValue:version forKey:@"firstLanch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 推送
    [self configureJPushWithOptions:launchOptions];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - Push

- (void)configureJPushWithOptions:(NSDictionary *)launchOptions {
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPushAppKey
                          channel:@"Test"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    [JPUSHService setDebugMode];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [LXStandardUserDefaults setObject:registrationID forKey:@"registrationID"];
            [LXStandardUserDefaults synchronize];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}
// 远程推送注册成功（将得到的deviceToken传给SDK）
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //极光推送
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    
    
}

// 远程推送注册失败（注册deviceToken失败）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

//iOS7及以上系统
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)
                                                 (UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    
    NSString *module = userInfo[@"push_key"];
    //NSDictionary *data = [module objectFromJSONString];
    //NSString *urlType = data[@"urlType"];
    NSString *title = userInfo[@"aps"][@"alert"];
    //是否登录-----在登录成功之后为YES
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
    
    
}
#pragma mark iOS10 前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
//    NSDictionary *userInfo = notification.request.content.userInfo;
//    NSString *module = userInfo[@"push_key"];
//    NSDictionary *data = [module objectFromJSONString];
//    NSString *urlType = data[@"urlType"];
    NSString *title = userInfo[@"aps"][@"alert"];
    //是否登录-----在登录成功之后为YES
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
}

#pragma mark iOS10 后台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
    //NSDictionary *userInfo = response.notification.request.content.userInfo;
//   NSString *module = userInfo[@"push_key"];
//    NSDictionary *data = [module objectFromJSONString];
//    NSString *urlType = data[@"urlType"];
    NSString *title = userInfo[@"aps"][@"alert"];
    //是否登录-----在登录成功之后为YES
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
    
}

//支付返回处理
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark - App Life

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 进入后台之后，将角标清零
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    // 即将进入前台：1.将角标清零；2.取消所有本地通知
    [application setApplicationIconBadgeNumber:1];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
