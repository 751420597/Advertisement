//
//  LXOrderDetailInfoViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/13.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

//
//  LXReservationViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/9.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrderDetailInfoViewController.h"

#import "LXOderDealView.h"

#import "LXReservationModel.h"
#import "LXOrderDetailViewModel.h"

#import "LXOrderDetailServiceViewController.h"
#import "LXTimeSelectViewController.h"

#import "LXReservationVCTableViewCellNormal.h"
#import "LXReservationVCTableViewCellNormalBig.h"
#import "LXReservationVCTableViewCellSelectEnter.h"
#import "LXReservationTableViewCellSelectStay.h"

@interface LXOrderDetailInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *orderArray;

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *selectCareL;

@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UITextField *remarkTF;

@property (nonatomic, strong) UILabel *timeL1;
@property (nonatomic, strong) UILabel *timeL2;
@property (nonatomic, strong) UILabel *repeatL;

@property (nonatomic, strong) LXOderDealView *orderDealView;
@property (nonatomic, strong) LXOrderDetailViewModel *viewModel;

@property (nonatomic, strong) LXReservationModel *reservationModel;

@property (nonatomic, assign) LXReservationBottomType reservationBottomType;

@end

@implementation LXOrderDetailInfoViewController

#pragma mark - View Life

- (instancetype)initWithBottomType:(LXReservationBottomType)bottomeType {
    if (self = [super init]) {
        self.reservationBottomType = bottomeType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self congfigreView];
    
    [self.view addSubview:self.tableView];
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXOrderDetailViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{ @"orderId":self.orderId };
    
    [self.viewModel getDetailWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            self.reservationModel = [LXReservationModel modelWithDictionary:result];
            
//            LXReservationTimeModel *reservationTimeModel = [LXReservationTimeModel new];
//            reservationTimeModel.startTime = (NSString *)(((NSArray *)result[@"serveConfig"][@"servTime"]).firstObject);
//            reservationTimeModel.endTime = (NSString *)(((NSArray *)result[@"serveConfig"][@"servTime"]).lastObject);
//            reservationTimeModel.repeatWeek = (NSString *)result[@"serveConfig"][@"week"];
//            
//            self.reservationModel.timeModel = reservationTimeModel;
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - Configure

- (void)congfigreView {
    [self.view setBackgroundColor:LXVCBackgroundColor];
    
   if (self.reservationBottomType == LXReservationBottomTypeCancelOrder ||
             self.reservationBottomType == LXReservationBottomTypeWaitPayOrder ||
             self.reservationBottomType == LXReservationBottomTypeWaitCommentOrder ||
             self.reservationBottomType == LXReservationBottomTypeHavenCommentOrder ||
             self.reservationBottomType == LXReservationBottomTypeDeleteOrder) {
        [self.view addSubview:self.orderDealView];
        [self.view bringSubviewToFront:self.orderDealView];
    }
    else {
        self.orderDealView.hidden = YES;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXWeakSelf(self);
    
    NSString *leadingString = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            LXReservationVCTableViewCellSelectEnter *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellSelectEnter" owner:self options:nil].firstObject;
            
            cell.leadingL.text = leadingString;
            cell.middleL.text = self.reservationModel.careObjName;
            self.selectCareL = cell.middleL;
            return cell;
        }
        else {
            LXReservationVCTableViewCellNormal *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellNormal" owner:self options:nil].firstObject;
            
            NSString *placeString = nil;
            if (indexPath.row == 0) {
                cell.trailingTF.text = self.reservationModel.contactUser;
                self.nameTF = cell.trailingTF;
                self.nameTF.enabled = NO;
            }
            else {
                placeString = @"请输入11位有效手机号码";
                cell.trailingTF.text =self.reservationModel.contactPhone;
                self.phoneTF = cell.trailingTF;
                self.phoneTF.placeholder = placeString;
                self.phoneTF.enabled = NO;
            }
            
            cell.leadingL.text = leadingString;
            
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            LXReservationTableViewCellSelectStay *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationTableViewCellSelectStay" owner:self options:nil].firstObject;
            
            cell.leadingL.text = @"服务类型";
            cell.arrowBtnTrailingConstraint.constant = -100;
            
//            if ([self.reservationModel.servTypeId isEqualToString:@"1"]) {
//                cell.trailingL.text = @"基本生活照料服务";
//            }
//            else if ([self.reservationModel.servTypeId isEqualToString:@"2"]) {
//                cell.trailingL.text = @"医疗护理服务";
//            }
            cell.trailingL.text = self.reservationModel.servTypeName;
            return cell;
        }
        else if (indexPath.row == 1) {
            LXReservationVCTableViewCellSelectEnter *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellSelectEnter" owner:self options:nil].firstObject;
            
            cell.middleLConstrait.constant = -100;
            cell.leadingL.text = leadingString;
            
            return cell;
        }
        else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section1row2"];
            
            UILabel *firstl = [[UILabel alloc] init];
            [firstl setFont:[UIFont systemFontOfSize:14]];
            [firstl setTextColor:LXColorHex(0x4c4c4c)];
            [firstl setText:@"时间"];
            [cell.contentView addSubview:firstl];
            [firstl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.mas_equalTo(cell.contentView).mas_offset(10);
            }];
            
            self.timeL1 = [[UILabel alloc] init];
            [cell.contentView addSubview:self.timeL1];
            self.repeatL = [[UILabel alloc] init];
            [cell.contentView addSubview:self.repeatL];
            self.timeL2 = [[UILabel alloc] init];
            [cell.contentView addSubview:self.timeL2];
            
            
            [self.timeL1 setFont:[UIFont systemFontOfSize:14]];
            [self.timeL1 setTextColor:LXColorHex(0xb2b2b2)];
            [self.timeL1 setText:self.reservationModel.timeModel.startTime];
            
            [self.timeL1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.mas_equalTo(cell.contentView).mas_offset(10);
                make.left.mas_equalTo(cell.contentView).mas_offset(70);
                
                make.width.mas_offset (cell.contentView.width-90);
                make.height.mas_equalTo(firstl);
            }];
            
            [self.timeL2 setFont:[UIFont systemFontOfSize:14]];
            [self.timeL2 setTextColor:LXColorHex(0xb2b2b2)];
            [self.timeL2 setText:self.reservationModel.timeModel.endTime];
            self.timeL2.text = self.reservationModel.serveTime;
            [self.timeL2 mas_makeConstraints:^(MASConstraintMaker *make) {
                //                make.leading.mas_equalTo(cell.contentView).mas_offset(70);
                //                make.centerY.mas_equalTo(cell.contentView);
                
                make.top.mas_equalTo(weakself.timeL1.mas_bottom).mas_offset(5);
                
                make.leading.mas_equalTo(cell.contentView).mas_offset(70);
                make.width.equalTo(weakself.timeL1);
                make.height.mas_equalTo(firstl);
                //make.height.mas_equalTo(@[weakself.timeL1, weakself.repeatL]);
            }];
            
            
            [self.repeatL setFont:[UIFont systemFontOfSize:14]];
            [self.repeatL setTextColor:LXColorHex(0xb2b2b2)];
            [self.repeatL setText:self.reservationModel.timeModel.repeatWeek];
            
            [self.repeatL mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(weakself.timeL2.mas_bottom).mas_offset(5);
                make.leading.mas_equalTo(cell.contentView).mas_offset(70);
               
                
                make.height.width.mas_equalTo(@[weakself.timeL1, weakself.timeL2]);
            }];
            
            UIButton *arrowB = [UIButton buttonWithType:UIButtonTypeCustom];
            [arrowB setBackgroundImage:[UIImage imageNamed:@"Organization_arrow"] forState:UIControlStateNormal];
            [cell.contentView addSubview:arrowB];
            [arrowB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(10);
                make.height.mas_equalTo(15);
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-10);
                make.centerY.mas_equalTo(cell.contentView);
            }];
            
            
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            LXReservationVCTableViewCellNormalBig *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellNormalBig" owner:self options:nil].firstObject;
            cell.trailingTF.text = self.reservationModel.address;
            self.addressTF =cell.trailingTF;
            self.addressTF.enabled = NO;
            cell.leadingL.text = leadingString;
            
            return cell;
        }
        else if (indexPath.row == 1) {
            LXReservationVCTableViewCellNormal *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellNormal" owner:self options:nil].firstObject;
            
            cell.leadingL.text = leadingString;
            cell.trailingTF.text = self.reservationModel.otherContent;
            
            self.remarkTF = cell.trailingTF;
            self.remarkTF.enabled = NO;
            return cell;
        }
    }
    
    return nil;
}



- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempStrig = self.dataSource[indexPath.section][indexPath.row];
    
    if ([tempStrig isEqualToString:@"时间"]) {
        return 100;
    }
    else if ([tempStrig isEqualToString:@"服务地址"]) {
        return 75;
    }
    else {
        return 50;
    }
}


#pragma mark - UITalbeViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempStrig = self.dataSource[indexPath.section][indexPath.row];
    
    if ([tempStrig isEqualToString:@"照护对象"]) {
        
    }
    else if ([tempStrig isEqualToString:@"时间"]) {
//        LXTimeSelectViewController *timeSVC = [[LXTimeSelectViewController alloc] init];
//        [self.navigationController pushViewController:timeSVC animated:YES];
    }
    else if ([tempStrig isEqualToString:@"服务项目"]) {
        LXOrderDetailServiceViewController *servicePVC = [[LXOrderDetailServiceViewController alloc] init];
        servicePVC.orderId = self.orderId;
        [self.navigationController pushViewController:servicePVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *leftLine = [[UIView alloc] init];
    [leftLine setBackgroundColor:LXCellBorderColor];
    [cell.contentView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(cell.contentView).mas_offset(0);
        make.top.bottom.mas_equalTo(cell.contentView);
        make.width.mas_equalTo(1);
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    [rightLine setBackgroundColor:LXCellBorderColor];
    [cell.contentView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(cell.contentView);
        make.width.mas_equalTo(1);
        make.trailing.mas_equalTo(cell.contentView).mas_offset(-1);
    }];
}


#pragma mark - Action


#pragma mark - Getter


- (LXOderDealView *)orderDealView {
    if (!_orderDealView) {
        _orderDealView = [[LXOderDealView alloc] initWithTrailingClick:^{
            
        }];
        [_orderDealView setFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - 50, LXScreenWidth, 50)];
        
        //        LXReservationBottomTypeCancelOrder,
        //        LXReservationBottomTypeWaitPayOrder,
        //        LXReservationBottomTypeWaitCommentOrder,
        //        LXReservationBottomTypeHavenCommentOrder,
        //        LXReservationBottomTypeDeleteOrder
        
        //        待接单--取消订单
        //        已接单--待服务 「取消订单（前12小时）」
        //        服务中 （ 待支付）
        //        已完成-- 待评价
        //        已评价
        //        已取消--删除订单
        
        [_orderDealView setLeadingString:@"￥：50"];
        
        if (self.reservationBottomType == LXReservationBottomTypeCancelOrder) {
            [_orderDealView setTrailingString:@"取消订单"];
        }
        else if (self.reservationBottomType == LXReservationBottomTypeWaitPayOrder) {
            [_orderDealView setTrailingString:@"待支付"];
        }
        else if (self.reservationBottomType == LXReservationBottomTypeWaitCommentOrder) {
            [_orderDealView setTrailingString:@"待评价"];
        }
        else if (self.reservationBottomType == LXReservationBottomTypeHavenCommentOrder) {
            [_orderDealView setTrailingString:@"已评价"];
        }
        else if (self.reservationBottomType == LXReservationBottomTypeDeleteOrder) {
            [_orderDealView setTrailingString:@"删除订单"];
        }
    }
    return _orderDealView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, LXScreenWidth - 10 * 2, LXScreenHeight - 10 - LXNavigaitonBarHeight - 50) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = 10;
        _tableView.sectionHeaderHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSMutableArray *seciton0 = [NSMutableArray array];
        [seciton0 addObject:@"联系人"];
        [seciton0 addObject:@"手机"];
        [seciton0 addObject:@"照护对象"];
        [_dataSource addObject:seciton0];
        
        NSMutableArray *section1 = [NSMutableArray array];
        [section1 addObject:@"服务类型"];
        [section1 addObject:@"服务项目"];
        [section1 addObject:@"时间"];
        [_dataSource addObject:section1];
        
        NSMutableArray *seciton2 = [NSMutableArray array];
        [seciton2 addObject:@"服务地址"];
        [seciton2 addObject:@"备注"];
        [_dataSource addObject:seciton2];
    }
    return _dataSource;
}

- (NSMutableArray *)orderArray {
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
        [_orderArray addObject:@"1"];
        [_orderArray addObject:@"2"];
        [_orderArray addObject:@"3"];
    }
    return _orderArray;
}

@end
