//
//  LXUserProtocolViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/19.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXUserProtocolViewController.h"

@interface LXUserProtocolViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation LXUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"用户协议";
    self.view.backgroundColor = LXVCBackgroundColor;
}



@end
