//
//  LXCancelOrderViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/6.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXCancelOrderViewController.h"

#import "LXWaitOrdetVCTableViewCell.h"

#import "LXOrderDetailViewController.h"

#import "LXOrderListModel.h"
#import "LXWaitOrderViewModel.h"

static NSString *const LXCancelOrdetVCTableViewCellID = @"LXCancelOrdetVCTableViewCellID";

@interface LXCancelOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) LXWaitOrderViewModel *viewModel;

@end

@implementation LXCancelOrderViewController

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
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{@"orderState":@"3"};
    
    [self.viewModel getOrderListWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *objectArray = result[@"userOrderList"];
            
            for (NSDictionary *objectDict in objectArray) {
                LXOrderListModel *waitOrderModel = [LXOrderListModel modelWithDictionary:objectDict];
                waitOrderModel.type = 3;
                [self.dataSource addObject:waitOrderModel];
            }
            
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXWaitOrdetVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXCancelOrdetVCTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXWaitOrdetVCTableViewCell" owner:self options:nil] lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    cell.orderListModel = self.dataSource[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    删除订单
    LXOrderDetailViewController *odVC = [[LXOrderDetailViewController alloc] initWithType:LXReservationBottomTypeDeleteOrder];
    odVC.hidesBottomBarWhenPushed = YES;
    LXOrderListModel *waitOrderModel =self.dataSource[indexPath.row];
    odVC.orderId = waitOrderModel.ordId;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth, LXScreenHeight - LXNavigaitonBarHeight - LXTabbarBarHeight) style:UITableViewStylePlain];
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
