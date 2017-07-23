//
//  LXOrderViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/5.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrderViewController.h"

#import "ZJScrollPageView.h"

#import "LXWaitOrderViewController.h"
#import "LXHavenOrderViewController.h"
#import "LXCompleteOrderViewController.h"
#import "LXCancelOrderViewController.h"

#import "LXOrderDetailViewController.h"

@interface LXOrderViewController () <ZJScrollPageViewDelegate>

@property (nonatomic, copy) NSArray *segmentTitles;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation LXOrderViewController

#pragma mark - View Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 配置ScrollView
    [self configureScrollView];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.scrollPageView.hidden = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payOK) name:@"payOK" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.scrollPageView.hidden = YES;
}

#pragma mark - Configure

- (void)configureScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 样式
    ZJSegmentStyle *segmentStyle = [ZJSegmentStyle new];
    segmentStyle.showCover = NO;
    segmentStyle.showLine = YES;
    segmentStyle.scaleTitle = NO;
    segmentStyle.adjustCoverOrLineWidth = NO;
    segmentStyle.autoAdjustTitlesWidth = YES;
    segmentStyle.scrollLineHeight = 3;
    segmentStyle.scrollLineColor = LXMainColor;
    segmentStyle.selectedTitleColor = LXMainColor;
    segmentStyle.normalTitleColor = LXColorHex(0x4B4C4D);
    self.segmentTitles = @[@"待接单", @"已接单", @"已完成", @"已取消"];
    
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height - LXNavigaitonBarHeight - LXTabbarBarHeight) segmentStyle:segmentStyle titles:self.segmentTitles parentViewController:self delegate:self];
    
    // 添加
    [self.view addSubview:self.scrollPageView];
   
}
-(void)payOK{
     [self.scrollPageView setSelectedIndex:2 animated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mar - ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers {
    return self.segmentTitles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController <ZJScrollPageViewChildVcDelegate> *tempVC = nil;
    if (index == 0) {
        tempVC = [[LXWaitOrderViewController alloc] init];
        
        return tempVC;
    }
    else if (index == 1) {
        tempVC = [LXHavenOrderViewController new];
        
        return tempVC;
    }
    else if (index == 2) {
        tempVC = [LXCompleteOrderViewController new];
        
        return tempVC;
    }
    else if (index == 3) {
        tempVC = [LXCancelOrderViewController new];
        
        return tempVC;
    }
    
    return nil;
}

- (void)removeViewController:(UIViewController *)viewController {
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

@end
