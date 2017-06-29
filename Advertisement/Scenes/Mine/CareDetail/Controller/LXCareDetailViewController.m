//
//  LXAddCareViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXCareDetailViewController.h"

#import "LXCareDetailVCTableViewCell.h"
#import "LXAddCareVCTableViewCell2.h"
#import "LXAddCareVCTableViewCell1.h"

#import "LXBarthelViewController.h"
#import "LXSelectOrganizationViewController.h"
#import "LXConfirmLevelViewController.h"
#import "LXConfirmInfoViewController.h"

#import "LXCareDetailModel.h"
#import "LXCareDetailViewModel.h"


@interface LXCareDetailViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *addressTF;

@property (nonatomic, strong) UISwitch *switch1;
@property (nonatomic, strong) LXCareDetailModel *careDetailModel;
@property (nonatomic, strong) LXCareDetailViewModel *viewModel;

@property (nonatomic, assign) BOOL isSetInfo;

@end


@implementation LXCareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"照护对象详情";
    self.view.backgroundColor = LXVCBackgroundColor;

    [self setUpTable];
    
    self.isSetInfo = YES;
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXCareDetailViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{@"careId":self.careId};
    
    [self.viewModel getCareDetailWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            self.careDetailModel = [LXCareDetailModel modelWithDictionary:result];
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - Set Up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - LXNavigaitonBarHeight - 10) style:UITableViewStyleGrouped backgroundColor:LXVCBackgroundColor];
    self.tableView.sectionFooterHeight = 20;
    self.tableView.sectionHeaderHeight = 20;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    NSMutableArray *section0 = [NSMutableArray array];
    [section0 addObject:@"姓名"];
    [section0 addObject:@"性别"];
    [section0 addObject:@"出生日期"];
    [section0 addObject:@"服务地址"];
    [section0 addObject:@"Barthel评定表"];
    [section0 addObject:@"选择护理机构"];
    
    NSMutableArray *section1 = [NSMutableArray array];
    [section1 addObject:@"是否已通过长护险待遇评定"];
    
    if (self.isSetInfo) {
         [section1 addObject:@"信息认证"];
    }
    else {
         [section1 addObject:@"等级认证"];
    }
    
    
    NSMutableArray *section2 = [NSMutableArray array];
    [section2 addObject:@"申请长护险待遇通过用户，可享受长护险待遇。"];
    [section2 addObject:@"申请长护险通过后期限为1年，1年后重新提交申请。"];
    [section2 addObject:@"未申请通过长护险待遇用户，不可享受长护险待遇。"];
    [section2 addObject:@"更换机构，需要机构审核。"];
    
    [self.dataSource addObject:section0];
    [self.dataSource addObject:section1];
    [self.dataSource addObject:section2];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cutomArray = [self.dataSource[indexPath.section] copy];
    NSString *leadingString = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton0row3"];
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:75 color:LXCellBorderColor cell:cell];
            
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:LXColorHex(0x4c4c4c)];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(20);
                make.top.mas_equalTo(cell.contentView).mas_offset(10);
            }];
            
            self.addressTF = [[UITextField alloc] init];
            
            if (self.careDetailModel.address) {
                [self.addressTF setText:self.careDetailModel.address];
            }
            
            self.addressTF.delegate = self;
            self.addressTF.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:self.addressTF];
            [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-10);
                make.leading.mas_equalTo(cell.contentView).mas_offset(100);
                make.centerY.mas_equalTo(cell.contentView);
            }];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton0row0"];
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:LXColorHex(0x4c4c4c)];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(20);
                make.centerY.mas_equalTo(cell.contentView);
            }];
            
            self.nameTF = [[UITextField alloc] init];
            
            if (self.careDetailModel.careName) {
                [self.nameTF setText:self.careDetailModel.careName];
            }
            
    
            self.nameTF.delegate = self;
            self.nameTF.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:self.nameTF];
            [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-10);
                make.leading.mas_equalTo(cell.contentView).mas_offset(100);
                make.centerY.mas_equalTo(cell.contentView);
            }];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else {
            LXAddCareVCTableViewCell1 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXAddCareVCTableViewCell1" owner:self options:nil].firstObject;
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            
            cell.leadingL.text = leadingString;
            
            cell.btnWidth.constant = 0;
            
            if (indexPath.row == 1) {
                if ([self.careDetailModel.sexCode isEqualToString:@"1"]) {
                    cell.trailingL.text = @"男";
                }
                else if ([self.careDetailModel.sexCode isEqualToString:@"2"]) {
                    cell.trailingL.text = @"女";
                }
            }
            else if (indexPath.row == 2) {
                
                cell.trailingL.text = self.careDetailModel.birthday;
            }
            else if (indexPath.row == 4) {
                cell.trailingL.text = self.careDetailModel.barthel;
            }
            else if (indexPath.row == 5) {
                cell.trailingL.text = self.careDetailModel.agencyName;
            }
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton1row1"];
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:LXColorHex(0x4c4c4c)];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(20);
                make.centerY.mas_equalTo(cell.contentView);
            }];
            
            self.switch1 = [[UISwitch alloc] init];
            
            if (self.isSetInfo) {
                self.switch1.on = YES;
            }
            else {
                self.switch1.on = NO;
            }
            
            [self.switch1 addTarget:self action:@selector(switchValue) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:self.switch1];
            [self.switch1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-10);
                make.centerY.mas_equalTo(cell.contentView);
            }];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else {
            LXAddCareVCTableViewCell1 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXAddCareVCTableViewCell1" owner:self options:nil].firstObject;
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            
            cell.leadingL.text = leadingString;
            cell.trailingL.text = @"去认证";
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        LXAddCareVCTableViewCell2 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXAddCareVCTableViewCell2" owner:self options:nil].firstObject;
        
        [cell.contentView setBackgroundColor:LXVCBackgroundColor];
        
        cell.leadingLa.text = leadingString;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 30;
    }
    
    NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
    if ([tempString isEqualToString:@"服务地址"]) {
        return 75;
    }
    else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 2) {
        NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
        
        if (!([tempString isEqualToString:@"是否已通过长护险待遇评定"] || [tempString isEqualToString:@"等级认证"] || [tempString isEqualToString:@"信息认证"])) {
            UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [starBtn setBackgroundImage:[UIImage imageNamed:@"Mine_care_add"] forState:UIControlStateNormal];
            [cell.contentView addSubview:starBtn];
            [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(10);
                make.height.mas_equalTo(10);
                make.leading.mas_equalTo(cell.contentView).mas_equalTo(8);
                make.centerY.mas_equalTo(cell.contentView);
            }];
        }
    }
}


#pragma mark - Aciton

- (void)switchValue {
    if (self.switch1.isOn) {
        self.careDetailModel.ifPass = @"1";
        self.isSetInfo = YES;
    }
    else {
        self.careDetailModel.ifPass = @"2";
        self.isSetInfo = NO;
    }
    
    [self updateView];
}


#pragma mark - Update

- (void)updateData {
    NSMutableArray *section0 = [NSMutableArray array];
    [section0 addObject:@"姓名"];
    [section0 addObject:@"性别"];
    [section0 addObject:@"出生日期"];
    [section0 addObject:@"服务地址"];
    [section0 addObject:@"Barthel评定表"];
    [section0 addObject:@"选择护理机构"];
    
    NSMutableArray *section1 = [NSMutableArray array];
    [section1 addObject:@"是否已通过长护险待遇评定"];
    if (self.isSetInfo) {
        [section1 addObject:@"信息认证"];
    }
    else {
        [section1 addObject:@"等级认证"];
    }
    
    
    NSMutableArray *section2 = [NSMutableArray array];
    [section2 addObject:@"申请长护险待遇通过用户，可享受长护险待遇。"];
    [section2 addObject:@"申请长护险通过后期限为1年，1年后重新提交申请。"];
    [section2 addObject:@"未申请通过长护险待遇用户，不可享受长护险待遇。"];
    [section2 addObject:@"更换机构，需要机构审核。"];
    
    [self.dataSource addObject:section0];
    [self.dataSource addObject:section1];
    [self.dataSource addObject:section2];
}

- (void)updateView {
    [self.dataSource removeAllObjects];
    [self updateData];
    [self.tableView reloadData];
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
    
    if ([tempString isEqualToString:@"性别"]) {
        
    }
    else if ([tempString isEqualToString:@"出生日期"]) {
    }
    else if ([tempString isEqualToString:@"Barthel评定表"]) {
        LXBarthelViewController *bVC = [LXBarthelViewController new];
        [self.navigationController pushViewController:bVC animated:YES];
    }
    else if ([tempString isEqualToString:@"选择护理机构"]) {
        LXSelectOrganizationViewController *sVC = [LXSelectOrganizationViewController new];
        [self.navigationController pushViewController:sVC animated:YES];
    }
    else if ([tempString isEqualToString:@"信息认证"]) {
        LXConfirmInfoViewController *sVC = [LXConfirmInfoViewController new];
        [self.navigationController pushViewController:sVC animated:YES];
    }
    else if ([tempString isEqualToString:@"等级认证"]) {
        LXConfirmLevelViewController *sVC = [LXConfirmLevelViewController new];
        [self.navigationController pushViewController:sVC animated:YES];
    }
}

@end
