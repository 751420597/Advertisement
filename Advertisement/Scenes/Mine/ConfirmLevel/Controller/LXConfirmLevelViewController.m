//
//  LXConfirmLevelViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXConfirmLevelViewController.h"

#import "LXConfirmLevelVCTableViewCell1.h"
#import "LXConfirmLevelVCTableViewCell2.h"
#import "LXAddCareVCTableViewCell2.h"

#import "LXConfirmLevelModel.h"

// Pictrue
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

#import "LXSandBox.h"
#import "LXJudge.h"
#define NUM @"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"
#define NUM2 @"0123456789"
@interface LXConfirmLevelViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *lable1;
@property (nonatomic, strong) UILabel *lable2;
@property (nonatomic, strong) UILabel *lable3;
@property (nonatomic, strong) UILabel *lable4;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *ageTF;
@property (nonatomic, strong) UITextField *identifyTF;
@property (nonatomic, strong) UITextField *socialTF;
@property (nonatomic, strong) UITextField *mcNameTF;
@property (nonatomic, strong) UITextField *mcRelaTF;
@property (nonatomic, strong) UITextField *mcPhoneTF;
@property (nonatomic, strong) UITextField *msAddresTF;

@property (nonatomic, strong) UIButton *leftUploadBtn;
@property (nonatomic, strong) UIButton *rightUploadBtn;
@property (nonatomic, strong) UIButton *leftBottomUploadBtn1;
@property (nonatomic, strong) UIButton *leftBottomUploadBtn2;
@property (nonatomic, strong) UIButton *leftBottomUploadBtn3;
@property (nonatomic, strong) UIButton *leftBottomUploadBtn4;
@property (nonatomic, strong) UIButton *leftBottomUploadBtn5;
@property (nonatomic, strong) UIButton *leftBottomUploadBtn6;
@property (nonatomic, strong) UIButton *heardImgBT;

@property (nonatomic, strong) LXConfirmLevelModel *confirmLevelModel;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *rightImage;
@property (nonatomic, strong) UIImage *bottomImage;
@property (nonatomic, strong) UIImage *heardImage;

@property (nonatomic, copy) NSString *leftImageID;
@property (nonatomic, copy) NSString *rightImageID;
@property (nonatomic, copy) NSString *bottomeImageID1;
@property (nonatomic, copy) NSString *bottomeImageID2;
@property (nonatomic, copy) NSString *bottomeImageID3;
@property (nonatomic, copy) NSString *bottomeImageID4;
@property (nonatomic, copy) NSString *bottomeImageID5;
@property (nonatomic, copy) NSString *bottomeImageID6;

@property (nonatomic, copy) NSString *heardImgID;
@property (nonatomic, copy) NSMutableArray *heardImgIDArr;

@property (nonatomic, assign) NSInteger type; // 1:左边，2:右边，3，下边

@property (nonatomic, strong) UIButton *myConfirmBtn1;
@property(nonatomic ,strong) UIScrollView *scrollView;
@end



@implementation LXConfirmLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"等级认证";
    self.view.backgroundColor = LXVCBackgroundColor;
    if(_enableEdits){
        UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedSpaceBarButtonItem.width = -10;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myConfirmBtn1];
        barButtonItem.width = 10;
        self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    }
    
    self.heardImgIDArr = [NSMutableArray array];
    self.confirmLevelModel = [LXConfirmLevelModel new];
    if(self.ratingModel){
        NSArray *raImageIdsArr = [self.ratingModel.raImageIds componentsSeparatedByString:@","];
        switch (raImageIdsArr.count) {
            case 5:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                break;
            case 6:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                break;
            case 7:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                self.bottomeImageID3 = raImageIdsArr[5];

                break;
            case 8:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                self.bottomeImageID3 = raImageIdsArr[5];
                self.bottomeImageID4 = raImageIdsArr[6];
                break;
            case 9:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                self.bottomeImageID3 = raImageIdsArr[5];
                self.bottomeImageID4 = raImageIdsArr[6];
                self.bottomeImageID5 = raImageIdsArr[7];
                break;
            case 10:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                self.bottomeImageID3 = raImageIdsArr[5];
                self.bottomeImageID4 = raImageIdsArr[6];
                self.bottomeImageID5 = raImageIdsArr[7];
                self.bottomeImageID6 = raImageIdsArr[8];
                break;
                
            default:
                break;
        }
        self.confirmLevelModel.personNatureId = self.ratingModel.personNatureId;
        self.confirmLevelModel.livingCare = self.ratingModel.livingCareType;
        self.confirmLevelModel.careTypeId = self.ratingModel.careTypeId;
        self.confirmLevelModel.serviceType = self.ratingModel.serviceType;
        self.confirmLevelModel.presentAddress = self.ratingModel.presentAddress;
        self.confirmLevelModel.careContactPhone = self.ratingModel.careContactPhone;
        self.confirmLevelModel.mcName = self.ratingModel.mcName;
        self.confirmLevelModel.mcRela = self.ratingModel.mcRela;
        self.confirmLevelModel.mcPhone = self.ratingModel.mcPhone;
        self.confirmLevelModel.msAddress = self.ratingModel.msAddress;
        self.confirmLevelModel.dmTypeId = self.ratingModel.dmTypeId;
        self.confirmLevelModel.siCardNo = self.ratingModel.siCardNo;
        
    }
    
    if(self.levelModel){
        self.confirmLevelModel =self.levelModel;
        NSArray *raImageIdsArr = [self.confirmLevelModel.images componentsSeparatedByString:@","];
        switch (raImageIdsArr.count) {
            case 5:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                break;
            case 6:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                break;
            case 7:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                self.bottomeImageID3 = raImageIdsArr[5];
                
                break;
            case 8:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                self.bottomeImageID3 = raImageIdsArr[5];
                self.bottomeImageID4 = raImageIdsArr[6];
                break;
            case 9:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                self.bottomeImageID3 = raImageIdsArr[5];
                self.bottomeImageID4 = raImageIdsArr[6];
                self.bottomeImageID5 = raImageIdsArr[7];
                break;
            case 10:
                self.leftImageID = raImageIdsArr[0];
                self.rightImageID = raImageIdsArr[1];
                self.heardImgID = raImageIdsArr[2];
                self.bottomeImageID1 = raImageIdsArr[3];
                self.bottomeImageID2 = raImageIdsArr[4];
                self.bottomeImageID3 = raImageIdsArr[5];
                self.bottomeImageID4 = raImageIdsArr[6];
                self.bottomeImageID5 = raImageIdsArr[7];
                self.bottomeImageID6 = raImageIdsArr[8];
                break;
                
            default:
                break;
                
                
        }

    }
    [self setUpTable];
}


#pragma mark - Set Up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - LXNavigaitonBarHeight - 10) style:UITableViewStyleGrouped backgroundColor:LXVCBackgroundColor];
    self.tableView.sectionFooterHeight = 0;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self updateData];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - Update

- (void)updateData {
    NSMutableArray *section00 = [NSMutableArray array];
    [section00 addObject:@"人员类别"];
    [section00 addObject:@"待遇类别"];
    [section00 addObject:@"待遇类型"];
    [section00 addObject:@"评估类别"];
    [section00 addObject:@"现住址"];
    [section00 addObject:@"联系电话"];
    [section00 addObject:@"社会保障卡号"];
    [section00 addObject:@"免冠照片(清晰近照)"];
    [section00 addObject:@"诊断照片(最多可传6张)"];
    [section00 addObject:@"代理人姓名"];
    [section00 addObject:@"关系"];
    [section00 addObject:@"联系电话"];
    [section00 addObject:@"联系地址(邮寄地址)"];
    [section00 addObject:@"送达方式"];
    
    NSMutableArray *section11 = [NSMutableArray array];
    [section11 addObject:@"承诺:以上情况及所提供资料真实有效，并且同意将评定评估结果在一定范围内公示。如果提供虚假资料或瞒报漏报的，将按相关法律规定承担相应责任。"];
    [section11 addObject:@"待遇等级认证，填入信息后机构初筛。通过提交医保局复审"];
    [section11 addObject:@"审核未通过前不可享受长护险政策"];
    
    [self.dataSource addObject:section00];
    [self.dataSource addObject:section11];
}

- (void)updateView {
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
    NSArray *cutomArray = [self.dataSource[indexPath.section] copy];
    NSString *leadingString = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 6) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton0row3"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:150 color:LXCellBorderColor cell:cell];
            
            LXWeakSelf(self);
            
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:LXColorHex(0x4c4c4c)];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(10);
                make.top.mas_equalTo(cell.contentView).mas_offset(10);
                make.height.mas_equalTo(30);
            }];
            
            self.socialTF = [[UITextField alloc] init];
            [self.socialTF setFont:[UIFont systemFontOfSize:14]];
            [self.socialTF setTextColor:LXColorHex(0x4c4c4c)];
            self.socialTF.userInteractionEnabled = _enableEdits;
            if (self.confirmLevelModel.siCardNo) {
                [self.socialTF setText:self.confirmLevelModel.siCardNo];
            }
            else {
                [self.socialTF setPlaceholder:@"请输入社保卡号"];
            }
            
            self.socialTF.delegate = self;
            [cell.contentView addSubview:self.socialTF];
            [self.socialTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-15);
                make.centerY.mas_equalTo(label1);
            }];
            
            self.leftUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *requestString = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.leftImageID];
            [self.leftUploadBtn sd_setImageWithURL:[NSURL URLWithString:requestString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.leftUploadBtn addTarget:self action:@selector(leftUploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
            self.leftUploadBtn.userInteractionEnabled = _enableEdits;
            [cell.contentView addSubview:self.leftUploadBtn];
            [self.leftUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(30);
                make.top.mas_equalTo(label1.mas_bottom).mas_equalTo(10);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
            }];
            _lable1 =[[UILabel alloc]init];
            _lable1.text = @"社会保障卡正面照";
            _lable1.textAlignment = NSTextAlignmentCenter;
            _lable1.font = [UIFont systemFontOfSize:14.f];
            _lable1.textColor =  [UIColor lightGrayColor];
            [self.leftUploadBtn addSubview:_lable1];
            [_lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.leftUploadBtn).mas_offset(0);
                make.bottom.mas_equalTo(self.leftUploadBtn).mas_offset(-10);
                make.width.mas_equalTo(self.leftUploadBtn);
            }];
            
            
            self.rightUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *requestString2 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.rightImageID];
            [self.rightUploadBtn sd_setImageWithURL:[NSURL URLWithString:requestString2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.rightUploadBtn addTarget:self action:@selector(rightUploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
            self.rightUploadBtn.userInteractionEnabled = _enableEdits;
            [cell.contentView addSubview:self.rightUploadBtn];
            [self.rightUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(weakself.leftUploadBtn.mas_trailing).mas_offset(20);
                make.top.mas_equalTo(label1.mas_bottom).mas_equalTo(10);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
                make.trailing.mas_equalTo(cell.contentView).mas_equalTo(-20);
                make.width.mas_equalTo(weakself.leftUploadBtn);
            }];
            
           
            self.lable3 =[[UILabel alloc]init];
            _lable3.text = @"社会保障卡背面照";
            _lable3.textAlignment = NSTextAlignmentCenter;
            _lable3.font = [UIFont systemFontOfSize:14.f];
            _lable3.textColor =  [UIColor lightGrayColor];
            [self.rightUploadBtn addSubview:_lable3];
            [_lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.rightUploadBtn).mas_offset(0);
                make.bottom.mas_equalTo(self.rightUploadBtn).mas_offset(-10);
                make.width.mas_equalTo(self.rightUploadBtn);
            }];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 7) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton0row3"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:150 color:LXCellBorderColor cell:cell];
            
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:LXColorHex(0x4c4c4c)];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(10);
                make.top.mas_equalTo(cell.contentView).mas_offset(10);
                make.height.mas_equalTo(30);
            }];
            
            
            self.heardImgBT = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.heardImgID];
            [self.heardImgBT sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.heardImgBT addTarget:self action:@selector(heradImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
            self.heardImgBT.userInteractionEnabled = _enableEdits;
            [cell.contentView addSubview:self.heardImgBT];
            [self.heardImgBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(30);
                make.top.mas_equalTo(label1.mas_bottom).mas_equalTo(10);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
                make.width.mas_equalTo(135);
            }];
            
            self.lable4 =[[UILabel alloc]init];
            _lable4.text = @"免冠照片";
            _lable4.textAlignment = NSTextAlignmentCenter;
            _lable4.font = [UIFont systemFontOfSize:14.f];
            _lable4.textColor =  [UIColor lightGrayColor];
            [self.heardImgBT addSubview:_lable4];
            [_lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.heardImgBT).mas_offset(0);
                make.bottom.mas_equalTo(self.heardImgBT).mas_offset(-10);
                make.width.mas_equalTo(self.heardImgBT);
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 8) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton0row3"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:150 color:LXCellBorderColor cell:cell];
            
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:LXColorHex(0x4c4c4c)];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(10);
                make.top.mas_equalTo(cell.contentView).mas_offset(10);
                make.height.mas_equalTo(30);
            }];
            
            _scrollView =[[UIScrollView alloc] initWithFrame:CGRectZero];
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.backgroundColor =[UIColor clearColor];
            _scrollView.scrollEnabled = YES;//控制是否可以滚动
            _scrollView.userInteractionEnabled = YES;
            _scrollView.panGestureRecognizer.delaysTouchesBegan = YES;
            [cell.contentView addSubview:_scrollView];
            _scrollView.frame = CGRectMake(30, 50, LXScreenWidth-30-15, 100);

            if(_enableEdits){
                _scrollView.contentSize = CGSizeMake(155*6, 100);
            }else{
                int count = 0;
                if(self.bottomeImageID1.length>0){
                    count ++;
                }if(self.bottomeImageID2.length>0){
                    count ++;
                }if(self.bottomeImageID3.length>0){
                    count ++;
                }if(self.bottomeImageID4.length>0){
                    count ++;
                }if(self.bottomeImageID5.length>0){
                    count ++;
                }if(self.bottomeImageID6.length>0){
                    count ++;
                }
                 _scrollView.contentSize = CGSizeMake(155*count, 100);
            }
            //photo1
            self.leftBottomUploadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID1];
            [self.leftBottomUploadBtn1 sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.leftBottomUploadBtn1 addTarget:self action:@selector(leftBottomUploadBtnClick1) forControlEvents:UIControlEventTouchUpInside];
            self.leftBottomUploadBtn1.userInteractionEnabled = _enableEdits;
            if(!_enableEdits&&self.bottomeImageID1.length<=1){
                self.leftBottomUploadBtn1.hidden = YES;
            }
            [_scrollView addSubview:self.leftBottomUploadBtn1];
            self.leftBottomUploadBtn1.frame = CGRectMake(0, 0, 135, 100);
            
            
            self.lable2 =[[UILabel alloc]init];
            _lable2.text = @"诊断证书照1";
            _lable2.textAlignment = NSTextAlignmentCenter;
            _lable2.font = [UIFont systemFontOfSize:14.f];
            _lable2.textColor =  [UIColor lightGrayColor];
            [self.leftBottomUploadBtn1 addSubview:_lable2];
            [_lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.leftBottomUploadBtn1).mas_offset(0);
                make.bottom.mas_equalTo(self.leftBottomUploadBtn1).mas_offset(-10);
                make.width.mas_equalTo(self.leftBottomUploadBtn1);
            }];
            
            
            //photo2
            self.leftBottomUploadBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *requestString3_2 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID2];
            [self.leftBottomUploadBtn2 sd_setImageWithURL:[NSURL URLWithString:requestString3_2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.leftBottomUploadBtn2 addTarget:self action:@selector(leftBottomUploadBtnClick2) forControlEvents:UIControlEventTouchUpInside];
            self.leftBottomUploadBtn2.userInteractionEnabled = _enableEdits;
            if(!_enableEdits&&self.bottomeImageID2.length<=1){
                self.leftBottomUploadBtn2.hidden = YES;
            }
            [_scrollView addSubview:self.leftBottomUploadBtn2];
            self.leftBottomUploadBtn2.frame = CGRectMake(135+20, 0, 135, 100);
            
            UILabel *_lable2_2=[[UILabel alloc]init];
            _lable2_2.text = @"诊断证书照2";
            _lable2_2.textAlignment = NSTextAlignmentCenter;
            _lable2_2.font = [UIFont systemFontOfSize:14.f];
            _lable2_2.textColor =  [UIColor lightGrayColor];
            [self.leftBottomUploadBtn2 addSubview:_lable2_2];
            [_lable2_2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.leftBottomUploadBtn2).mas_offset(0);
                make.bottom.mas_equalTo(self.leftBottomUploadBtn2).mas_offset(-10);
                make.width.mas_equalTo(self.leftBottomUploadBtn2);
            }];

            
            //photo3
            self.leftBottomUploadBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *requestString3_3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID3];
            [self.leftBottomUploadBtn3 sd_setImageWithURL:[NSURL URLWithString:requestString3_3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.leftBottomUploadBtn3 addTarget:self action:@selector(leftBottomUploadBtnClick3) forControlEvents:UIControlEventTouchUpInside];
            self.leftBottomUploadBtn3.userInteractionEnabled = _enableEdits;
            if(!_enableEdits&&self.bottomeImageID3.length<=1){
                self.leftBottomUploadBtn3.hidden = YES;
            }
            [_scrollView addSubview:self.leftBottomUploadBtn3];
            self.leftBottomUploadBtn3.frame = CGRectMake((135+20)*2, 0, 135, 100);
            
            UILabel *_lable2_3=[[UILabel alloc]init];
            _lable2_3.text = @"诊断证书照3";
            _lable2_3.textAlignment = NSTextAlignmentCenter;
            _lable2_3.font = [UIFont systemFontOfSize:14.f];
            _lable2_3.textColor =  [UIColor lightGrayColor];
            [self.leftBottomUploadBtn3 addSubview:_lable2_3];
            [_lable2_3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.leftBottomUploadBtn3).mas_offset(0);
                make.bottom.mas_equalTo(self.leftBottomUploadBtn3).mas_offset(-10);
                make.width.mas_equalTo(self.leftBottomUploadBtn3);
            }];

            
            //photo4
            self.leftBottomUploadBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *requestString3_4 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID4];
            [self.leftBottomUploadBtn4 sd_setImageWithURL:[NSURL URLWithString:requestString3_4] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.leftBottomUploadBtn4 addTarget:self action:@selector(leftBottomUploadBtnClick4) forControlEvents:UIControlEventTouchUpInside];
            self.leftBottomUploadBtn4.userInteractionEnabled = _enableEdits;
            if(!_enableEdits&&self.bottomeImageID4.length<=1){
                self.leftBottomUploadBtn4.hidden = YES;
            }
            [_scrollView addSubview:self.leftBottomUploadBtn4];
            self.leftBottomUploadBtn4.frame = CGRectMake((135+20)*3, 0, 135, 100);
            
            UILabel *_lable2_4=[[UILabel alloc]init];
            _lable2_4.text = @"诊断证书照4";
            _lable2_4.textAlignment = NSTextAlignmentCenter;
            _lable2_4.font = [UIFont systemFontOfSize:14.f];
            _lable2_4.textColor =  [UIColor lightGrayColor];
            [self.leftBottomUploadBtn4 addSubview:_lable2_4];
            [_lable2_4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.leftBottomUploadBtn4).mas_offset(0);
                make.bottom.mas_equalTo(self.leftBottomUploadBtn4).mas_offset(-10);
                make.width.mas_equalTo(self.leftBottomUploadBtn4);
            }];

            
            
            //photo5
            self.leftBottomUploadBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *requestString3_5 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID5];
            [self.leftBottomUploadBtn5 sd_setImageWithURL:[NSURL URLWithString:requestString3_5] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.leftBottomUploadBtn5 addTarget:self action:@selector(leftBottomUploadBtnClick5) forControlEvents:UIControlEventTouchUpInside];
            self.leftBottomUploadBtn5.userInteractionEnabled = _enableEdits;
            if(!_enableEdits&&self.bottomeImageID5.length<=1){
                self.leftBottomUploadBtn5.hidden = YES;
            }
            [_scrollView addSubview:self.leftBottomUploadBtn5];
            self.leftBottomUploadBtn5.frame = CGRectMake((135+20)*4, 0, 135, 100);
            
            UILabel *_lable2_5=[[UILabel alloc]init];
            _lable2_5.text = @"诊断证书照5";
            _lable2_5.textAlignment = NSTextAlignmentCenter;
            _lable2_5.font = [UIFont systemFontOfSize:14.f];
            _lable2_5.textColor =  [UIColor lightGrayColor];
            [self.leftBottomUploadBtn5 addSubview:_lable2_5];
            [_lable2_5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.leftBottomUploadBtn5).mas_offset(0);
                make.bottom.mas_equalTo(self.leftBottomUploadBtn5).mas_offset(-10);
                make.width.mas_equalTo(self.leftBottomUploadBtn5);
            }];

            //photo6
            self.leftBottomUploadBtn6 = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *requestString3_6 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID6];
            [self.leftBottomUploadBtn6 sd_setImageWithURL:[NSURL URLWithString:requestString3_6] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.leftBottomUploadBtn6 addTarget:self action:@selector(leftBottomUploadBtnClick6) forControlEvents:UIControlEventTouchUpInside];
            self.leftBottomUploadBtn6.userInteractionEnabled = _enableEdits;
            if(!_enableEdits&&self.bottomeImageID6.length<=1){
                self.leftBottomUploadBtn6.hidden = YES;
            }
            [_scrollView addSubview:self.leftBottomUploadBtn6];
            self.leftBottomUploadBtn6.frame = CGRectMake((135+20)*5, 0, 135, 100);
            
            UILabel *_lable2_6=[[UILabel alloc]init];
            _lable2_6.text = @"诊断证书照6";
            _lable2_6.textAlignment = NSTextAlignmentCenter;
            _lable2_6.font = [UIFont systemFontOfSize:14.f];
            _lable2_6.textColor =  [UIColor lightGrayColor];
            [self.leftBottomUploadBtn6 addSubview:_lable2_6];
            [_lable2_6 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.leftBottomUploadBtn6).mas_offset(0);
                make.bottom.mas_equalTo(self.leftBottomUploadBtn6).mas_offset(-10);
                make.width.mas_equalTo(self.leftBottomUploadBtn6);
            }];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ( indexPath.row == 4 || indexPath.row == 5||indexPath.row == 9 || indexPath.row == 10|| indexPath.row == 12)  {
            LXConfirmLevelVCTableViewCell1 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXConfirmLevelVCTableViewCell1" owner:self options:nil].firstObject;
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.leadingL.text = leadingString;
            if ([leadingString isEqualToString:@"现住址"]) {
                self.ageTF = cell.trailingTF;
                 [self.ageTF setTextColor:LXColorHex(0x4c4c4c)];
                self.ageTF.delegate = self;
                self.ageTF.userInteractionEnabled = _enableEdits;
                if (self.confirmLevelModel.presentAddress) {
                    [self.ageTF setText:self.confirmLevelModel.presentAddress];
                }
                else {
                    [self.ageTF setPlaceholder:@"请输入住址"];
                }
            }
            else if ([leadingString isEqualToString:@"联系电话"]) {
                self.identifyTF = cell.trailingTF;
                self.identifyTF.delegate = self;
                 [self.identifyTF setTextColor:LXColorHex(0x4c4c4c)];
                self.identifyTF.userInteractionEnabled = _enableEdits;
                if (self.confirmLevelModel.careContactPhone) {
                    [self.identifyTF setText:self.confirmLevelModel.careContactPhone];
                }
                else {
                    [self.identifyTF setPlaceholder:@"请输入联系电话"];
                }
            }else if ([leadingString isEqualToString:@"社会保障卡号"]) {
                self.socialTF = cell.trailingTF;
                self.socialTF.delegate = self;
                self.socialTF.userInteractionEnabled = _enableEdits;
                self.socialTF.textAlignment = NSTextAlignmentRight;
                if (self.confirmLevelModel.siCardNo) {
                    [self.socialTF setText:self.confirmLevelModel.siCardNo];
                }
                else {
                    [self.socialTF setPlaceholder:@"请输入社会保障卡号"];
                }
            }
            else if ([leadingString isEqualToString:@"代理人姓名"]) {
                self.mcNameTF = cell.trailingTF;
                self.mcNameTF.delegate = self;
                [self.mcNameTF setTextColor:LXColorHex(0x4c4c4c)];
                self.mcNameTF.userInteractionEnabled = _enableEdits;
                if (self.confirmLevelModel.mcName) {
                    [self.mcNameTF setText:self.confirmLevelModel.mcName];
                }
                else {
                    [self.mcNameTF setPlaceholder:@"请输入代理人姓名"];
                }
            }else if ([leadingString isEqualToString:@"关系"]) {
                self.mcRelaTF = cell.trailingTF;
                self.mcRelaTF.delegate = self;
                [self.mcRelaTF setTextColor:LXColorHex(0x4c4c4c)];
                self.mcRelaTF.userInteractionEnabled = _enableEdits;
                if (self.confirmLevelModel.mcRela) {
                    [self.mcRelaTF setText:self.confirmLevelModel.mcRela];
                }
                else {
                    [self.mcRelaTF setPlaceholder:@"请输入您与照护对象关系"];
                }
            }else if ([leadingString isEqualToString:@"联系地址(邮寄地址)"]) {
                self.msAddresTF = cell.trailingTF;
                [self.msAddresTF setTextColor:LXColorHex(0x4c4c4c)];
                self.msAddresTF.delegate = self;
                self.msAddresTF.userInteractionEnabled = _enableEdits;
                if (self.confirmLevelModel.msAddress) {
                    [self.msAddresTF setText:self.confirmLevelModel.msAddress];
                }
                else {
                    [self.msAddresTF setPlaceholder:@"请输入您的地址"];
                }
            }
            return cell;
        }else if(indexPath.row ==11){
            LXConfirmLevelVCTableViewCell1 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXConfirmLevelVCTableViewCell1" owner:self options:nil].firstObject;
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.leadingL.text = leadingString;
            self.mcPhoneTF = cell.trailingTF;
            self.mcPhoneTF.delegate = self;
            self.mcPhoneTF.userInteractionEnabled = _enableEdits;
            [self.mcPhoneTF setTextColor:LXColorHex(0x4c4c4c)];
            if (self.confirmLevelModel.mcPhone) {
                [self.mcPhoneTF setText:self.confirmLevelModel.mcPhone];
            }
            else {
                [self.mcPhoneTF setPlaceholder:@"请输入联系电话"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            LXConfirmLevelVCTableViewCell2 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXConfirmLevelVCTableViewCell2" owner:self options:nil].firstObject;
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.leadingL.text = leadingString;
            
            if ([leadingString isEqualToString:@"人员类别"]) {
                if(!self.enableEdits){
                    cell.arrowBT.hidden = YES;
                }
                if ([self.confirmLevelModel.personNatureId isEqualToString:@"1"]) {
                    cell.trailingL.text = @"在职";
                }
                else if ([self.confirmLevelModel.personNatureId isEqualToString:@"2"]) {
                    cell.trailingL.text = @"退休";
                }
//                else if ([self.confirmLevelModel.personNatureId isEqualToString:@"3"]) {
//                    cell.trailingL.text = @"居民";
//                }
                else {
                    cell.trailingL.text = @"请选择";
                }
            }
            else if ([leadingString isEqualToString:@"待遇类别"]) {
                if(!self.enableEdits){
                    cell.arrowBT.hidden = YES;
                }
                if ([self.confirmLevelModel.livingCare isEqualToString:@"1"]) {
                    cell.trailingL.text = @"生活照料";
                }
                else if ([self.confirmLevelModel.livingCare isEqualToString:@"2"]) {
                    cell.trailingL.text = @"生活照料+医疗护理";
                }
                else {
                    cell.trailingL.text = @"请选择";
                }
            }

            else if ([leadingString isEqualToString:@"待遇类型"]) {
                if(!self.enableEdits){
                    cell.arrowBT.hidden = YES;
                }
                if ([self.confirmLevelModel.careTypeId isEqualToString:@"1"]) {
                    cell.trailingL.text = @"居家护理";
                }
                else if ([self.confirmLevelModel.careTypeId isEqualToString:@"2"]) {
                    cell.trailingL.text = @"机构护理";
                }
                else {
                    cell.trailingL.text = @"请选择";
                }
            }
            else if ([leadingString isEqualToString:@"评估类别"]) {
                if(!self.enableEdits){
                    cell.arrowBT.hidden = YES;
                }
                if ([self.confirmLevelModel.serviceType isEqualToString:@"1"]) {
                    cell.trailingL.text = @"首次评估";
                }
                else if ([self.confirmLevelModel.serviceType isEqualToString:@"2"]) {
                    cell.trailingL.text = @"复检评估";
                }
                else if ([self.confirmLevelModel.serviceType isEqualToString:@"3"]){
                    cell.trailingL.text = @"变更评估";
                }else {
                    cell.trailingL.text = @"请选择";
                }
            }
            else if ([leadingString isEqualToString:@"送达方式"]) {
                if(!self.enableEdits){
                    cell.arrowBT.hidden = YES;
                }
                if ([self.confirmLevelModel.dmTypeId isEqualToString:@"1"]) {
                    cell.trailingL.text = @"邮寄";
                }
                else if ([self.confirmLevelModel.dmTypeId isEqualToString:@"2"]) {
                    cell.trailingL.text = @"自行领取";
                }else {
                    cell.trailingL.text = @"请选择";
                }
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        LXAddCareVCTableViewCell2 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXAddCareVCTableViewCell2" owner:self options:nil].firstObject;
        
        [cell.contentView setBackgroundColor:LXVCBackgroundColor];
        
        if(indexPath.row==0){
            CGRect frame = cell.leadingLa.frame;
            frame.size.width  =LXScreenWidth-25*2;
            frame.size.height = 75;
            frame.origin.y = 0;
            UILabel *lable = [[UILabel alloc]initWithFrame:frame];
            lable.text =leadingString;
            lable.numberOfLines = 0;
            lable.font =cell.leadingLa.font;
            lable.textColor = cell.leadingLa.textColor;
            [cell.contentView addSubview:lable];
            
        }else if(indexPath.row==1){
            CGRect frame = cell.leadingLa.frame;
            frame.size.width = LXScreenWidth-25*2;
            frame.size.height = 40;
            frame.origin.y = 0;
            UILabel *lable = [[UILabel alloc]initWithFrame:frame];
            lable.text =leadingString;
            lable.numberOfLines = 0;
            lable.font =cell.leadingLa.font;
            lable.textColor = cell.leadingLa.textColor;
            [cell.contentView addSubview:lable];
        }else{
            cell.leadingLa .text= leadingString;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if(indexPath.row==0){
            return 75;
        }else if(indexPath.row==1){
            return 40;
        }else{
            return 30;
        }
        
    }
    
    NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
    if ([tempString isEqualToString:@"社会保障卡号"] || [tempString isEqualToString:@"诊断照片(最多可传6张)"]||[tempString isEqualToString:@"免冠照片(清晰近照)"]) {
        return 150;
    }
    else {
        return 50;
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!_enableEdits){
        return;
    }
    NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
    
    if ([tempString isEqualToString:@"人员类别"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[@"在职", @"退休"];
        
        [self addActionTarget:alertController titles:titles];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([tempString isEqualToString:@"待遇类型"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[@"居家护理", @"机构护理"];
        
        [self addActionTarget:alertController titles:titles];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([tempString isEqualToString:@"待遇类别"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[@"生活照料", @"生活照料+医疗护理"];
        
        [self addActionTarget:alertController titles:titles];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([tempString isEqualToString:@"评估类别"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[@"首次评估", @"复检评估",@"变更评估"];
        
        [self addActionTarget:alertController titles:titles];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([tempString isEqualToString:@"送达方式"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[ @"邮寄",@"自行领取"];
        
        [self addActionTarget:alertController titles:titles];
        [self addCancelActionTarget:alertController title:@"取消"];
        [self presentViewController:alertController animated:YES completion:nil];
    }
        

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
     if ([self.ageTF isEqual:textField]) {
        self.confirmLevelModel.presentAddress = textField.text;
    }
    else if ([self.identifyTF isEqual:textField]) {
        self.confirmLevelModel.careContactPhone = textField.text;
    }
    else if ([self.socialTF isEqual:textField]) {
        self.confirmLevelModel.siCardNo = textField.text;
    }else if ([self.mcNameTF isEqual:textField]) {
        self.confirmLevelModel.mcName = textField.text;
    }else if ([self.mcRelaTF isEqual:textField]) {
        self.confirmLevelModel.mcRela = textField.text;
    }else if ([self.mcPhoneTF isEqual:textField]) {
        self.confirmLevelModel.mcPhone = textField.text;
    }else if ([self.msAddresTF isEqual:textField]) {
        self.confirmLevelModel.msAddress = textField.text;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.socialTF){
      NSString *keyword = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(keyword.length>=24){
            return NO;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL  isOrNO= [string isEqualToString:filtered];
        
        return isOrNO;

    }else if(textField == self.mcPhoneTF){
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUM2] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL  isOrNO= [string isEqualToString:filtered];
        
        return isOrNO;
    }else if (textField == self.identifyTF){
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUM2] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL  isOrNO= [string isEqualToString:filtered];
        
        return isOrNO;

    }
    
    return YES;
}

#pragma mark - Action

- (void)myConfirmBtn1Click {
    [_nameTF resignFirstResponder];
    [_ageTF resignFirstResponder];
    [_identifyTF resignFirstResponder];
    [_socialTF resignFirstResponder];
    [_mcRelaTF resignFirstResponder];
    [_mcNameTF resignFirstResponder];
    [_mcPhoneTF resignFirstResponder];
    [_msAddresTF resignFirstResponder];
    
    if (self.leftImageID==nil || self.rightImageID==nil||self.heardImgID==nil) {
        
        [SVProgressHUD showInfoWithStatus:@"照片不够，请继续添加"];
        
        [SVProgressHUD dismissWithDelay:1];
        
        return;
    }
    if(self.bottomeImageID1==nil&&self.bottomeImageID2==nil&&self.bottomeImageID3==nil&&self.bottomeImageID4==nil&&self.bottomeImageID5==nil&&self.bottomeImageID6==nil){
        [SVProgressHUD showInfoWithStatus:@"照片不够，请继续添加"];
        
        [SVProgressHUD dismissWithDelay:1];
        
        return;
    }
    
    if(self.bottomeImageID1==nil){
        self.bottomeImageID1=@"";
    }
    if(self.bottomeImageID2==nil){
        self.bottomeImageID2=@"";
    }
    if(self.bottomeImageID3==nil){
        self.bottomeImageID3=@"";
    }
    if(self.bottomeImageID4==nil){
        self.bottomeImageID4=@"";
    }
    if(self.bottomeImageID5==nil){
        self.bottomeImageID5=@"";
    }
    if(self.bottomeImageID6==nil){
        self.bottomeImageID6=@"";
    }
    self.confirmLevelModel.images= [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@", self.leftImageID, self.rightImageID,self.heardImgID,self.bottomeImageID1,self.bottomeImageID2,self.bottomeImageID3,self.bottomeImageID4,self.bottomeImageID5,self.bottomeImageID6];
   // NSArray* array = [imgeID componentsSeparatedByString:@","];
    
    self.confirmLevelModel.imageTypes = [NSString stringWithFormat:@"5,5,4,3,3,3,3,3,3"];
    if (self.confirmLevelModel.personNatureId.length>0  && self.confirmLevelModel.careTypeId.length>0  && self.confirmLevelModel.images.length>0 && self.confirmLevelModel.imageTypes.length>0 && self.confirmLevelModel.mcName.length>0 && self.confirmLevelModel.mcRela.length>0 && self.confirmLevelModel.mcPhone.length>0 && self.confirmLevelModel.msAddress.length>0 && self.confirmLevelModel.dmTypeId.length>0 &&self.confirmLevelModel.siCardNo.length>0 &&self.confirmLevelModel.livingCare.length>0 &&self.confirmLevelModel.serviceType.length>0 &&self.confirmLevelModel.presentAddress.length>0 &&self.confirmLevelModel.careContactPhone.length>0 ) {
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"条件不够，请继续添加"];
        
        [SVProgressHUD dismissWithDelay:1];
        
        return;
    }
    if(self.levelBlock){
        self.levelBlock(self.confirmLevelModel);
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightUploadBtnClick {
    self.type = 2;
    
    [self presentAlterViewController];
}

- (void)leftUploadBtnClick {
    self.type = 1;
    
    [self presentAlterViewController];
}

- (void)leftBottomUploadBtnClick1 {
    self.type = 31;
    
    [self presentAlterViewController];
}
- (void)leftBottomUploadBtnClick2 {
    self.type = 32;
    
    [self presentAlterViewController];
}
- (void)leftBottomUploadBtnClick3 {
    self.type = 33;
    
    [self presentAlterViewController];
}
- (void)leftBottomUploadBtnClick4 {
    self.type = 34;
    
    [self presentAlterViewController];
}
- (void)leftBottomUploadBtnClick5 {
    self.type = 35;
    
    [self presentAlterViewController];
}
- (void)leftBottomUploadBtnClick6 {
    self.type = 36;
    
    [self presentAlterViewController];
}

- (void)heradImgBtnClick {
    self.type = 4;
    
    [self presentAlterViewController];
}
- (void)presentAlterViewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *titles = @[@"拍照", @"相册"];
    
    [self addActionTarget:alertController titles:titles];
    [self addCancelActionTarget:alertController title:@"取消"];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles {
    // @[@"在职", @"退休", @"居民"]; @[@"居家", @"入住机构"];
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([title isEqualToString:@"拍照"]) {
                [self gotoPerformTakePictrue];
            }
            else if ([title isEqualToString:@"相册"]) {
                [self gotoGetFromLibrary];
            }
            else if ([title isEqualToString:@"在职"]) {
                self.confirmLevelModel.personNatureId = @"1";
                
                [self updateView];
            }
            else if ([title isEqualToString:@"退休"]) {
                self.confirmLevelModel.personNatureId = @"2";
                
                [self updateView];
            }
//            else if ([title isEqualToString:@"居民"]) {
//                [self gotoSelect3];
//            }
            else if ([title isEqualToString:@"居家护理"]) {
                self.confirmLevelModel.careTypeId = @"1";
                
                [self updateView];
            }
            else if ([title isEqualToString:@"机构护理"]) {
                self.confirmLevelModel.careTypeId = @"2";
                
                [self updateView];
            }
            else if ([title isEqualToString:@"生活照料"]) {
                self.confirmLevelModel.livingCare = @"1";
                
                [self updateView];
            }
            else if ([title isEqualToString:@"生活照料+医疗护理"]) {
                self.confirmLevelModel.livingCare = @"2";
                
                [self updateView];
            }
            else if ([title isEqualToString:@"首次评估"]) {
                self.confirmLevelModel.serviceType = @"1";
                
                [self updateView];
            }
            else if ([title isEqualToString:@"复检评估"]) {
                self.confirmLevelModel.serviceType = @"2";
                
                [self updateView];
            }
            else if ([title isEqualToString:@"变更评估"]) {
                self.confirmLevelModel.serviceType = @"3";
                
                [self updateView];
            }
            else if ([title isEqualToString:@"邮寄"]) {
                self.confirmLevelModel.dmTypeId = @"1";
                
                [self updateView];
            }
            else if ([title isEqualToString:@"自行领取"]) {
                self.confirmLevelModel.dmTypeId = @"2";
                
                [self updateView];
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



#pragma mark - Go to

- (void)gotoPerformTakePictrue {
    // Device authorization
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        NSString *alterTitle = @"无法使用相机";
        NSString *alterMessage = @"请在iPhone的“设置-隐私-相机”中允许访问相机";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alterTitle message:alterMessage preferredStyle:UIAlertControllerStyleAlert];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else {
        // Library authorization
        ALAuthorizationStatus authStatusXC = [ALAssetsLibrary authorizationStatus];
        
        // Refuse
        if(authStatusXC==ALAuthorizationStatusRestricted || authStatusXC == ALAuthorizationStatusDenied) {
            NSString *alterTitle = @"无法使用相机";
            NSString *alterMessage = @"请在iPhone的“设置-隐私-相机”中允许访问相机";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alterTitle message:alterMessage preferredStyle:UIAlertControllerStyleAlert];
            [self addCancelActionTarget:alertController title:@"取消"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
        else {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.delegate=self;
            self.imagePickerController.allowsEditing  =YES;
            
            if(self.presentedViewController){
                [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }
            
            [self presentViewController:self.imagePickerController animated:YES completion:^{
                self.imagePickerController.delegate=self;
            }];
        }
    }
}

- (void)gotoGetFromLibrary {
    // Library authorization
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    
    // Refuse
    if (authStatus==ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied) {
        NSString *alterTitle = @"无法使用相机";
        NSString *alterMessage = @"请在iPhone的“设置-隐私-相机”中允许访问相机";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alterTitle message:alterMessage preferredStyle:UIAlertControllerStyleAlert];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            self.imagePickerController.allowsEditing  =YES;
            self.imagePickerController.delegate=self;
            
            if(self.presentedViewController){
                [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }
            
            self.imagePickerController.navigationController.navigationBar.tintColor =[UIColor whiteColor];
            self.imagePickerController.navigationController.navigationBar.barTintColor = LXMainColor;
            
            // 改变取消按钮颜色
            NSDictionary *dict = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
            
            UIBarButtonItem *buttonItem = [UIBarButtonItem appearance];
            // 设置返回按钮的背景图片
            [buttonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
            
            [self presentViewController:self.imagePickerController animated:YES completion:^{
                self.imagePickerController.delegate=self;
                self.imagePickerController.navigationController.delegate=self;
                self.imagePickerController.navigationController.navigationBar.tintColor =[UIColor whiteColor];
                self.imagePickerController.navigationController.navigationBar.barTintColor = LXMainColor;
            }];
        });
    }
}

#pragma mark - UINavigationControllerDelegate

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.imagePickerController.delegate=self;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.imagePickerController.delegate=self;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        // 改变取消按钮颜色
        NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        UIBarButtonItem *buttonItem = [UIBarButtonItem appearance];
        // 设置返回按钮的背景图片
        [buttonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    }];
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        LXLog(@"************照相进入*************");
        
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        
        [self saveImage:image WithName:[NSString stringWithFormat:@"%d", arc4random() % 1000]];
    }
    else {
        LXLog(@"************相册进入*************");
        
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
       
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        
        [self saveImage:image WithName:[NSString stringWithFormat:@"%d", arc4random() % 1000]];
    }
}

//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    if ([self imageDocument]) {
        [LXSandBox createDirectoryAtPath:[self imageDocument]];
    }
    
    NSString *totalPath = [[self imageDocument] stringByAppendingPathComponent:imageName];
    
    @synchronized (self) {
        NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
        [imageData writeToFile:totalPath atomically:YES];
    }
    
    
    [self uploadImageWithURL:[[NSURL alloc] initFileURLWithPath:totalPath] iamge:tempImage];
}

- (NSString *)imageDocument {
    return [[LXSandBox getHomeDocumentsPath] stringByAppendingPathComponent:@"ImageDocument"];
}


- (void)uploadImageWithURL:(NSURL *)imageURL iamge:(UIImage *)image {
   // 准备
     LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"上传中……"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requsetSerialzer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = requsetSerialzer;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://112.74.38.196:8081/ihealthcare/common/uploadimage.htm" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *err = nil;
        
        [formData appendPartWithFileURL:imageURL name:@"image" error:&err];
        
        LXLog(@"%@", formData);
        LXLog(@"%@", err);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        
        @synchronized (weakself) {
            [LXSandBox deleteFielWithFileURL:imageURL];
        }
        id dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        int code = [dic[@"code"] intValue];
        if(code==0){
            if (self.type == 1) {
                self.leftImage = image;
                self.leftImageID = dic[@"file_id"];
                NSString *requestString = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.leftImageID];
                [self.leftUploadBtn sd_setImageWithURL:[NSURL URLWithString:requestString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 2) {
                self.rightImage = image;
                self.rightImageID = dic[@"file_id"];
                NSString *requestString2 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.rightImageID];
                [self.rightUploadBtn sd_setImageWithURL:[NSURL URLWithString:requestString2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 31) {
                self.bottomImage = image;
                self.bottomeImageID1 = dic[@"file_id"];
                NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID1];
                [self.leftBottomUploadBtn1 sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 32) {
                
                self.bottomeImageID2 = dic[@"file_id"];
                NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID2];
                [self.leftBottomUploadBtn2 sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 33) {
                
                self.bottomeImageID3 = dic[@"file_id"];
                NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID3];
                [self.leftBottomUploadBtn3 sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 34) {
                
                self.bottomeImageID4 = dic[@"file_id"];
                NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID4];
                [self.leftBottomUploadBtn4 sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 35) {
                self.bottomImage = image;
                self.bottomeImageID5 = dic[@"file_id"];
                NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID5];
                [self.leftBottomUploadBtn5 sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 36) {
                self.bottomImage = image;
                self.bottomeImageID6 = dic[@"file_id"];
                NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.bottomeImageID6];
                [self.leftBottomUploadBtn6 sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 4) {
                self.heardImage = image;
                self.heardImgID = dic[@"file_id"];
                
                NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.heardImgID];
                [self.heardImgBT sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }

        }else{
            [SVProgressHUD showErrorWithStatus:@"哎呀,出错了!"];
        }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        LXLog(@"上传照片出错%@", error);
    }];
}

#pragma mark - Getter

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
            _imagePickerController.mediaTypes = @[(NSString*)kUTTypeImage];
        }
        
        else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            _imagePickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            _imagePickerController.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:_imagePickerController.sourceType];
        }
        
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        // Orientation
        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight) {
            _imagePickerController.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*1/2);
        }
        else if (self.interfaceOrientation==UIDeviceOrientationLandscapeLeft){
            _imagePickerController.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*3/2);
        }
#pragma clang diagnostic pop
    }
    
    return _imagePickerController;
}

- (UIButton *)myConfirmBtn1 {
    if (!_myConfirmBtn1) {
        _myConfirmBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myConfirmBtn1 setTitle:@"添加" forState:UIControlStateNormal];
        [_myConfirmBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_myConfirmBtn1.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_myConfirmBtn1 setFrame:CGRectMake(0, 0, 40, 30)];
        [_myConfirmBtn1.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_myConfirmBtn1 addTarget:self action:@selector(myConfirmBtn1Click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myConfirmBtn1;
}


@end
