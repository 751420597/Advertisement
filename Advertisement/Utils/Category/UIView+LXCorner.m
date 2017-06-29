//
//  UIView+LXCorner.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/8.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "UIView+LXCorner.h"

@implementation UIView (LXCorner)

- (void)lx_setViewCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)color borderWidth:(CGFloat)width {
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

@end
