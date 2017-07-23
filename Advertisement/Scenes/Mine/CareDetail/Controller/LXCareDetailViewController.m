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
#import "LXAddCareViewModel.h"
#import "LXBarthelViewController.h"
#import "LXSelectOrganizationViewController.h"
#import "LXConfirmLevelViewController.h"
#import "LXConfirmInfoViewController.h"
#import "LXBarthelViewModel.h"
#import "LXCareDetailModel.h"
#import "LXCareDetailViewModel.h"
#import "CareDetailWornCell.h"
#import "MsgAuthenticationInfor.h"
#import "RatingLeedInfor.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "CareDetailBartherModel.h"
static CGFloat const LXBGViewHeight = 246.f;
@interface LXCareDetailViewController () <UITextFieldDelegate,MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
{
    BOOL enbleEidts;
    NSMutableArray *bartherArr;
}
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *addressTF;

@property (nonatomic, strong) UISwitch *switch1;
@property (nonatomic, strong) LXCareDetailModel *careDetailModel;
@property (nonatomic, strong) MsgAuthenticationInfor *msgAuInforModel;
@property (nonatomic, strong) RatingLeedInfor *ratingInforModel;
@property (nonatomic, strong) LXCareDetailViewModel *viewModel;
@property (nonatomic, strong) LXAddCareViewModel *viewModel2;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UIButton *myConfirmBtn;
@property (nonatomic, strong) LXBarthelViewModel*bartheViewModel;
@property (nonatomic, copy) NSMutableString *barthelItem;
@property (nonatomic, copy) NSMutableString *barthelScorce;
//@property (nonatomic, assign) BOOL isSetInfo;

@end


@implementation LXCareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barthelItem = [NSMutableString string];
    self. barthelScorce = [NSMutableString string];
    //self.navigationItem.title = @"照护对象详情";
    self.view.backgroundColor = LXVCBackgroundColor;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self setUpTable];
    
//    self.isSetInfo = YES;
    enbleEidts = YES;
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXCareDetailViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{@"careId":self.careId};
    
    [self.viewModel getCareDetailWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            self.careDetailModel = [LXCareDetailModel modelWithDictionary:result[@"careObjInfo"]];
            self.msgAuInforModel = [MsgAuthenticationInfor modelWithDictionary:result[@"msgAuthenticationInfo"]];
            self.ratingInforModel = [RatingLeedInfor modelWithDictionary:result[@"ratingLeedInfo"]];
            
            [self loadData];
            
            if([self.careDetailModel.sevenDays isEqualToString:@"1"]){
                enbleEidts  =YES;
                UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
                fixedSpaceBarButtonItem.width = -10;
                UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myConfirmBtn];
                barButtonItem.width = 10;
                self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
            }else{
                enbleEidts = NO;
            }

            
            if([self.checkStateId isEqualToString:@"3"]||[self.checkStateId isEqualToString:@"6"]||[self.checkStateId isEqualToString:@"8"]){
                enbleEidts  =YES;
                UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
                fixedSpaceBarButtonItem.width = -10;
                UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myConfirmBtn];
                barButtonItem.width = 10;
                self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];

            }else{
                enbleEidts  =NO;
                
            }

            
//            enbleEidts  =YES;
//            UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
//            fixedSpaceBarButtonItem.width = -10;
//            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myConfirmBtn];
//            barButtonItem.width = 10;
//            self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
            
            [self.tableView reloadData];
            
            
        }
        else {
            self.tableView.userInteractionEnabled = NO;
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
    
}
-(void)loadData{
    self.bartheViewModel = [LXBarthelViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    NSMutableString *barthelItem = [NSMutableString string];
    NSMutableString *barthelScorce = [NSMutableString string];
    [self.bartheViewModel getCareDetailBarthelLevelWithParameters:@{@"careObjId":self.careId} completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *arr = result[@"bCumList"];
            bartherArr =[NSMutableArray array];
            for (NSDictionary *dic in arr) {
                CareDetailBartherModel *bartherModel =[[CareDetailBartherModel alloc]careDetailBartherModelWithDic:dic];
                [barthelItem appendString:[NSString stringWithFormat:@"%@,", bartherModel.evaItem]];
                [barthelScorce appendString:[NSString stringWithFormat:@"%@,", bartherModel.bgList.firstObject[@"evaItemVal"]]];
                [bartherArr addObject:bartherModel];
            }
            self.barthelItem = barthelItem;
            self.barthelScorce = barthelScorce;
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - Set Up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - LXNavigaitonBarHeight - 10) style:UITableViewStyleGrouped backgroundColor:LXVCBackgroundColor];
    self.tableView.sectionFooterHeight = 10;
    self.tableView.sectionHeaderHeight = 10;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(!_isPass){
        NSMutableArray *section_00 = [NSMutableArray array];
        [section_00 addObject:@"审核未通过"];
        [self.dataSource addObject:section_00];
    }
    
    
    NSMutableArray *section0 = [NSMutableArray array];
    [section0 addObject:@"姓名"];
    [section0 addObject:@"性别"];
    [section0 addObject:@"出生日期"];
    [section0 addObject:@"服务地址"];
    [section0 addObject:@"Barthel评定表"];
    [section0 addObject:@"选择护理机构"];
    
    NSMutableArray *section1 = [NSMutableArray array];
    [section1 addObject:@"是否已通过长护险待遇评定"];
    
    if ([self.msgAuInforModel.ifPass isEqualToString:@"1"]) {
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
    if(!_isPass){
        if (indexPath.section == 0) {
            static NSString *ident = @"cell_0";
            CareDetailWornCell *cell  = [tableView dequeueReusableCellWithIdentifier:ident];
            if(!cell){
                cell = [[CareDetailWornCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
               
            }
            
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:60 color:LXCellBorderColor cell:cell];
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:[UIColor redColor]];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(20);
                make.top.mas_equalTo(cell.contentView).mas_offset(10);
            }];
            
            UILabel *label11 = [[UILabel alloc] init];
            [label11 setFont:[UIFont systemFontOfSize:14]];
            [label11 setTextColor:LXColorHex(0x4c4c4c)];
            [label11 setText:@"原因：您所提交的审核资料不齐全。"];
            [cell.contentView addSubview:label11];
            [label11 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(20);
                make.top.mas_equalTo(label1).mas_offset(23);
            }];

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else if (indexPath.section == 1) {
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
                    make.centerY.mas_equalTo(cell.contentView);
                }];
                
                self.addressTF = [[UITextField alloc] init];
                self.addressTF.font =[UIFont systemFontOfSize:14.f];
                if (self.careDetailModel.address) {
                    [self.addressTF setText:self.careDetailModel.address];
                }
                self.addressTF.enabled = enbleEidts;
                self.addressTF.delegate = self;
                self.addressTF.textAlignment = NSTextAlignmentLeft;
                self.addressTF.returnKeyType = UIReturnKeyDefault;
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
                self.nameTF.enabled = enbleEidts;
                if (self.careDetailModel.name) {
                    [self.nameTF setText:self.careDetailModel.name];
                }
                
                self.nameTF.returnKeyType = UIReturnKeyDefault;
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
                    cell.btnWidth.constant = 10;
                    cell.trailingL.text = self.careDetailModel.barthelTotScore;
                }
                else if (indexPath.row == 5) {
                    if(enbleEidts){
                        cell.btnWidth.constant = 10;
                    }
                    if(self.careDetailModel.corChkState.length>0){
                        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",self.careDetailModel.corChkState,self.careDetailModel.agencyName]];
                        //设置字体和设置字体的范围
                        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(self.careDetailModel.corChkState.length, self.careDetailModel.agencyName.length+2)];
                        cell.trailingL.attributedText =attrStr;
                    }else{
                        cell.trailingL.text = self.careDetailModel.agencyName;

                    }
                   
                }
                
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
        else if (indexPath.section == 2) {
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
                
//                            if (self.isSetInfo) {
//                                self.switch1.on = YES;
//                            }
//                            else {
//                                self.switch1.on = NO;
//                            }
                
                [self.switch1 addTarget:self action:@selector(switchValue) forControlEvents:UIControlEventValueChanged];
                if([self.msgAuInforModel.ifPass isEqualToString:@"1"]){
                    self.switch1.on = YES;
                }else{
                    self.switch1.on = NO;
                }
                self.switch1.userInteractionEnabled = enbleEidts;;
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
                if ([self.msgAuInforModel.ifPass isEqualToString:@"1"]) {
                    cell.leadingL.text =@"信息认证";
                }
                else {
                    cell.leadingL.text = @"等级认证";
                }
                
                cell.trailingL.text = @"去认证";
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
        else if (indexPath.section == 3) {
            LXAddCareVCTableViewCell2 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXAddCareVCTableViewCell2" owner:self options:nil].firstObject;
            
            [cell.contentView setBackgroundColor:LXVCBackgroundColor];
            
            cell.leadingLa.text = leadingString;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }

    }else{
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
                self.addressTF.enabled = enbleEidts;
                if (self.careDetailModel.address) {
                    [self.addressTF setText:self.careDetailModel.address];
                }
                
                self.addressTF.delegate = self;
                self.addressTF.textAlignment = NSTextAlignmentLeft;
                self.addressTF.returnKeyType = UIReturnKeyDefault;
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
                self.nameTF.enabled = enbleEidts;
                if (self.careDetailModel.name) {
                    [self.nameTF setText:self.careDetailModel.name];
                }
                
                self.nameTF.returnKeyType = UIReturnKeyDefault;
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
                    cell.btnWidth.constant = 10;
                    cell.trailingL.text = self.careDetailModel.barthelTotScore;
                }
                else if (indexPath.row == 5) {
                    if(enbleEidts){
                        cell.btnWidth.constant = 10;
                    }
                    
                    if(self.careDetailModel.corChkState.length>0){
                        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",self.careDetailModel.corChkState,self.careDetailModel.agencyName]];
                        //设置字体和设置字体的范围
                        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5f] range:NSMakeRange(self.careDetailModel.corChkState.length, self.careDetailModel.agencyName.length+2)];
                        cell.trailingL.attributedText =attrStr;
                    }else{
                        cell.trailingL.text = self.careDetailModel.agencyName;
                        
                    }
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
                
                //            if (self.isSetInfo) {
                //                self.switch1.on = YES;
                //            }
                //            else {
                //                self.switch1.on = NO;
                //            }
                
                [self.switch1 addTarget:self action:@selector(switchValue) forControlEvents:UIControlEventValueChanged];
                if([self.msgAuInforModel.ifPass isEqualToString:@"1"]){
                    self.switch1.on = YES;
                }else{
                    self.switch1.on = NO;
                }
                self.switch1.userInteractionEnabled = enbleEidts;
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
                if ([self.msgAuInforModel.ifPass isEqualToString:@"1"]) {
                    cell.leadingL.text =@"信息认证";
                }
                else {
                    cell.leadingL.text = @"等级认证";
                }
                
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

    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isPass){
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

    }else{
        if(indexPath.section==0){
            return 60;
        }
        if (indexPath.section == 3) {
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
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isPass){
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
    }else{
        if (indexPath.section ==1) {
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
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.nameTF isEqual:textField]) {
        self.careDetailModel.name = textField.text;
    }
    
    if ([self.addressTF isEqual:textField]) {
        if(![textField.text isEqualToString:self.careDetailModel.address]){
            self.careDetailModel.address = textField.text;
            AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc]init];
            request.address = textField.text;
            [self.search AMapGeocodeSearch:request];
        }
        
    }

}
/* 理编码回调. */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }else{
        
        //判断是否为空
        if (response) {
            
            //取出搜索到的POI（POI：Point Of Interest）
            AMapGeocode *geo=  response.geocodes.firstObject;
            self.careDetailModel.longitude = [NSString stringWithFormat:@"%.4f",geo.location.longitude];
            self.careDetailModel.atitude = [NSString stringWithFormat:@"%.4f",geo.location.latitude];
            self.careDetailModel.addrId = @"";
        }
        
        
    }
}

//#pragma mark - Aciton

- (void)switchValue {
    if (self.switch1.isOn) {
        self.msgAuInforModel.ifPass = @"1";
        //self.isSetInfo = YES;
    }
    else {
        self.msgAuInforModel.ifPass = @"0";
        //self.isSetInfo = NO;
    }
    
    [self updateView];
}


#pragma mark - Update

- (void)updateData {
    
    if(!_isPass){
        NSMutableArray *section_00 = [NSMutableArray array];
        [section_00 addObject:@"审核未通过"];
        [self.dataSource addObject:section_00];
    }
    NSMutableArray *section0 = [NSMutableArray array];
    [section0 addObject:@"姓名"];
    [section0 addObject:@"性别"];
    [section0 addObject:@"出生日期"];
    [section0 addObject:@"服务地址"];
    [section0 addObject:@"Barthel评定表"];
    [section0 addObject:@"选择护理机构"];
    
    NSMutableArray *section1 = [NSMutableArray array];
    [section1 addObject:@"是否已通过长护险待遇评定"];
    if ([self.msgAuInforModel.ifPass isEqualToString:@"1"]) {
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
    
    if(!_isPass){
        if(indexPath.section==1){
            if (indexPath.row==4) {
                if (bartherArr.count==0) {
                    return;
                }
                LXBarthelViewController *bVC = [[LXBarthelViewController alloc]init];
                bVC.bartherLevelArr = bartherArr;
                bVC.isDetail = YES;
                bVC.enbleEidts = enbleEidts;
                LXWeakSelf(self);
                bVC.barthelBlock = ^(NSDictionary *itemArray, long barthel) {
                    NSMutableString *barthelItem = [NSMutableString string];
                    NSMutableString *barthelScorce = [NSMutableString string];

                    if (itemArray.count > 0) {
                        NSArray *item = itemArray.allKeys;
                        NSArray *scorce = itemArray.allValues;
                        
                        for (int i = 0; i < itemArray.count; i++) {
                            [weakself.barthelItem appendString:[NSString stringWithFormat:@"%@,", item[i]]];
                            [weakself.barthelScorce appendString:[NSString stringWithFormat:@"%@,", scorce[i]]];
                        }
                    }
                    //barthelModel =barthel;
                    NSLog(@"%@",weakself.barthelItem);
                    NSLog(@"%@",weakself.barthelScorce);
                    weakself.barthelItem = barthelItem;
                    weakself.barthelScorce = barthelScorce;
                    //weakself.addCareModel.barthelDescription = barthelModel.barLevel;
                    weakself.careDetailModel.barthelTotScore = [NSString stringWithFormat:@"%ld",barthel];
                    [weakself.tableView reloadData];

                };
                [self.navigationController pushViewController:bVC animated:YES];
            }
            else if (indexPath.row==5) {
                if(!enbleEidts){
                    return;
                }
                LXSelectOrganizationViewController *sVC = [LXSelectOrganizationViewController new];
                sVC.enbleEidts = enbleEidts;
                if(self.careDetailModel.longitude==nil||self.careDetailModel.atitude==nil){
                    self.careDetailModel.longitude = @"";
                    self.careDetailModel.atitude = @"";
                }
                sVC.params = @{@"longitude":self.careDetailModel.longitude,@"latitude":self.careDetailModel.atitude};
                LXWeakSelf(self);
                sVC.selectOrganizationBlock = ^(LXOrganizaitonModel *model) {
                    weakself.careDetailModel.agencyId = model.corId;
                    weakself.careDetailModel.agencyName = model.corName;
                    weakself.careDetailModel.corChkState = @"";
                    [weakself setUpTable];
                };

                [self.navigationController pushViewController:sVC animated:YES];
            }else if (indexPath.row==1){
                    if(!enbleEidts){
                            return;
                    }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                NSArray *titles = @[@"男", @"女"];
                
                for (NSString *title in titles) {
                    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        if ([title isEqualToString:@"男"]) {
                            self.careDetailModel.sexCode = @"1";
                        }
                        else if ([title isEqualToString:@"女"]) {
                            self.careDetailModel.sexCode = @"2";
                        }
                        [self.tableView reloadData];
                    }];
                    
                    [alertController addAction:action];
                }

                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                [alertController addAction:cancle];
                [self presentViewController:alertController animated:YES completion:nil];
            }else if (indexPath.row==2){
                if(!enbleEidts){
                    return;
                }
                [self.view addSubview:self.bgView];
            }
        }else if (indexPath.section==2){
            if(indexPath.row==1){
                if ([self.msgAuInforModel.ifPass isEqualToString:@"1"]) {
                    LXConfirmInfoViewController *sVC = [LXConfirmInfoViewController new];
                    sVC.infoBlock = ^(LXConfirmInfoModel *confirmInfoModel) {
                        
                        self.msgAuInforModel.name = confirmInfoModel.name;
                        self.msgAuInforModel.acNo = confirmInfoModel.acNo;
                        self.msgAuInforModel.siCardNo = confirmInfoModel.siCardNo;
                        self.msgAuInforModel.computerNo = confirmInfoModel.computerNo;
                        self.msgAuInforModel.msgImageIds = confirmInfoModel.images;
                        self.msgAuInforModel.msgImageTypes = confirmInfoModel.imageTypes;
                    };
                    sVC.enableEdit =enbleEidts;
                    self.msgAuInforModel.name = self.careDetailModel.name;
                    sVC.msgAuthenModel = self.msgAuInforModel;
                    [self.navigationController pushViewController:sVC animated:YES];
                }else{
                    LXConfirmLevelViewController *sVC = [LXConfirmLevelViewController new];
                    sVC.levelBlock = ^(LXConfirmLevelModel *levelModel) {
                        self.ratingInforModel.ratingLeed = @"1";
                        self.ratingInforModel.cardNo = levelModel.cardNo;
                        self.ratingInforModel.personNatureId = levelModel.personNatureId;
                        self.ratingInforModel.careTypeId = levelModel.careTypeId;
                        self.ratingInforModel.raImageIds = levelModel.images;
                        self.ratingInforModel.raImageTypes = levelModel.imageTypes;
                        self.ratingInforModel.siCardNo = levelModel.siCardNo;
                        
                        self.ratingInforModel.livingCareType = levelModel.livingCare;
                        self.ratingInforModel.serviceType = levelModel.serviceType;
                        self.ratingInforModel.presentAddress = levelModel.presentAddress;
                        self.ratingInforModel.careContactPhone = levelModel.careContactPhone;
                        self.ratingInforModel.mcName = levelModel.mcName;
                        self.ratingInforModel.mcRela = levelModel.mcRela;
                        self.ratingInforModel.mcPhone = levelModel.mcPhone;
                        self.ratingInforModel.msAddress = levelModel.msAddress;
                        self.ratingInforModel.dmTypeId = levelModel.dmTypeId;
                    };
                    sVC.enableEdits = enbleEidts;
                    sVC.ratingModel = self.ratingInforModel;
                    
                    [self.navigationController pushViewController:sVC animated:YES];
                }
                
            }
        }
    }else{
        if(indexPath.section==0){
            if (indexPath.row==4) {
                if (bartherArr.count==0) {
                    return;
                }
                LXBarthelViewController *bVC = [[LXBarthelViewController alloc]init];
                LXWeakSelf(self)
                bVC.barthelBlock = ^(NSDictionary *itemArray, long barthel) {
                    NSMutableString *barthelItem = [NSMutableString string];
                     NSMutableString *barthelScorce = [NSMutableString string];
                    if (itemArray.count > 0) {
                        NSArray *item = itemArray.allKeys;
                        NSArray *scorce = itemArray.allValues;
                        
                        for (int i = 0; i < itemArray.count; i++) {
                            [barthelItem appendString:[NSString stringWithFormat:@"%@,",item[i]]];
                            [barthelScorce appendString:[NSString stringWithFormat:@"%@,", scorce[i]]];
                        }
                    }
                    //barthelModel =barthel;
                    NSLog(@"%@",barthelItem);
                    NSLog(@"%@",barthelScorce);
                    weakself.barthelItem = barthelItem;
                    weakself.barthelScorce = barthelScorce;
                    //weakself.addCareModel.barthelDescription = barthelModel.barLevel;
                    weakself.careDetailModel.barthelTotScore = [NSString stringWithFormat:@"%ld",barthel];
                    [weakself.tableView reloadData];

                };
                bVC.bartherLevelArr = bartherArr;
                bVC.isDetail = YES;
                bVC.enbleEidts = enbleEidts;
                [self.navigationController pushViewController:bVC animated:YES];
            }
            else if (indexPath.row==5) {
                if(!enbleEidts){
                    return;
                }
                LXSelectOrganizationViewController *sVC = [LXSelectOrganizationViewController new];
                sVC.enbleEidts = enbleEidts;
                if(self.careDetailModel.longitude==nil||self.careDetailModel.atitude==nil){
                    self.careDetailModel.longitude = @"";
                    self.careDetailModel.atitude = @"";
                }
                sVC.params = @{@"longitude":self.careDetailModel.longitude,@"latitude":self.careDetailModel.atitude};
                LXWeakSelf(self);
                sVC.selectOrganizationBlock = ^(LXOrganizaitonModel *model) {
                    weakself.careDetailModel.agencyId = model.corId;
                    weakself.careDetailModel.agencyName = model.corName;
                    weakself.careDetailModel.corChkState = @"";
                    [weakself setUpTable];
                };
                [self.navigationController pushViewController:sVC animated:YES];
            }else if (indexPath.row==1){
                if(!enbleEidts){
                    return;
                }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                NSArray *titles = @[@"男", @"女"];
                
                for (NSString *title in titles) {
                    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        if ([title isEqualToString:@"男"]) {
                            self.careDetailModel.sexCode = @"1";
                        }
                        else if ([title isEqualToString:@"女"]) {
                            self.careDetailModel.sexCode = @"2";
                        }
                        [self.tableView reloadData];
                    }];
                    
                    [alertController addAction:action];
                }
                
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                [alertController addAction:cancle];
                [self presentViewController:alertController animated:YES completion:nil];
            }else if (indexPath.row==2){
                if(!enbleEidts){
                    return;
                }
                [self.view addSubview:self.bgView];
            }
        }else if (indexPath.section==1){
            if(indexPath.row==1){
                if ([self.msgAuInforModel.ifPass isEqualToString:@"1"]) {
                    LXConfirmInfoViewController *sVC = [LXConfirmInfoViewController new];
                    sVC.infoBlock = ^(LXConfirmInfoModel *confirmInfoModel) {
                        self.msgAuInforModel.name = confirmInfoModel.name;
                        self.msgAuInforModel.acNo = confirmInfoModel.acNo;
                        self.msgAuInforModel.siCardNo = confirmInfoModel.siCardNo;
                        self.msgAuInforModel.computerNo = confirmInfoModel.computerNo;
                        self.msgAuInforModel.msgImageIds = confirmInfoModel.images;
                        self.msgAuInforModel.msgImageTypes = confirmInfoModel.imageTypes;
                    };
                    sVC.enableEdit =enbleEidts;
                    self.msgAuInforModel.name = self.careDetailModel.name;
                    sVC.msgAuthenModel = self.msgAuInforModel;
                    [self.navigationController pushViewController:sVC animated:YES];
                }else{
                    LXConfirmLevelViewController *sVC = [LXConfirmLevelViewController new];
                    sVC.levelBlock = ^(LXConfirmLevelModel *levelModel) {
                        self.ratingInforModel.ratingLeed = @"1";
                        self.ratingInforModel.cardNo = levelModel.cardNo;
                        self.ratingInforModel.personNatureId = levelModel.personNatureId;
                        self.ratingInforModel.careTypeId = levelModel.careTypeId;
                        self.ratingInforModel.raImageIds = levelModel.images;
                        self.ratingInforModel.raImageTypes = levelModel.imageTypes;
                        self.ratingInforModel.siCardNo = levelModel.siCardNo;
                        
                        self.ratingInforModel.livingCareType = levelModel.livingCare;
                        self.ratingInforModel.serviceType = levelModel.serviceType;
                        self.ratingInforModel.presentAddress = levelModel.presentAddress;
                        self.ratingInforModel.careContactPhone = levelModel.careContactPhone;
                        self.ratingInforModel.mcName = levelModel.mcName;
                        self.ratingInforModel.mcRela = levelModel.mcRela;
                        self.ratingInforModel.mcPhone = levelModel.mcPhone;
                        self.ratingInforModel.msAddress = levelModel.msAddress;
                        self.ratingInforModel.dmTypeId = levelModel.dmTypeId;
                    };
                    sVC.enableEdits =enbleEidts;
                    sVC.ratingModel = self.ratingInforModel;
                    [self.navigationController pushViewController:sVC animated:YES];
                }
                
            }
        }
    }
    
}

- (void)myConfirmBtnClick {
    self.viewModel2 = [LXAddCareViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    NSMutableDictionary *dictP = [NSMutableDictionary dictionary];
    [dictP setValue:self.careId forKey:@"careObjId"];
    if (self.careDetailModel.name.length>0) {
        [dictP setValue:self.careDetailModel.name forKey:@"name"];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
        return;
    }
    
    if (self.careDetailModel.sexCode.length>0) {
        [dictP setValue:self.careDetailModel.sexCode forKey:@"sexCode"];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择性别"];
        return;
    }
    
    if (self.careDetailModel.birthday.length>0) {
        [dictP setValue:self.careDetailModel.birthday forKey:@"birthday"];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择出生日期"];
        return;
    }
    
    if (self.careDetailModel.address.length>0) {
        
        if(self.careDetailModel.longitude.length<=0||self.careDetailModel.atitude.length<=0){
            self.careDetailModel.longitude = @"";
            self.careDetailModel.atitude = @"";
        }
        [dictP setValue:self.careDetailModel.address forKey:@"address"];
        [dictP setValue:self.careDetailModel.longitude forKey:@"longitude"];
        [dictP setValue:self.careDetailModel.atitude forKey:@"atitude"];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请输入地址"];
        return;
    }
    
    //weakself.barthelScorce = ;
    if (self.barthelItem.length>0) {
        [dictP setValue:[self.barthelItem substringToIndex:self.barthelItem.length - 1] forKey:@"barthelItem"];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择Barthel评定"];
        return;
    }
    
    if (self.careDetailModel.barthelTotScore.length>0&&self.barthelScorce.length>0) {
        
        [dictP setValue:[self.barthelScorce substringToIndex:self.barthelScorce.length -1] forKey:@"barthelScore"];
        [dictP setValue:self.careDetailModel.barthelTotScore forKey:@"barthelTotScore"];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择Barthel评定"];
        return;
    }
    if (self.careDetailModel.agencyId.length>0) {
        [dictP setValue:self.careDetailModel.agencyId forKey:@"agencyId"];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择指定服务机构"];
        return;
        
    }
    [dictP setValue:self.careDetailModel.addrId forKey:@"addrId"];
    
    [dictP setValue:self.msgAuInforModel.ifPass forKey:@"ifPass"];
    [dictP setValue:self.ratingInforModel.ratingLeed forKey:@"ratingLeed"];
    
    
    if (self.ratingInforModel.cardNo==nil) {
        self.ratingInforModel.cardNo = @"";
    }
    if (self.ratingInforModel.personNatureId==nil) {
        self.ratingInforModel.personNatureId = @"";
    }
    if (self.ratingInforModel.careTypeId==nil) {
        self.ratingInforModel.careTypeId = @"";
    }
    if (self.ratingInforModel.raImageIds.length<2) {
        self.ratingInforModel.raImageIds = @" ";
    }
    if (self.ratingInforModel.raImageTypes.length<2) {
        self.ratingInforModel.raImageTypes = @" ";
    }
   
        [dictP setValue:self.ratingInforModel.cardNo forKey:@"cardNo"];
        [dictP setValue:self.ratingInforModel.personNatureId forKey:@"personNatureId"];
        [dictP setValue:self.ratingInforModel.careTypeId forKey:@"careTypeId"];
        [dictP setValue:self.ratingInforModel.raImageIds forKey:@"raImageIds"];
        [dictP setValue:self.ratingInforModel.raImageTypes forKey:@"raImageTypes"];
    

    if (self.ratingInforModel.livingCareType==nil) {
        self.ratingInforModel.livingCareType = @"";
    }
    if (self.ratingInforModel.serviceType==nil) {
        self.ratingInforModel.serviceType = @"";
    }
    if (self.ratingInforModel.presentAddress==nil) {
        self.ratingInforModel.presentAddress = @"";
    }
    if (self.ratingInforModel.careContactPhone==nil) {
        self.ratingInforModel.careContactPhone = @"";
    }
    if (self.ratingInforModel.mcName==nil) {
        self.ratingInforModel.mcName = @"";
    }
    if (self.ratingInforModel.mcRela==nil) {
        self.ratingInforModel.mcRela = @"";
    }
    if (self.ratingInforModel.mcPhone==nil) {
        self.ratingInforModel.mcPhone = @"";
    }
    if (self.ratingInforModel.msAddress==nil) {
        self.ratingInforModel.msAddress = @"";
    }
    if (self.ratingInforModel.dmTypeId==nil) {
        self.ratingInforModel.dmTypeId = @"";
    }
    
    
        [dictP setValue:self.ratingInforModel.livingCareType forKey:@"livingCareType"];
        [dictP setValue:self.ratingInforModel.serviceType forKey:@"serviceType"];
        [dictP setValue:self.ratingInforModel.presentAddress forKey:@"presentAddress"];
        [dictP setValue:self.ratingInforModel.careContactPhone forKey:@"careContactPhone"];
        [dictP setValue:self.ratingInforModel.mcName forKey:@"mcName"];
        [dictP setValue:self.ratingInforModel.mcRela forKey:@"mcRela"];
        [dictP setValue:self.ratingInforModel.mcPhone forKey:@"mcPhone"];
        [dictP setValue:self.ratingInforModel.msAddress forKey:@"msAddress"];
        [dictP setValue:self.ratingInforModel.dmTypeId forKey:@"dmTypeId"];
   
    if (self.msgAuInforModel.acNo==nil) {
        self.msgAuInforModel.acNo = @"";
    }if (self.msgAuInforModel.computerNo==nil) {
        self.msgAuInforModel.computerNo = @"";
    }if (self.msgAuInforModel.msgImageIds==nil) {
        self.msgAuInforModel.msgImageIds = @"";
    }if (self.msgAuInforModel.msgImageTypes==nil) {
        self.msgAuInforModel.msgImageTypes = @"";
    }

    
        [dictP setValue:self.msgAuInforModel.acNo forKey:@"acNo"];
        [dictP setValue:self.msgAuInforModel.computerNo forKey:@"computerNo"];
        [dictP setValue:self.msgAuInforModel.msgImageIds forKey:@"msgImageIds"];
        [dictP setValue:self.msgAuInforModel.msgImageTypes forKey:@"msgImageTypes"];
    
    if (self.ratingInforModel.siCardNo==nil) {
        self.ratingInforModel.siCardNo = @"";
    }
    
    if (self.msgAuInforModel.siCardNo==nil) {
        self.msgAuInforModel.siCardNo = @"";
    }
    if (self.careDetailModel.siCardNo==nil) {
        self.careDetailModel.siCardNo = @"";
    }
    if(self.careDetailModel.siCardNo.length>1){
        [dictP setValue:self.careDetailModel.siCardNo forKey:@"siCardNo"];
    }else if(self.ratingInforModel.siCardNo.length>1){
        [dictP setValue:self.ratingInforModel.siCardNo forKey:@"siCardNo"];
    }else {
        [dictP setValue:self.msgAuInforModel.siCardNo forKey:@"siCardNo"];
    }
    [self.viewModel2 upDataCareWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            if(self.reloadBlock){
                self.reloadBlock();
            }
            [SVProgressHUD showInfoWithStatus:@"您的申请已成功提交，审核结果7-15天后通知您，请耐心等待"];
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
    self.careDetailModel.birthday = birthdayTime;
    
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
                NSDate *dafaultData = [self convertDateFromString:self.careDetailModel.birthday];
        //        _datePicker.minimumDate = minDate;
        //        _datePicker.maximumDate = maxDate;
                _datePicker.date = dafaultData;
        
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
        [_myConfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_myConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_myConfirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_myConfirmBtn setFrame:CGRectMake(0, 0, 40, 30)];
        [_myConfirmBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_myConfirmBtn addTarget:self action:@selector(myConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myConfirmBtn;
}
- (NSDate *) convertDateFromString:(NSString *)uiDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    
    return date;
}
@end
