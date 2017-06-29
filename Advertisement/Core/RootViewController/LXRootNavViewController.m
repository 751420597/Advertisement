//
//  LXRootNavViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootNavViewController.h"

@interface LXRootNavViewController ()

@end

@implementation LXRootNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - Status Bar 

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
