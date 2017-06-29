//
//  LXHomeTitleView.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/16.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXHomeTitleView : UIView

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithClickBlock:(dispatch_block_t)block;

@end
