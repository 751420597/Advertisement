//
//  LXOrderDetailViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/13.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrderDetailViewController.h"

#import "LXServiceRecordeViewController.h"

#import "ZJScrollSegmentView.h"
#import "ZJContentView.h"

@interface LXOrderDetailViewController () <ZJScrollPageViewDelegate>

@property (strong, nonatomic) NSArray <NSString *> *titles;
@property (strong, nonatomic) NSArray <UIViewController <ZJScrollPageViewChildVcDelegate> *> *childVcs;
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;
@property (strong, nonatomic) ZJContentView *contentView;

@property (nonatomic, assign) LXReservationBottomType bottomType;

@end


@implementation LXOrderDetailViewController

- (instancetype)initWithType:(LXReservationBottomType)bottomeType {
    if (self = [super init]) {
        self.bottomType = bottomeType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    // 初始化
    [self setupSegmentView];
    [self setupContentView];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


#pragma mark - Set Up

- (void)setupSegmentView {
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    
    // 是否显示遮盖
    style.showCover = YES;
    // 不要滚动标题, 每个标题将平分宽度
    style.scrollTitle = NO;
    // 渐变
    style.gradualChangeTitleColor = YES;
    // 遮盖背景颜色
    style.coverBackgroundColor = [UIColor whiteColor];
    // 标题一般状态颜色 --- 注意一定要使用RGB空间的颜色值
    style.normalTitleColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    // 标题选中状态颜色 --- 注意一定要使用RGB空间的颜色值
    style.selectedTitleColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    self.titles = @[@"订单详情", @"服务记录"];
    
    // 注意: 一定要避免循环引用!!
    __weak typeof(self) weakSelf = self;
    
    ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 64.0, 160.0, 28.0) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
        
        [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
        
    }];
    
    // 自定义标题的样式
    segment.layer.cornerRadius = 14.0;
    segment.backgroundColor = LXMainColor;

    self.segmentView = segment;
    self.navigationItem.titleView = self.segmentView;    
}

- (void)setupContentView {
    self.contentView = [[ZJContentView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentView:self.segmentView parentViewController:self delegate:self];

    [self.view addSubview:self.contentView];
}


#pragma mark - ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}


- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = self.childVcs[index];
    }
    
    return childVc;
}

- (CGRect)frameOfChildControllerForContainer:(UIView *)containerView {
    return  CGRectInset(containerView.bounds, 20, 20);
}


#pragma mark - Getter

- (NSArray *)childVcs {
    if (!_childVcs) {
        if (self.bottomType == LXReservationBottomTypeCancelOrder || self.bottomType ==LXReservationBottomTypeWaitPayOrder
            ) {
            LXOrderDetailInfoViewController *rVC = [[LXOrderDetailInfoViewController alloc] initWithBottomType:self.bottomType];
            rVC.orderId = self.orderId;
            
            LXServiceRecordeViewController *sVC = [[LXServiceRecordeViewController alloc] initWithBottomType:LXReservationBottomTypeNone];
            sVC.orderId = self.orderId;
            
            _childVcs = @[rVC, sVC];
        }
        else {
            LXOrderDetailInfoViewController *rVC = [[LXOrderDetailInfoViewController alloc] initWithBottomType:LXReservationBottomTypeNone];
            rVC.orderId = self.orderId;
            
            LXServiceRecordeViewController *sVC = [[LXServiceRecordeViewController alloc] initWithBottomType:self.bottomType];
            sVC.orderId = self.orderId;
            
            _childVcs = @[rVC, sVC];
        }
    }
    return _childVcs;
}


@end
