//
//  LXRootTabbarViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTabbarViewController.h"

#import "LXRootNavViewController.h"

#import "LXHomeViewController.h"
#import "LXOrderViewController.h"
#import "LXOrganizationViewController.h"
#import "LXMineViewController.h"
#import  "LXLogInViewModel.h"
@interface LXRootTabbarViewController ()

@property (nonatomic, strong) NSMutableArray *tabbarViewControllers;
@property (nonatomic, strong) LXLogInViewModel *viewModel;
@end


@implementation LXRootTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *tabbarItem1 = [UITabBarItem appearance];
    
    NSMutableDictionary *normalAttibute = [NSMutableDictionary new];
    normalAttibute[NSForegroundColorAttributeName] = LXColorHex(0x333333);
    normalAttibute[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    NSMutableDictionary *selectedAttibute = [NSMutableDictionary new];
    selectedAttibute[NSForegroundColorAttributeName] = LXMainColor;
    selectedAttibute[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    [tabbarItem1 setTitleTextAttributes:normalAttibute forState:UIControlStateNormal];
    [tabbarItem1 setTitleTextAttributes:selectedAttibute forState:UIControlStateSelected];
    
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    // 首页
    LXHomeViewController *homeVC = [LXHomeViewController new];
    [self addChildVc:homeVC title:@"首页" image:@"home" selectedImage:@"home_selected"];
    
    // 发现
    LXOrganizationViewController *organizaitonVC = [LXOrganizationViewController new];
    [self addChildVc:organizaitonVC title:@"机构" image:@"organization" selectedImage:@"organization_selected"];
    
    // 订单
    LXOrderViewController *orderVC = [LXOrderViewController new];
    [self addChildVc:orderVC title:@"订单" image:@"order" selectedImage:@"order_selected"];
    
    // 我的
    LXMineViewController *mineVC = [LXMineViewController new];
    [self addChildVc:mineVC title:@"我的" image:@"mine" selectedImage:@"mine_selected"];
    
    self.viewControllers = self.tabbarViewControllers;
    
    NSDictionary *dict = @{@"phone_no":@""};
    
    //LXWeakSelf(self);
    self.viewModel = [LXLogInViewModel new];
    [self.viewModel logInWithWithParameters:dict completionHandler:^(NSError *error, id result) {
        [SVProgressHUD dismiss];
        
        //LXStrongSelf(self);
        
        if (!error) {
            int code = [result[@"code"] intValue];
            if (code == 0) {
                [LXStandardUserDefaults setObject:result[@"userId"] forKey:@"userId"];
                [LXStandardUserDefaults synchronize];
                
            }
        }
        
    }];
    
   

    
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置tabbar的文字
    childVc.tabBarItem.title = title;
    
    // 设置navigationBar的文字
    childVc.navigationItem.title = title;
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    LXRootNavViewController *nav = [[LXRootNavViewController alloc] initWithRootViewController:childVc];
    
    // 添加为子控制器
    [self.tabbarViewControllers addObject:nav];
}


#pragma mark - Getter

- (NSMutableArray *)tabbarViewControllers {
    if (!_tabbarViewControllers) {
        _tabbarViewControllers = [NSMutableArray new];
    }
    return _tabbarViewControllers;
}


@end
