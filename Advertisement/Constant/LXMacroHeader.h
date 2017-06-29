//
//  LXMacroHeader.h
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#ifndef LXMacroHeader_h
#define LXMacroHeader_h

// 根据屏幕的宽度适时调整
#define LXRate(value) ((value) * LXScreenWidth / 375)

// 弱引用/强引用,可配对引用在外面用LXWeakSelf(self)，block用LXStrongSelf(self),也可以单独引用在外面用LXWeakSelf(self) block里面用weakself
#define LXWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LXStrongSelf(type) __strong typeof(type) type = weak##type;

// 获取屏幕宽度与高度
#define LXScreenWidth \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)

#define LXScreenHeight \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)

#define LXScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)

// NavigationBar\Tabbar
#define LXTabbarBarHeight     (49.0)
#define LXNavigaitonBarHeight (64.0)
#define LXStatusBarHeight     (20.0)

// 常用的缩写
#define LXApplication        [UIApplication sharedApplication]
#define LXKeyWindow          [UIApplication sharedApplication].keyWindow
#define LXAppDelegate        [UIApplication sharedApplication].delegate\

// 角度<->弧度
#define LXDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define LXRadianToDegrees(radian) (radian * 180.0) / (M_PI)

// 系统版本
#define LXCurrentSystemVersionFloat ［[UIDevice currentDevice] systemVersion] floatValue]
#define LXCurrentSystemVersion      ［UIDevice currentDevice] systemVersion]

#endif /* LXMacroHeader_h */
