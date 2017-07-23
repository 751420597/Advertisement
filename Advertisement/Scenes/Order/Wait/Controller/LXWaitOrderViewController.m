//
//  LXWaitOrderViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/6.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXWaitOrderViewController.h"

#import "LXWaitOrdetVCTableViewCell.h"

#import "LXOrderDetailViewController.h"

#import "LXOrderListModel.h"
#import "LXWaitOrderViewModel.h"

static NSString *const LXWaitOrdetVCTableViewCellID = @"LXWaitOrdetVCTableViewCellID";

@interface LXWaitOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) dispatch_block_t waitBlock;

@property (nonatomic, strong) LXWaitOrderViewModel *viewModel;

@end

@implementation LXWaitOrderViewController

- (instancetype)initWithBlock:(dispatch_block_t)block {
    if (self = [super init]) {
        self.waitBlock = block;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self getServiceData];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    [self.view addSubview:self.tableView];
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXWaitOrderViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{@"orderState":@"0"};
    
    [self.viewModel getOrderListWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        [self.dataSource removeAllObjects];
        if (code == 0) {
            NSArray *objectArray = result[@"userOrderList"];
            
            for (NSDictionary *objectDict in objectArray) {
                LXOrderListModel *waitOrderModel = [LXOrderListModel modelWithDictionary:objectDict];
                waitOrderModel.serveTime = [waitOrderModel.serveTime substringWithRange:NSMakeRange(0, waitOrderModel.serveTime.length-5)];
                waitOrderModel.type = 0;
                [self.dataSource addObject:waitOrderModel];
            }
            
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - ZJScrollPageViewChildVcDelegate

//- (void)zj_viewWillDisappearForIndex:(NSInteger)index {
//    LXLog(@"index:%ld", (long)index);
//}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXWaitOrdetVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXWaitOrdetVCTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXWaitOrdetVCTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.orderListModel = self.dataSource[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LXOrderListModel *orderListModel = self.dataSource[indexPath.row];
    
//    取消订单(订单详情)
    LXOrderDetailViewController *odVC = [[LXOrderDetailViewController alloc] initWithType:LXReservationBottomTypeCancelOrder];
    odVC.orderId = orderListModel.ordId;
    odVC.hidesBottomBarWhenPushed = YES;
    odVC.orderIdState = orderListModel.ordStatId;
    [self.navigationController pushViewController:odVC animated:YES];
}


#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        if(_isHome){
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth, LXScreenHeight - LXNavigaitonBarHeight) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth, LXScreenHeight - LXNavigaitonBarHeight - LXTabbarBarHeight-44) style:UITableViewStylePlain];
        }
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
       [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableFooterView = [UIView new];
       [_tableView setBackgroundColor:LXColorHex(0xf5f5f5)];
        
        _tableView.rowHeight = LXRate(120);
    }
    return _tableView;
}


@end
