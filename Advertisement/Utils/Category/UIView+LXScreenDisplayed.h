//
//  UIView+LXScreenDisplayed.h
//  Advertisement
//
//  Created by zuolixin on 2017/5/11.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LXScreenDisplayed)

// 判断View是否显示在屏幕上，注意：此View的frame必须是相对Window
- (BOOL)lx_isDisplayedInScreen;

@end
