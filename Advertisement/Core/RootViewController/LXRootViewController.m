//
//  LXRootViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootViewController.h"

@interface LXRootViewController ()

@property (nonatomic, strong) UIView *noNetView;

@end


@implementation LXRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.automaticallyAdjustsScrollViewInsets = YES，ScrollView及其子类scrollIndicatorInsets变成UIEdgeInsetsMake(64, 0, 0, 0)，也就是说可滚动范围向下移动了64
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 在iOS 7中，苹果引入了一个新的属性，叫做[UIViewController setEdgesForExtendedLayout:]，它的默认值为UIRectEdgeAll。当你的容器是navigation controller时，默认的布局将从navigation bar的顶部开始。这就是为什么所有的UI元素都往上漂移了44pt
    
    // extendedLayoutIncludesOpaqueBars，当translucent设置为NO是：1.YES，此时计算frame又是从屏幕最上方作为0开始计算了，2.NO,此时计算frame又是从距离屏幕最上方64（navigationBar下方）开始计算了
    
    // 设置NavigationBar的背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:LXMainColor] forBarMetrics:UIBarMetricsDefault];
    
    // 设置NavigationBar的Title的颜色
    NSMutableDictionary *attibutes = [NSMutableDictionary new];
    attibutes[NSForegroundColorAttributeName] = LXNavigaitonBarTitleColor;
    attibutes[NSFontAttributeName] = [UIFont systemFontOfSize:LXRate(16)];
    [self.navigationController.navigationBar setTitleTextAttributes:attibutes];
    
    // 设置默认返回按钮
    [self configureBackBarButtonItem];
    
    // 设置没网的背景图片
    self.hideNoNetView = YES;
    [self configureBackGroundNoNet];
    
}


#pragma mark - Configure

- (void)configureBackBarButtonItem {
    self.navigationItem.backBarButtonItem  = nil;
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(popToUpperViewController) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"Home_back"] forState:UIControlStateNormal];
    
    UIBarButtonItem *fixedBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedBarButtonItem.width = -10;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    if (self.navigationController.viewControllers[0] != self) {
        self.navigationItem.leftBarButtonItems = @[fixedBarButtonItem, backBarButtonItem];
    }
}

- (void)popToUpperViewController {
    NSArray *viewControllers = [self.navigationController viewControllers];
    if (1 < viewControllers.count && self == [viewControllers lastObject]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configureBackGroundNoNet {
    self.noNetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 150)];
    [self.noNetView setBackgroundColor:LXVCBackgroundColor];
    
    NSInteger tempCenerY = 0;
    tempCenerY = (LXScreenHeight - LXNavigaitonBarHeight - LXTabbarBarHeight) / 2;
    
    [self.noNetView setCenterY:tempCenerY];
    [self.noNetView setCenterX:LXScreenWidth / 2];
    [self.view addSubview:self.noNetView];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"No_net"] forState:UIControlStateNormal];
    [btn1 setFrame:CGRectMake(0, 0, 95, 90)];
    [btn1 setCenterX:self.noNetView.width / 2];
    [self.noNetView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn2 setTitleColor:LXColorHex(0x5c5c5c) forState:UIControlStateNormal];
    [btn2 setFrame:CGRectMake(0, 120, 100, 30)];
    [btn2 setTitle:@"无网络信号" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(noNetClick) forControlEvents:UIControlEventTouchUpInside];
    [self.noNetView addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn3 setTitleColor:LXMainColor forState:UIControlStateNormal];
    [btn3 setTitle:@"点击刷新" forState:UIControlStateNormal];
    [btn3 setFrame:CGRectMake(100, 120, 80, 30)];
    [btn3 addTarget:self action:@selector(noNetClick) forControlEvents:UIControlEventTouchUpInside];
    [self.noNetView addSubview:btn3];
    
    self.noNetView.hidden = YES;
}

- (void)noNetClick {
    if (self.noNetBlock) {
        self.noNetBlock();
    }
}


#pragma mark - Setter

- (void)setHideNoNetView:(BOOL)hideNoNetView {
    _hideNoNetView = hideNoNetView;
    
    self.noNetView.hidden = hideNoNetView;
}

@end
