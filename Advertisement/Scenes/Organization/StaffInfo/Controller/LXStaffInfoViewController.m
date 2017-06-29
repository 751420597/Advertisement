//
//  LXStaffInfoViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/10.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXStaffInfoViewController.h"

#import "CWStarRateView.h"

#import "LXStaffInfoModel.h"
#import "LXStaffInfoViewModel.h"

#import "LXStaffInfoVCTableViewCell.h"


static NSString *const LXStaffInfoVCTableViewCellID = @"LXStaffInfoVCTableViewCellID";

@interface LXStaffInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIImageView *avatarIamgeview;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *sexualL;
@property (nonatomic, strong) CWStarRateView *starView;

@property (nonatomic, strong) UILabel *workingYearsL;
@property (nonatomic, strong) UILabel *identityCardL;
@property (nonatomic, strong) UILabel *remarkL;

@property (nonatomic, strong) LXStaffInfoViewModel *viewModel;
@property (nonatomic, strong) LXStaffInfoModel *siModel;

@end

@implementation LXStaffInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"护理员信息";
    [self.view setBackgroundColor:LXVCBackgroundColor];
    
    [self.view addSubview:self.tableView];
    
    [self getServieceData];
}


#pragma mark - Service 

- (void)getServieceData {
    self.viewModel = [LXStaffInfoViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{@"cw_user_id":self.cw_user_id};
    
    [self.viewModel getStaffInfoWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSDictionary *tDict = result[@"careWorkers"];
            
            self.siModel = [LXStaffInfoModel modelWithDictionary:tDict];
            
            NSArray *commentArray = result[@"cwEvList"];
            NSMutableArray *seciton1 = [NSMutableArray array];
            [seciton1 addObject:@"用户评价"];
            for (NSDictionary *tempDict in commentArray) {
                LXStaffCommentModel *scModel = [LXStaffCommentModel modelWithDictionary:tempDict];
                [seciton1 addObject:scModel];
            }
            
            [self.dataSource addObject:seciton1];
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    void (^commonBlock)(NSInteger, UITableViewCell *) = ^(NSInteger tempHeight, UITableViewCell *myCell) {
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, tempHeight)];
        [leftLine setBackgroundColor:LXCellBorderColor];
        [myCell.contentView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(LXScreenWidth - 1 - 20, 0, 1, tempHeight)];
        [rightLine setBackgroundColor:LXCellBorderColor];
        [myCell.contentView addSubview:rightLine];
    };
    
    LXWeakSelf(self);
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Section0Row0"];
            commonBlock(90, cell);
            
            self.avatarIamgeview = [[UIImageView alloc] init];
            
            NSString *requestString = [NSString stringWithFormat:@"%@%@", GetImage, self.siModel.avatarImageId];
            [self.avatarIamgeview sd_setImageWithURL:[NSURL URLWithString:requestString] placeholderImage:[UIImage imageNamed:@"Mine_male"]];
            [cell.contentView addSubview:self.avatarIamgeview];
            [self.avatarIamgeview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView).mas_equalTo(10);
                make.centerY.mas_equalTo(cell.contentView);
                make.width.mas_equalTo(70);
                make.height.mas_equalTo(70);
            }];
            
            self.nameL = [[UILabel alloc] init];
            [self.nameL setFont:[UIFont systemFontOfSize:15]];
            [self.nameL setTextColor:LXColorHex(0xcbcccd)];
            [self.nameL setText:self.siModel.userName];
            [cell.contentView addSubview:self.nameL];
            [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(weakself.avatarIamgeview.mas_trailing).mas_equalTo(12);
                make.top.mas_equalTo(cell.contentView).mas_equalTo(16);
            }];
            
            self.sexualL = [[UILabel alloc] init];
            [self.sexualL setFont:[UIFont systemFontOfSize:15]];
            [self.sexualL setTextColor:LXColorHex(0x4c4c4c)];
            [self.sexualL setText:[NSString stringWithFormat:@"性别：%@", self.siModel.sex]];
            [cell.contentView addSubview:self.sexualL];
            [self.sexualL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(weakself.avatarIamgeview.mas_trailing).mas_equalTo(12);
                make.bottom.mas_equalTo(cell.contentView).mas_equalTo(-16);
            }];
            
            self.starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(LXScreenWidth - 20 - 100, 20, 80, 25) numberOfStars:5];
            self.starView.scorePercent = self.siModel.overallMerit.integerValue;
            self.starView.allowIncompleteStar = YES;
            self.starView.hasAnimation = NO;
            [cell.contentView addSubview:self.starView];
            
            return cell;
        }
        else if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Section0Row1"];
            commonBlock(45, cell);
            
            UIView *myView = [[UIView alloc] init];
            [myView setBackgroundColor:LXMainColor];
            [cell.contentView addSubview:myView];
            [myView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(3);
                make.centerY.mas_equalTo(cell.contentView);
                make.leading.mas_equalTo(cell.contentView).mas_equalTo(12);
            }];
            
            UILabel *baseInfo = [[UILabel alloc] init];
            [baseInfo setFont:[UIFont systemFontOfSize:15]];
            [baseInfo setTextColor:LXColorHex(0x4c4c4c)];
            [baseInfo setText:@"基本信息"];
            [cell.contentView addSubview:baseInfo];
            [baseInfo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(myView.mas_trailing).mas_equalTo(5);
                make.centerY.mas_equalTo(cell.contentView);
            }];
            
            return cell;
        }
        else if (indexPath.row == 2) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Section0Row2"];
             commonBlock(92, cell);
            
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setBackgroundImage:[UIImage imageNamed:@"Organizaiton_working_years"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(15);
                make.leading.mas_equalTo(cell.contentView).mas_equalTo(10);
                make.top.mas_equalTo(cell.contentView).mas_equalTo(14);
            }];
            
            self.workingYearsL = [[UILabel alloc] init];
            [self.workingYearsL setFont:[UIFont systemFontOfSize:14]];
            [self.workingYearsL setTextColor:LXColorHex(0x4c4c4c)];
            [self.workingYearsL setText:[NSString stringWithFormat:@"工作经验：%@", self.siModel.workYears]];
            [cell.contentView addSubview:self.workingYearsL];
            [self.workingYearsL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(btn1.mas_trailing).mas_equalTo(10);
                make.centerY.mas_equalTo(btn1);
            }];
            
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"Organization_identity_card"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn2];
            [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(15);
                make.leading.mas_equalTo(cell.contentView).mas_equalTo(10);
                make.top.mas_equalTo(btn1.mas_bottom).mas_equalTo(10);
            }];
            
            self.identityCardL = [[UILabel alloc] init];
            [self.identityCardL setFont:[UIFont systemFontOfSize:14]];
            [self.identityCardL setTextColor:LXColorHex(0x4c4c4c)];
            
            NSString *cardString = [NSString stringWithFormat:@"%@", self.siModel.certNo];
            NSString *subString = [cardString substringToIndex:cardString.length - 6];
            NSString *tralingString = [cardString substringFromIndex:cardString.length - 2];
            NSString *replaceString = [NSString stringWithFormat:@"%@%@%@", subString,@"****", tralingString];
            [self.identityCardL setText:[NSString stringWithFormat:@"身份证号码：%@", replaceString]];
            
            [cell.contentView addSubview:self.identityCardL];
            [self.identityCardL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(btn2.mas_trailing).mas_equalTo(10);
                make.centerY.mas_equalTo(btn2);
            }];
            
            UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn3 setBackgroundImage:[UIImage imageNamed:@"Organizaiton_remak"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn3];
            [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(15);
                make.leading.mas_equalTo(cell.contentView).mas_equalTo(10);
                make.top.mas_equalTo(btn2.mas_bottom).mas_equalTo(10);
            }];
            
            self.remarkL = [[UILabel alloc] init];
            [self.remarkL setFont:[UIFont systemFontOfSize:14]];
            [self.remarkL setTextColor:LXColorHex(0x4c4c4c)];
            [self.remarkL setText:@"具有基本生活护理经验"];
            [cell.contentView addSubview:self.remarkL];
            [self.remarkL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(btn3.mas_trailing).mas_equalTo(10);
                make.centerY.mas_equalTo(btn3);
            }];
            
            return cell;
        }
    }
    else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Section1Row2"];
             commonBlock(45, cell);
            
            UIView *myView = [[UIView alloc] init];
            [myView setBackgroundColor:LXMainColor];
            [cell.contentView addSubview:myView];
            [myView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(3);
                make.centerY.mas_equalTo(cell.contentView);
                make.leading.mas_equalTo(cell.contentView).mas_equalTo(12);
            }];
            
            UILabel *baseInfo = [[UILabel alloc] init];
            [baseInfo setFont:[UIFont systemFontOfSize:15]];
            [baseInfo setTextColor:LXColorHex(0x4c4c4c)];
            [baseInfo setText:[NSString stringWithFormat:@"用户评价（%lu）", (unsigned long)[self.dataSource[1] count]]];
            [cell.contentView addSubview:baseInfo];
            [baseInfo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(myView.mas_trailing).mas_equalTo(5);
                make.centerY.mas_equalTo(cell.contentView);
            }];
            
            return cell;
        }
        else {
            LXStaffInfoVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXStaffInfoVCTableViewCellID];
            
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LXStaffInfoVCTableViewCell" owner:self options:nil] firstObject];
                commonBlock(53, cell);
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.commentModel = self.dataSource[1][indexPath.row];
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
        if ([tempString isEqualToString:@"护理员信息"]) {
            return 90;
        }
        else if ([tempString isEqualToString:@"基本信息"]) {
            return 45;
        }
        else if ([tempString isEqualToString:@"详细信息"]) {
            return 92;
        }
    }
    else {
        if (indexPath.row == 0) {
            return 45;
        }
        else {
            return 53;
        }
    }
    
    return 0;
}

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSMutableArray *seciton0 = [NSMutableArray array];
        [seciton0 addObject:@"护理员信息"];
        [seciton0 addObject:@"基本信息"];
        [seciton0 addObject:@"详细信息"];
        
        [_dataSource addObject:seciton0];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, LXScreenWidth - 10 * 2, LXScreenHeight - LXNavigaitonBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        //[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableFooterView = [UIView new];
        [_tableView setBackgroundColor:LXVCBackgroundColor];
        
        _tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
        _tableView.sectionFooterHeight = 10;
        _tableView.sectionFooterHeight = 0;
        
        [_tableView lx_setViewCornerRadius:5 borderColor:nil borderWidth:0];
    }
    return _tableView;
}


@end
