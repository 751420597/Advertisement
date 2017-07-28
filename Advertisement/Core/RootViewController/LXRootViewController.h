//
//  LXRootViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXRootViewController : UIViewController

@property (nonatomic, copy) dispatch_block_t noNetBlock;
@property (nonatomic, assign) BOOL hideNoNetView;
-(void)popToUpperViewController;
@end
