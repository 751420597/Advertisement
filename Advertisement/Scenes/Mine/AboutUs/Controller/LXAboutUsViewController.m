//
//  LXAboutUsViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/19.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXAboutUsViewController.h"

@interface LXAboutUsViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation LXAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = LXVCBackgroundColor;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"aboutUS"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, LXScreenWidth, LXScreenHeight-LXNavigaitonBarHeight)];
     _webView.scalesPageToFit = YES;
    //隐藏拖拽UIWebView时上下的两个阴影效果
    UIScrollView *scrollView = [_webView.subviews objectAtIndex:0];
    if (scrollView)
    {
        for (UIView *view in [scrollView subviews])
        {
            if ([view isKindOfClass:[UIImageView class]])
            {
                view.hidden = YES;
            }
        }
    }
    
    _webView.delegate = self;
    
    //禁用UIWebView拖拽时的反弹效果
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:YES];
    
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview: self.webView];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
}




@end
