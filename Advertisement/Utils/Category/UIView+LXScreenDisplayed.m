//
//  UIView+LXScreenDisplayed.m
//  Advertisement
//
//  Created by zuolixin on 2017/5/11.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "UIView+LXScreenDisplayed.h"

@implementation UIView (LXScreenDisplayed)

// 判断View是否显示在屏幕上
- (BOOL)lx_isDisplayedInScreen {
    if (!self) {
        return NO;
    }
    
    // [self.view convertRect:(CGRect) fromView:(nullable UIView *)];
    // [self.view convertRect:(CGRect) toView:(nullable UIView *)];
    // convertRect后面接的参数永远是:被操作的对象
    // fromView后面接的参数是:源,toView后面接的参数是:目标
    // view为nil的时候，系统会自动帮你转换为当前窗口的基本坐标系
    
    CGRect rect = [self convertRect:self.bounds toView:nil];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    if (self.hidden) {
        return NO;
    }
    
    if (self.alpha < 0.01) {
        return NO;
    }
    
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return NO;
    }
    
    CGRect intersecitonRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersecitonRect) || CGRectIsNull(intersecitonRect)) {
        return NO;
    }
    
    return YES;
}

@end
