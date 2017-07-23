//
//  LXOrderDetailServiceViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/22.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrderDetailServiceViewController.h"

#import "LXServiceProjectVCTableCell.h"

#import "LXOrderDetailServiceViewModel.h"
#import "LXOrderDetailSeriviceModel.h"

static NSString *const LXOrderDetailServiceVCTableCellID = @"LXOrderDetailServiceVCTableCellID";
static CGFloat LXOrderDetailServiceTableViewOriginX = 10;
static CGFloat LXOrderDetailServiceTableViewOriginY = 10;
#define LXOrderDetailServiceTableViewHeight  (LXScreenHeight - LXNavigaitonBarHeight - LXOrderDetailServiceTableViewOriginY)
#define LXOrderDetailServiceTableViewWidth   (LXScreenWidth - LXOrderDetailServiceTableViewOriginX * 2)

static CGFloat LXOrderDetailServiceTableViewRowHeight = 50;

@interface LXOrderDetailServiceViewController ()

@property (nonatomic, strong) LXOrderDetailServiceViewModel *viewModel;

@end


@implementation LXOrderDetailServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = LXVCBackgroundColor;
    
//    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
//    fixedSpaceBarButtonItem.width = -10;
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
//    barButtonItem.width = 10;
//    self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    
    [self setUpTable];
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXOrderDetailServiceViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{ @"orderId":self.orderId };
    
    [self.viewModel getServiceList1WithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *objectArray = result[@"careItemList"];
            
            for (NSDictionary *ojectDict in objectArray) {
                LXOrderDetailSeriviceModel *tempModel = [LXOrderDetailSeriviceModel modelWithDictionary:ojectDict];
                tempModel.careItemPrice = [tempModel.careItemPrice substringWithRange:NSMakeRange(0, tempModel.careItemPrice.length-2)];
                [self.dataSource addObject:tempModel];
            }
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - Set up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(LXOrderDetailServiceTableViewOriginX, LXOrderDetailServiceTableViewOriginY, LXOrderDetailServiceTableViewWidth, LXOrderDetailServiceTableViewHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    self.tableView.rowHeight = LXOrderDetailServiceTableViewRowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXServiceProjectVCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:LXOrderDetailServiceVCTableCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXServiceProjectVCTableCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self addCustomeLineWithArray:[self.dataSource copy] indexPath:indexPath width:LXOrderDetailServiceTableViewWidth height:LXOrderDetailServiceTableViewRowHeight color:LXCellBorderColor cell:cell];
    }
    if(_isDetail){
        cell.arrowBtn.alpha = 0;
        cell.selectBtn.alpha = 0;
    }
    cell.orderDetailSeriviceModel = self.dataSource[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - Aciton

- (void)addBtnClick {
    
}


#pragma mark - Getter

//- (UIButton *)addBtn {
//    if (!_addBtn) {
//        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_addBtn setTitle:@"确定" forState:UIControlStateNormal];
//        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
//        [_addBtn setFrame:CGRectMake(0, 0, 40, 30)];
//        [_addBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
//        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _addBtn;
//}


@end
