//
//  LXAddCareViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXAddCareViewController.h"

#import "LXAddCareVCTableViewCell1.h"
#import "LXAddCareVCTableViewCell2.h"

#import "LXBarthelViewController.h"
#import "LXSelectOrganizationViewController.h"
#import "LXConfirmLevelViewController.h"
#import "LXConfirmInfoViewController.h"

#import "LXAddCareViewModel.h"
#import "LXAddCareModel.h"

static NSString *const LXAddCareVCTableViewCellID = @"LXAddCareVCTableViewCellID";
static CGFloat const LXBGViewHeight = 246.f;

@interface LXAddCareViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *trailingArray;

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *addressTF;

@property (nonatomic, strong) UISwitch *switch1;
@property (nonatomic, assign) BOOL isSetInfo;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy  ) NSString *birthday;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *myConfirmBtn;

@property (nonatomic, strong) LXAddCareViewModel *viewModel;
@property (nonatomic, strong) LXAddCareModel *addCareModel;

@end


@implementation LXAddCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加照护对象";
    self.view.backgroundColor = LXVCBackgroundColor;
    self.birthday = @"1990-1-1";
    
    self.isSetInfo = YES;
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpaceBarButtonItem.width = -10;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myConfirmBtn];
    barButtonItem.width = 10;
    self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    
    self.addCareModel = [LXAddCareModel new];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setUpTable];
}


#pragma mark - Set Up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - LXNavigaitonBarHeight - 10) style:UITableViewStyleGrouped backgroundColor:LXVCBackgroundColor];
    self.tableView.sectionFooterHeight = 20;
    self.tableView.sectionHeaderHeight = 20;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (self.careId) {
        [self setUpUnpassView];
    }
    
    [self updateData];
    [self.view addSubview:self.tableView];
}

- (void)setUpUnpassView {
    
}

#pragma mark - Update

- (void)updateData {
    [self.dataSource removeAllObjects];
    [self.trailingArray removeAllObjects];
    NSMutableArray *section0 = [NSMutableArray array];
    [section0 addObject:@"姓名"];
    [section0 addObject:@"性别"];
    [section0 addObject:@"出生日期"];
    [section0 addObject:@"服务地址"];
    [section0 addObject:@"Barthel评定表"];
    
    NSMutableArray *section1 = [NSMutableArray array];
    [section1 addObject:@"选择护理机构"];
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
    
    self.trailingArray = [NSMutableArray array];
    NSMutableArray *section00 = [NSMutableArray array];
    
    if (self.addCareModel.name) {
        [section00 addObject:self.addCareModel.name];
    }
    else {
        [section00 addObject:@"姓名"];
    }
    
    if ([self.addCareModel.sexCode isEqualToString:@"1"] ) {
        [section00 addObject:@"男"];
    }
    else if ([self.addCareModel.sexCode isEqualToString:@"2"]) {
        [section00 addObject:@"女"];
    }
    else {
        [section00 addObject:@"性别"];
    }
    
    if (self.addCareModel.birthday) {
        [section00 addObject:self.addCareModel.birthday];
    }
    else {
        [section00 addObject:@"出生日期"];
    }
    
    if (self.addCareModel.address) {
        [section00 addObject:self.addCareModel.address];
    }
    else {
        [section00 addObject:@"服务地址"];
    }
    
    if (self.addCareModel.barthelDescription) {
        [section00 addObject:self.addCareModel.barthelDescription];
    }
    else {
        [section00 addObject:@"Barthel评定表"];
    }
    
    
    NSMutableArray *section11 = [NSMutableArray array];
    if (self.addCareModel.agencyId) {
        [section11 addObject:self.addCareModel.organizationDescription];
    }
    else {
        [section11 addObject:@"选择护理机构"];
    }
    
    [section11 addObject:@"是否已通过长护险待遇评定"];
    [section11 addObject:@"去认证"];
    
    
    NSMutableArray *section22 = [NSMutableArray array];
    [section22 addObject:@"申请长护险待遇通过用户，可享受长护险待遇。"];
    [section22 addObject:@"申请长护险通过后期限为1年，1年后重新提交申请。"];
    [section22 addObject:@"未申请通过长护险待遇用户，不可享受长护险待遇。"];
    [section22 addObject:@"更换机构，需要机构审核。"];
    
    [self.trailingArray addObject:section00];
    [self.trailingArray addObject:section11];
    [self.trailingArray addObject:section22];
}

- (void)updateView {
   
    [self updateData];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld,%ld",indexPath.section, indexPath.row);
    NSArray *cutomArray = [self.dataSource[indexPath.section] copy];
    NSString *leadingString = self.dataSource[indexPath.section][indexPath.row];
    NSString *trailingString= nil;
    trailingString = self.trailingArray[indexPath.section][indexPath.row];
    
   
    
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
            
            if (self.addCareModel.address) {
                [self.addressTF setText:self.addCareModel.address];
            }
            else {
                self.addressTF.placeholder = @"请输入地址";
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
            
            if (self.addCareModel.name) {
                [self.nameTF setText:self.addCareModel.name];
            }
            else {
                self.nameTF.placeholder = @"请输入姓名";
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
            cell.trailingL.text = trailingString;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton1row1"];
            
             [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:LXColorHex(0x4c4c4c)];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(20);
                make.top.mas_equalTo(cell.contentView).mas_offset(10);
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
            cell.trailingL.text = trailingString;
            
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
    
    if ([tempString isEqualToString:@"性别"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[@"男", @"女"];
        
        [self addActionTarget:alertController titles:titles];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([tempString isEqualToString:@"出生日期"]) {
        [self.view addSubview:self.bgView];
    }
    else if ([tempString isEqualToString:@"Barthel评定表"]) {
        LXBarthelViewController *bVC = [LXBarthelViewController new];
        
        LXWeakSelf(self);
        bVC.barthelBlock = ^(NSDictionary *itemArray, NSString *barthelLevel) {
            NSMutableString *barthelItem = [NSMutableString string];
            NSMutableString *barthelScorce = [NSMutableString string];
            
            if (itemArray.count > 0) {
                NSArray *item = itemArray.allKeys;
                NSArray *scorce = itemArray.allValues;
                
                for (int i = 0; i < itemArray.count; i++) {
                    [barthelItem appendString:[NSString stringWithFormat:@"%@,", item[i]]];
                    [barthelScorce appendString:[NSString stringWithFormat:@"%@,", scorce[i]]];
                }
            }
            
            weakself.addCareModel.barthelItem = [barthelItem substringToIndex:barthelItem.length - 1];
            weakself.addCareModel.barthelScore = [barthelScorce substringToIndex:barthelScorce.length -1];
            weakself.addCareModel.barthelDescription = barthelLevel;
            
            [weakself setUpTable];
        };
        
        [self.navigationController pushViewController:bVC animated:YES];
    }
    else if ([tempString isEqualToString:@"选择护理机构"]) {
        LXSelectOrganizationViewController *sVC = [LXSelectOrganizationViewController new];
        
        LXWeakSelf(self);
        sVC.selectOrganizationBlock = ^(LXOrganizaitonModel *model) {
            weakself.addCareModel.agencyId = model.corId;
            weakself.addCareModel.organizationDescription = model.corName;
            
            [weakself setUpTable];
        };
        
        [self.navigationController pushViewController:sVC animated:YES];
    }
    else if ([tempString isEqualToString:@"等级认证"]) {
        LXConfirmLevelViewController *sVC = [LXConfirmLevelViewController new];
        
        LXWeakSelf(self);
        sVC.levelBlock = ^(LXConfirmLevelModel *levelModel) {
            weakself.addCareModel.cardNo = levelModel.cardNo;
            weakself.addCareModel.personNatureId = levelModel.personNatureId;
            weakself.addCareModel.careTypeId = levelModel.careTypeId;
            weakself.addCareModel.images = levelModel.images;
            weakself.addCareModel.imageTypes = levelModel.imageTypes;
        };
        
        [self.navigationController pushViewController:sVC animated:YES];
    }
    else if ([tempString isEqualToString:@"信息认证"]) {
        LXConfirmInfoViewController *sVC = [LXConfirmInfoViewController new];
        
        LXWeakSelf(self)
        sVC.infoBlock = ^(LXConfirmInfoModel *confirmInfoModel) {
            weakself.addCareModel.cardNo = confirmInfoModel.cardNo;
            weakself.addCareModel.siCardNo = confirmInfoModel.siCardNo;
            weakself.addCareModel.computerNo = confirmInfoModel.computerNo;
            weakself.addCareModel.images = confirmInfoModel.images;
            weakself.addCareModel.imageTypes = confirmInfoModel.imageTypes;
        };
        
        [self.navigationController pushViewController:sVC animated:YES];
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


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.nameTF isEqual:textField]) {
        self.addCareModel.name = textField.text;
    }
    
    if ([self.addressTF isEqual:textField]) {
        self.addCareModel.address = textField.text;
    }
}


#pragma mak - Aciton

- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles {
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([title isEqualToString:@"男"]) {
                [self gotoSelectMale];
            }
            else if ([title isEqualToString:@"女"]) {
                [self gotoSelectFemale];
            }
        }];
        
        [alertController addAction:action];
    }
}

- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:action];
}


- (void)gotoSelectMale {
    self.addCareModel.sexCode = @"1";
    [self updateView];
}

- (void)gotoSelectFemale {
    self.addCareModel.sexCode = @"2";
    [self updateView];
}

- (void)switchValue {
    if (self.switch1.isOn) {
        self.addCareModel.ifPass = @"1";
        self.isSetInfo = YES;
    }
    else {
        self.addCareModel.ifPass = @"2";
        self.isSetInfo = NO;
    }
    
    [self updateView];
}

- (void)myConfirmBtnClick {
    self.viewModel = [LXAddCareViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    NSMutableDictionary *dictP = [NSMutableDictionary dictionary];
    
    if (self.addCareModel.userId) {
        [dictP setValue:self.addCareModel.userId forKey:@"userId"];
    }
    
    if (self.addCareModel.name) {
        [dictP setValue:self.addCareModel.name forKey:@"name"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    
    if (self.addCareModel.sexCode) {
        [dictP setValue:self.addCareModel.sexCode forKey:@"sexCode"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    
    if (self.addCareModel.birthday) {
        [dictP setValue:self.addCareModel.birthday forKey:@"birthday"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请选择出生日期"];
        return;
    }
    
    if (self.addCareModel.address) {
        [dictP setValue:self.addCareModel.address forKey:@"address"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
        return;
    }
    
    if (self.addCareModel.barthelItem) {
        [dictP setValue:self.addCareModel.barthelItem forKey:@"barthelItem"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请选择Barthel评定"];
        return;
    }
    
    if (self.addCareModel.barthelScore) {
        [dictP setValue:self.addCareModel.barthelScore forKey:@"barthelScore"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请选择Barthel评定"];
        return;
    }
    if (self.addCareModel.agencyId) {
        [dictP setValue:self.addCareModel.agencyId forKey:@"agencyId"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请选择指定服务机构"];
        
    }
    
    if ([self.addCareModel.ifPass isEqualToString:@"1"]) {
        
    }
    else {
        if (self.addCareModel.cardNo || self.addCareModel.personNatureId || self.addCareModel.careTypeId || self.addCareModel.images || self.addCareModel.imageTypes) {
            [dictP setValue:self.addCareModel.cardNo forKey:@"cardNo"];
            [dictP setValue:self.addCareModel.personNatureId forKey:@"personNatureId"];
            [dictP setValue:self.addCareModel.careTypeId forKey:@"careTypeId"];
            [dictP setValue:self.addCareModel.images forKey:@"imageIds"];
            [dictP setValue:self.addCareModel.imageTypes forKey:@"imageTypes"];
    
            [dictP setValue:self.addCareModel.ratingLeed forKey:@"1"];
        }
        else {
            [dictP setValue:self.addCareModel.ratingLeed forKey:@"0"];
        }
    }
    
    
    [self.viewModel addCareWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            if(self.reloadBlock){
                self.reloadBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - Aciton

- (void)confirmButtonClick:(id)sender {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *birthdayTime = [formatter stringFromDate:self.datePicker.date];
    self.addCareModel.birthday = birthdayTime;
    
    [self.bgView removeFromSuperview];
    [self updateView];
}

- (void)cancelButtonClick:(id)sender {
    [self.bgView removeFromSuperview];
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setFrame:CGRectMake(LXScreenWidth - 10 - 60, LXScreenHeight - LXNavigaitonBarHeight - LXBGViewHeight, 60, 30)];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:LXMainColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setFrame:CGRectMake(10, LXScreenHeight - LXNavigaitonBarHeight - LXBGViewHeight, 60, 30)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:LXMainColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - LXBGViewHeight + 30, LXScreenWidth, LXBGViewHeight - 30)];
        
//        NSDate *minDate =[self convertDateFromString:@"1896-01-01"];
//        NSDate *maxDate = [self convertDateFromString:@"2016-12-31"];
//        NSDate *dafaultData = [self convertDateFromString:self.birthday];
//        _datePicker.minimumDate = minDate;
//        _datePicker.maximumDate = maxDate;
//        _datePicker.date = dafaultData;
        
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
    }
    
    return _datePicker;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth,LXScreenHeight - LXNavigaitonBarHeight)];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - LXBGViewHeight, LXScreenWidth, LXBGViewHeight )];
        view1.backgroundColor = LXColorHex(0xEDEDED);
        [_bgView addSubview:view1];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - LXBGViewHeight + 29.5, LXScreenWidth, 0.5)];
        view2.backgroundColor = LXColorHex(0xD5D5D6);
        [_bgView addSubview:view2];
        
        [_bgView addSubview:self.confirmButton];
        [_bgView addSubview:self.cancelButton];
        [_bgView addSubview:self.datePicker];
    }
    
    return _bgView;
}

- (UIButton *)myConfirmBtn {
    if (!_myConfirmBtn) {
        _myConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myConfirmBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_myConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_myConfirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_myConfirmBtn setFrame:CGRectMake(0, 0, 40, 30)];
        [_myConfirmBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_myConfirmBtn addTarget:self action:@selector(myConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myConfirmBtn;
}


#pragma mark - Private method

- (NSDate *) convertDateFromString:(NSString *)uiDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    
    return date;
}


@end
