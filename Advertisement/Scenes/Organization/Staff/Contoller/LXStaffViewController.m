//
//  LXStaffViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/10.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXStaffViewController.h"

#import "LXStaffInfoViewController.h"

#import "LXStaffVCTableViewCell.h"

// Model
#import "LXStaffModel.h"
#import "LXStaffViewModel.h"

static NSString *const LXStaffVCTableViewCellID = @"LXStaffVCTableViewCellID";
static CGFloat StaffCustomeLineWidth = 1.f;
static CGFloat StaffCustomeLineLeftEdge = 10;

#define StaffTableViewWidth      (LXScreenWidth - 20)
#define StaffTableViewRowHeight  (82)

@interface LXStaffViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) LXStaffViewModel *viewModel;

@end


@implementation LXStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"护理员";
    [self.view setBackgroundColor:LXVCBackgroundColor];
    
    [self.view addSubview:self.tableView];
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXStaffViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{@"agency_id":self.agency_id};
    
    [self.viewModel getStaffListWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *tArray = result[@"careWorkersList"];
            
            for (NSDictionary *tempDict in tArray) {
                LXStaffModel *oModel = [LXStaffModel modelWithDictionary:tempDict];
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
    LXStaffVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXStaffVCTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXStaffVCTableViewCell" owner:self options:nil] lastObject];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, StaffTableViewWidth, StaffCustomeLineWidth)];
        [topLine setBackgroundColor:LXCellBorderColor];
        if (indexPath.row == 0) {
            [cell.contentView addSubview:topLine];
        }
        
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, StaffCustomeLineWidth, StaffTableViewRowHeight)];
        [leftLine setBackgroundColor:LXCellBorderColor];
        [cell.contentView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(StaffTableViewWidth - 1, 0, StaffCustomeLineWidth, StaffTableViewRowHeight)];
        [rightLine setBackgroundColor:LXCellBorderColor];
        [cell.contentView addSubview:rightLine];
        
        NSInteger myBottomLineWidth;
        NSInteger myBottomLineOriginX;
        if (indexPath.row == [self.dataSource count] - 1) {
            myBottomLineOriginX = 0;
            myBottomLineWidth = StaffCustomeLineWidth - myBottomLineOriginX;
            
        }
        else {
            myBottomLineOriginX = StaffCustomeLineLeftEdge;
            myBottomLineWidth = StaffCustomeLineWidth - myBottomLineOriginX;
        }
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(myBottomLineOriginX, StaffTableViewRowHeight - 1, StaffTableViewWidth, StaffCustomeLineWidth)];
        [bottomLine setBackgroundColor:LXCellBorderColor];
        [cell.contentView addSubview:bottomLine];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.sModel = self.dataSource[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LXStaffModel *sModel = self.dataSource[indexPath.row];
    
    LXStaffInfoViewController *siVC = [LXStaffInfoViewController new];
    siVC.cw_user_id = sModel.cwUserId;
    [self.navigationController pushViewController:siVC animated:YES];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - LXNavigaitonBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableFooterView = [UIView new];
        [_tableView setBackgroundColor:LXVCBackgroundColor];
        
        [_tableView lx_setViewCornerRadius:5 borderColor:nil borderWidth:0];
        
        _tableView.rowHeight = StaffTableViewRowHeight;
    }
    return _tableView;
}



@end
