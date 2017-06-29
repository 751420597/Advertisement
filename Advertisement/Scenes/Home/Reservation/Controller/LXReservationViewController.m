//
//  LXReservationViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/9.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXReservationViewController.h"

#import "LXConfirmOrderView.h"
#import "LXOderDealView.h"

#import "LXReservationModel.h"
#import "LXReservationViewModel.h"
#import "LXServiceProjectModel.h"

#import "LXServiceProjectViewController.h"
#import "LXTimeSelectViewController.h"
#import "LXCareViewController.h"

#import "LXReservationVCTableViewCellNormal.h"
#import "LXReservationVCTableViewCellNormalBig.h"
#import "LXReservationVCTableViewCellSelectEnter.h"
#import "LXReservationTableViewCellSelectStay.h"

@interface LXReservationViewController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *orderArray;

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, copy) NSString *phoneString;
@property (nonatomic, strong) UILabel *selectCareL;

@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic, strong) UITextField *remarkTF;
@property (nonatomic, copy) NSString *remarkString;

@property (nonatomic, strong) UILabel *timeL1;
@property (nonatomic, strong) UILabel *timeL2;
@property (nonatomic, strong) UILabel *repeatL;

@property (nonatomic, copy) NSString *timeL1String;
@property (nonatomic, copy) NSString *timeL2String;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, copy) NSString *repeatLString;

@property (nonatomic, strong) LXConfirmOrderView *confirmView;
@property (nonatomic, strong) LXOderDealView *orderDealView;

@property (nonatomic, strong) LXReservationViewModel *viewModel;

@property (nonatomic, assign) NSInteger serverType;
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, copy) NSString *careID;
@property (nonatomic, copy) NSString *careName;

@property (nonatomic, strong) LXReservationTableViewCellSelectStay *stayCell;


@end


@implementation LXReservationViewController

- (void)dealloc {
    [LXNotificationCenter removeObserver:self name:NotificationServicePojectSelect object:nil];
}


#pragma mark - View Life


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"预约服务";
    [self.view setBackgroundColor:LXVCBackgroundColor];
    
    self.serverType = 1;
    self.timeArray = [NSMutableArray array];
    self.timeL1String = @"预约时间";
    self.timeL2String  = @"预约时间";
    self.repeatLString = @"重复次数";
    self.careName = @"请选择照护对象";
    self.careID = nil;
    
    [self congfigreView];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [LXNotificationCenter addObserver:self selector:@selector(selectArray:) name:NotificationServicePojectSelect object:nil];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidReceiveTouchEventNotification
                                               object:nil];
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.serverType == 1) {
        self.stayCell = (LXReservationTableViewCellSelectStay *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    else if (self.serverType == 2) {
        self.stayCell = (LXReservationTableViewCellSelectStay *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    }
    
    [self.stayCell setSelected:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.nameString = self.nameTF.text;
    self.phoneString = self.phoneTF.text;
    self.addressString = self.addressTF.text;
    self.remarkString = self.remarkTF.text;
}

#pragma mark - Configure

- (void)congfigreView {
    [self.confirmView removeFromSuperview];
    self.confirmView = nil;
    [self.view addSubview:self.confirmView];
    self.confirmView.totalSum = [NSString stringWithFormat:@"总价：%ld", (long)self.totalPrice];
    self.confirmView.dataSource = self.orderArray;
    [self.view bringSubviewToFront:self.confirmView];
    
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
            cell.middleL.text = self.careName;
            self.selectCareL = cell.middleL;
            
            return cell;
        }
        else {
            LXReservationVCTableViewCellNormal *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellNormal" owner:self options:nil].firstObject;
            
            if (indexPath.row == 0) {
                self.nameTF = cell.trailingTF;
                self.nameTF.delegate = self;
                if (self.nameString.length > 0) {
                    self.nameTF.text = self.nameString;
                }
                else {
                    self.nameTF.placeholder = @"请输入联系人的姓名";
                }
            }
            else {
                self.phoneTF = cell.trailingTF;
                self.phoneTF.delegate =self;
                if (self.phoneString.length > 0) {
                    self.phoneTF.text = self.phoneString;
                }
                else {
                    self.phoneTF.placeholder = @"请输入联系电话";
                }
            }
            
            cell.leadingL.text = leadingString;
            
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            LXReservationTableViewCellSelectStay *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationTableViewCellSelectStay" owner:self options:nil].firstObject;
            
            cell.leadingL.text = @"服务类型";
            cell.trailingL.text = @"基本生活照料服务";
            
            return cell;
        }
        else if (indexPath.row == 1) {
            LXReservationTableViewCellSelectStay *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationTableViewCellSelectStay" owner:self options:nil].firstObject;
            
            cell.leadingLConstrait.constant = - 100;
            cell.trailingL.text = @"医疗护理服务";
            
            return cell;
        }
        else if (indexPath.row == 2) {
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
            [self.timeL1 setText:self.timeL1String];
           
            [self.timeL1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.contentView).mas_offset(10);
                make.leading.mas_equalTo(cell.contentView).mas_offset(70);
                
                make.height.mas_equalTo(@[weakself.timeL2, weakself.repeatL]);
            }];
            
            [self.timeL2 setFont:[UIFont systemFontOfSize:14]];
            [self.timeL2 setTextColor:LXColorHex(0xb2b2b2)];
            [self.timeL2 setText:self.timeL2String];
            
            [self.timeL2 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.leading.mas_equalTo(cell.contentView).mas_offset(70);
//                make.centerY.mas_equalTo(cell.contentView);
                
                make.top.mas_equalTo(weakself.timeL1.mas_bottom).mas_offset(5);
                make.bottom.mas_equalTo(weakself.repeatL.mas_top).mas_offset(-5);
                make.leading.mas_equalTo(cell.contentView).mas_offset(70);
                
               //make.height.mas_equalTo(@[weakself.timeL1, weakself.repeatL]);
            }];
            
           
            [self.repeatL setFont:[UIFont systemFontOfSize:14]];
            [self.repeatL setTextColor:LXColorHex(0xb2b2b2)];
            [self.repeatL setText:self.repeatLString];
           
            [self.repeatL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(70);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
                
                //make.height.mas_equalTo(@[weakself.timeL1, weakself.timeL2]);
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
            
            self.addressTF = cell.trailingTF;
            self.addressTF.delegate = self;
            if (self.addressString.length > 0) {
                self.addressTF.text = self.addressString;
            }
            else {
                self.addressTF.placeholder = @"请输入你的联系地址";
            }
            
            cell.leadingL.text = leadingString;
            
            return cell;
        }
        else if (indexPath.row == 1) {
            LXReservationVCTableViewCellNormal *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellNormal" owner:self options:nil].firstObject;
            
            cell.leadingL.text = leadingString;
            self.remarkTF = cell.trailingTF;
            self.remarkTF.delegate = self;
            if (self.remarkString.length > 0) {
                self.remarkTF.text = self.remarkString;
            }
            else {
                self.remarkTF.placeholder = @"请输入30字以内的备注";
            }
            
            return cell;
        }
    }
    
    return nil;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField==self.nameTF){
        self.nameString = self.nameTF.text;
    }else if (textField==self.phoneTF){
         self.phoneString = self.phoneTF.text;
    }else if(textField==self.addressTF){
        self.addressString = self.addressTF.text;
    }else if(textField==self.remarkTF){
        self.remarkString = self.remarkTF.text;
    }
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
        LXCareViewController *careViewController = [[LXCareViewController alloc] initWithIsAddCare:NO];
        
        LXWeakSelf(self);
        careViewController.selectBlock = ^(NSString *careID, NSString *name) {
            weakself.careID = careID;
            weakself.careName = name;
            
            [weakself updateView];
        };
        
        [self.navigationController pushViewController:careViewController animated:YES];
    }
    else if ([tempStrig isEqualToString:@"时间"]) {
        LXTimeSelectViewController *timeSVC = [[LXTimeSelectViewController alloc] init];
        
        LXWeakSelf(self);
        timeSVC.selectBlock = ^(NSArray *timeArray, NSString *repeat) {
            if ([timeArray count] == 0) {
                weakself.timeL1String = @"预约时间";
                weakself.timeL2String  = @"预约时间";
            }
            else if ([timeArray count] == 1) {
                weakself.timeL1String = timeArray[0];
                weakself.timeL2String  = @"预约时间";
            }
            else if ([timeArray count] >= 2) {
                weakself.timeL1String = timeArray[0];
                weakself.timeL2String  = timeArray[1];
            }
        
            weakself.timeArray = [timeArray mutableCopy];
            weakself.repeatLString = repeat;
            
            [weakself updateView];
        };
        
        [self.navigationController pushViewController:timeSVC animated:YES];
    }
    else if ([tempStrig isEqualToString:@"服务项目"]) {
        LXServiceProjectViewController *servicePVC = [[LXServiceProjectViewController alloc] init];
        servicePVC.addBlock = ^(NSArray *arr) {
            self.totalPrice = 0;
            self.orderArray = [NSMutableArray arrayWithArray:arr];
            
            if (self.orderArray.count > 0) {
                for (LXServiceProjectModel *model in self.orderArray) {
                    self.totalPrice += model.price.integerValue;
                }
            }
            
            [self updateView];
        };
        servicePVC.careID = self.careID;
        [self.navigationController pushViewController:servicePVC animated:YES];
    }
    else if ([tempStrig isEqualToString:@"服务类型"]) {
        self.serverType = 1;
    }
    else if ([tempStrig isEqualToString:@"服务类型1"]) {
        self.serverType = 2;
    }else{
        return;
    }
    [self.stayCell setSelected:NO animated:YES];
    self.stayCell = nil;
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

- (void)setUpReservation {
    [self.nameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
    [self.remarkTF resignFirstResponder];
    self.viewModel = [LXReservationViewModel new];

    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];

//    servType	服务类型id	必填
//    servItem	服务项目id—若是多个，用逗号连接，例1，2，3	必填
//    contactUser	联系人	必填
//    contactPhone	联系电话	必填
//    careObj	照护对象id	必填
//    servTime	服务时间--格式2017-05-05 14:00:00,若是多个，用逗号连接，例2017-05-05 14:00:00, 2017-05-06 14:00:00	必填
//    repeatWeek	周重复	非必填
//    address	服务地址	必填
//    otherContent	其他说明	必填
//    orderPrice	订单总额	必填
//    goodsPrice	服务项目总额	必填
    
    NSNumber *serverT = nil;
    if (self.serverType) {
        serverT = @(self.serverType);
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请选择服务类型"];
        return;
    }
    
    NSString *serverItem = nil;
    if (self.orderArray.count > 0) {
        NSMutableString *serverItemString = [@"" mutableCopy];
        for (LXServiceProjectModel *model in self.orderArray) {
            [serverItemString appendString:[NSString stringWithFormat:@"%@,", model.goodsId]];
        }
        serverItem = [serverItemString substringToIndex:serverItemString.length - 1];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请选择服务项目"];
        return;
    }
    
   
   
   if(self.nameString.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    
    if(self.phoneString.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入电话"];
        return;
    }
    
    NSString *careObject = nil;
    if (self.careID) {
        careObject = self.careID;
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请选择照护对象"];
        return;
    }
    
    NSString *repeatWeek = nil;
    NSMutableString *serTime = nil;
    if ([self.timeArray count] > 0) {
        repeatWeek = self.repeatLString;
        serTime = [@"" mutableCopy];
        
        for (NSString *tempString in self.timeArray) {
            if ([self.repeatLString isEqualToString:@"一周"]) {
                [serTime appendString:[NSString stringWithFormat:@"%@,",tempString]];
            }
            else if ([self.repeatLString isEqualToString:@"两周"]) {
                NSDate *date = [NSDate dateWithString:tempString format:@"yyyy-MM-dd HH:mm"];
                
                for (int i = 0; i < 2; i ++) {
                    NSDate *date1 = [NSDate dateWithTimeInterval:7 * 24 * 60 * 60 * (i + 1) sinceDate:date];
                    NSString *string1 = [date1 stringWithFormat:@"yyyy-MM-dd HH:mm"];
                    
                    [serTime appendString:[NSString stringWithFormat:@"%@,",string1]];
                }
            }
            else if ([self.repeatLString isEqualToString:@"三周"]) {
                NSDate *date = [NSDate dateWithString:tempString format:@"yyyy-MM-dd HH:mm"];
                
                for (int i = 0; i < 3; i ++) {
                    NSDate *date1 = [NSDate dateWithTimeInterval:7 * 24 * 60 * 60 * (i + 1) sinceDate:date];
                    NSString *string1 = [date1 stringWithFormat:@"yyyy-MM-dd HH:mm"];
                    
                    [serTime appendString:[NSString stringWithFormat:@"%@,",string1]];
                }
            }
            else if ([self.repeatLString isEqualToString:@"四周"]) {
                NSDate *date = [NSDate dateWithString:tempString format:@"yyyy-MM-dd HH:mm"];
                
                for (int i = 0; i < 4; i ++) {
                    NSDate *date1 = [NSDate dateWithTimeInterval:7 * 24 * 60 * 60 * (i + 1) sinceDate:date];
                    NSString *string1 = [date1 stringWithFormat:@"yyyy-MM-dd HH:mm"];
                    
                    [serTime appendString:[NSString stringWithFormat:@"%@,",string1]];
                }
            }
        }
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请选择预约时间"];
        return;
    }
    
    LXLog(@"Time%@", [serTime substringFromIndex:serTime.length - 1]);
    
    if(self.addressString.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
        return;
    }
    
    if(self.remarkString.length<=0){
        self.remarkString = @"";
    }
    
    NSNumber *orderPrice = nil;
    NSNumber *goodsPrice= nil;
    if (self.totalPrice) {
        orderPrice = @(self.totalPrice);
        goodsPrice = @(self.totalPrice);
    }
    
    NSDictionary *dictP = @{ @"servType":serverT,
                             @"servItem":serverItem,
                             @"contactUser":_nameString,
                             @"contactPhone":_phoneString,
                             @"careObj":careObject,
                             @"servTime":serTime,
                             @"repeatWeek":repeatWeek,
                             @"address":_addressString,
                             @"otherContent":_remarkString,
                             @"orderPrice":orderPrice,
                             @"goodsPrice":goodsPrice};

    [self.viewModel setUpReservationWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
           
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}

#pragma mark - NSNotification

- (void)handleNotification:(NSNotification *)notification {
    if([notification.name isEqualToString:SVProgressHUDDidReceiveTouchEventNotification]){
        [SVProgressHUD dismiss];
    }
}


#pragma mark - Update

- (void)updateView {
    [self congfigreView];
    
    self.selectCareL.text = self.careName;
    [self.tableView reloadData];
}


#pragma mark - Getter

- (LXConfirmOrderView *)confirmView {
    if (!_confirmView) {
        LXWeakSelf(self);
        
        _confirmView = [[LXConfirmOrderView alloc] initWithDetailBlock:^{
            [weakself.view bringSubviewToFront:weakself.confirmView];
        } confirmBlock:^{
            [weakself setUpReservation];
        }];
        
        [_confirmView setFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - 50, LXScreenWidth, 50)];
    }
    return _confirmView;
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
        
        //_tableView.allowsMultipleSelection = YES;
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
        [section1 addObject:@"服务类型1"];
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
    }
    return _orderArray;
}

@end
