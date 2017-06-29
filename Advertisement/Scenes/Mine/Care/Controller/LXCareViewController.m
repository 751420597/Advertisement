//
//  LXCareViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXCareViewController.h"

#import "LXCareVCTableCell.h"

#import "LXAddCareViewController.h"
#import "LXCareDetailViewController.h"

#import "LXCareModel.h"
#import "LXCareViewModel.h"

static NSString *const LXCareVCTableCellID = @"LXCareVCTableCellID";
static CGFloat LXCareTableViewOriginX = 10;
static CGFloat LXCareTableViewOriginY = 10;
#define LXCareTableViewHeight  (LXScreenHeight - LXNavigaitonBarHeight - LXCareTableViewOriginY)
#define LXCareTableViewWidth   (LXScreenWidth - LXCareTableViewOriginX * 2)

static CGFloat LXCareTableViewRowHeight = 70;

@interface LXCareViewController ()

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) LXCareViewModel *viewModel;

@property (nonatomic, assign) BOOL isAddCare;

@end


@implementation LXCareViewController

- (instancetype)initWithIsAddCare:(BOOL)isAdd {
    if (self = [super init]) {
        self.isAddCare = isAdd;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"照护对象";
    self.view.backgroundColor = LXVCBackgroundColor;
    
    if (self.isAddCare) {
        UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedSpaceBarButtonItem.width = -10;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
        barButtonItem.width = 10;
        self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    }

    [self setUpTable];
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXCareViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    [self.viewModel getCareListWithParameters:nil completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        self.dataSource = [NSMutableArray array];
        if (code == 0) {
            NSArray *tempArray = result[@"careObjList"];
            
            for (NSDictionary *objectDict in tempArray) {
                LXCareModel *careModel = [LXCareModel modelWithDictionary:objectDict];
                [self.dataSource addObject:careModel];
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
    [self setUpTableViewWithFrame:CGRectMake(LXCareTableViewOriginX, LXCareTableViewOriginY, LXCareTableViewWidth,LXCareTableViewHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    self.tableView.rowHeight = LXCareTableViewRowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    NSDictionary *dict1 = @{@"小伙子":@"审核中"};
//    NSDictionary *dict2 = @{@"小伙子":@"已通过"};
//    NSDictionary *dict3 = @{@"小伙子":@"未认证"};
//    NSDictionary *dict4 = @{@"小伙子":@"未通过"};
//    NSDictionary *dict5 = @{@"小伙子":@"重新申请"};
//    [self.dataSource addObject:dict1];
//    [self.dataSource addObject:dict2];
//    [self.dataSource addObject:dict3];
//    [self.dataSource addObject:dict4];
//    [self.dataSource addObject:dict5];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXCareVCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:LXCareVCTableCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXCareVCTableCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self addCustomeLineWithArray:[self.dataSource copy] indexPath:indexPath width:LXCareTableViewWidth height:LXCareTableViewRowHeight color:LXCellBorderColor cell:cell];
    }
    
    LXCareModel *careModel = self.dataSource[indexPath.row];
    
    cell.nameL.text = careModel.careObjName;
    cell.expireTimeL.text = careModel.checkTime;
    cell.stateL.text = careModel.checkStateName;
    
    [self configureCellWithTableViewCell:cell value:careModel.checkStateName];
    
    return cell;
}


#pragma mark - Configure Cell

- (void)configureCellWithTableViewCell:(LXCareVCTableCell *)cell value:(NSString *)value {
    UIColor *tempColor = nil;
    
    if ([value isEqualToString:@"审核中"]) {
        tempColor = LXColorHex(0x4c4c4c);
    }
    else if ([value isEqualToString:@"已通过"]) {
         tempColor = LXMainColor;
    }
    else if ([value isEqualToString:@"未认证"]) {
         tempColor = [UIColor redColor];
    }
    else if ([value isEqualToString:@"未通过"]) {
         tempColor = LXColorHex(0x4c4c4c);
        
        cell.nameConstrait.constant = 0;
        cell.expireTimeL.hidden = YES;
    }
//    else if ([value isEqualToString:@"重新申请"]) {
//        tempColor = LXColorHex(0x4c4c4c);
//    }
    
    [cell.stateL setTextColor:tempColor];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LXCareModel *careModel = self.dataSource[indexPath.row];
    
    if (self.selectBlock) {
        self.selectBlock(careModel.careObjId, careModel.careObjName);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if ([careModel.checkStateName isEqualToString:@"未通过"]) {
            LXAddCareViewController *acVC = [LXAddCareViewController new];
            acVC.careId = careModel.careObjId;
            [self.navigationController pushViewController:acVC animated:YES];
        }
        else {
            LXCareDetailViewController *cdVC = [LXCareDetailViewController new];
            cdVC.careId = careModel.careObjId;
            [self.navigationController pushViewController:cdVC animated:YES];
        }
    }
}


#pragma mark - Action

- (void)addBtnClick {
    LXAddCareViewController *acVC = [LXAddCareViewController new];
    acVC.reloadBlock = ^{
         [self getServiceData];
    };
    [self.navigationController pushViewController:acVC animated:YES];
}


#pragma mark - Getter

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_addBtn setFrame:CGRectMake(0, 0, 40, 30)];
        [_addBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}



@end
