//
//  LXDebugHeader.h
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#ifndef LXDebugHeader_h
#define LXDebugHeader_h

// 日志级别
#define LXDEBUG
#define LXLOGLEVEL_INFO    10
#define LXLOGLEVEL_WARNING  3
#define LXLOGLEVEL_ERROR    1

#ifndef LXMAXLOGLEVEL
#ifdef DEBUG
#define LXMAXLOGLEVEL LXLOGLEVEL_INFO
#else
#define LXMAXLOGLEVEL LXLOGLEVEL_ERROR
#endif
#endif


// 自定义Log
#ifdef DEBUG
#define LXLog(format, ...) NSLog(@"%s--line--:%d " format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define LXLog(format, ...)
#endif


#endif /* LXDebugHeader_h */
