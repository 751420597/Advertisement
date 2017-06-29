//
//  LXOrganizationViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/5.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrganizationViewController.h"

// View
#import "LXOrganizationTableViewCell.h"

// Controller
#import "LXStaffViewController.h"

// Model
#import "LXOrganizationViewModel.h"
#import "LXOrganizaitonModel.h"


static NSString *const LXOrganizationTableViewCellID = @"LXOrganizationTableViewCellID";

@interface LXOrganizationViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) LXOrganizationViewModel *viewModel;

@end

@implementation LXOrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"机构";
    
    [self.view setBackgroundColor:LXColorHex(0xf5f5f5)];
    [self.tableView setBackgroundColor:LXColorHex(0xf5f5f5)];
    
    [self.view addSubview:self.tableView];
    
    [self fetchServerData];
}


#pragma mark - Service

- (void)fetchServerData {
    self.viewModel = [LXOrganizationViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    [self.viewModel getOrganizationListWithParameters:nil completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *tArray = result[@"agencyList"];
            
            for (NSDictionary *tempDict in tArray) {
                LXOrganizaitonModel *oModel = [LXOrganizaitonModel modelWithDictionary:tempDict];
                [self.dataSource addObject:oModel];
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
    LXOrganizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXOrganizationTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXOrganizationTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.oModel = self.dataSource[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LXOrganizaitonModel *tempModel = self.dataSource[indexPath.row];
    
    LXStaffViewController *sVC = [LXStaffViewController new];
    sVC.agency_id = tempModel.corId;
    sVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sVC animated:YES];
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
        
        _tableView.rowHeight = 123;
    }
    return _tableView;
}

@end
