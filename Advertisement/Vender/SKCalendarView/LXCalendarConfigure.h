//
//  LXCalendarConfigure.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/14.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXCalendarConfigure : NSObject

@property (nonatomic, strong) UIColor *weekViewInWeekTitleColor;
@property (nonatomic, strong) UIColor *weekViewOffWeekTitleColor;
@property (nonatomic, assign) CGFloat weekViewHeight;

@property (nonatomic, strong) UIColor *sepratorLineColor;

@property (nonatomic, assign) BOOL hideChineseDay;
@property (nonatomic, assign) BOOL hideVerticalLine;
@property (nonatomic, assign) CGFloat itemLXHeight;
@property (nonatomic, strong) UIColor *itemSeperatorLineColor;

@end
