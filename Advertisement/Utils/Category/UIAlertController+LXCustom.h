//
//  UIAlertController+LXCustom.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/9.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (LXCustom)

- (void)lx_setTitleWithAttributes:(NSMutableDictionary *)attributeDictionary;
- (void)lx_setMessageWithAttributes:(NSMutableDictionary *)attributeDictionary;
- (void)lx_setActionTitleWithChangeString:(NSString *)string color:(UIColor *)color;

@end
