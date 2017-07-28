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
#import "ReservationStadusController.h"
#import "LXReservationVCTableViewCellNormal.h"
#import "LXReservationVCTableViewCellNormalBig.h"
#import "LXReservationVCTableViewCellSelectEnter.h"
#import "LXReservationTableViewCellSelectStay.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface LXReservationViewController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *orderArray;

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, copy) NSString *phoneString;
@property (nonatomic, strong) UILabel *selectCareL;

@property (nonatomic, strong) UITextView *addressTV;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic, strong) UITextView *remarkTV;
@property (nonatomic, copy) NSString *remarkString;

@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, copy) NSString *repeatLString;
@property (nonatomic, copy) NSString *timeString;

@property (nonatomic, strong) LXConfirmOrderView *confirmView;
@property (nonatomic, strong) LXOderDealView *orderDealView;

@property (nonatomic, strong) LXReservationViewModel *viewModel;

@property (nonatomic, assign) NSInteger serverType;
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, copy) NSString *careID;
@property (nonatomic, copy) NSString *careName;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) LXReservationTableViewCellSelectStay *stayCell;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *atitude;
@property (nonatomic, copy) NSString *addrId;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic,strong) NSArray *timeArray_0;

@property (nonatomic, strong) NSMutableArray *indexArr1;
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
    
    self.addressString = @"";
    self.addrId = @"";
    self.longitude = @"";
    self.atitude = @"";
    self.goodsName = @"";
    
    self.serverType = 0;
    self.timeArray = [NSMutableArray array];
    self.indexArr1 =[NSMutableArray array];
    
    self.careName = @"请选择照护对象";
    self.careID = nil;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.viewModel = [LXReservationViewModel new];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.nameString = self.nameTF.text;
    self.phoneString = self.phoneTF.text;
    if(![self.addressTV.text isEqualToString:@"请输入你的联系地址"]){
        self.addressString = self.addressTV.text;
    }
    if(![self.remarkTV.text isEqualToString:@"请输入30字以内的备注"]){
        self.remarkString = self.remarkTV.text;

    }
}
/* 理编码回调. */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
     [SVProgressHUD dismiss];
    if (response.geocodes.count == 0)
    {
        return;
    }else{
        
        //判断是否为空
        if (response) {
            
            //取出搜索到的POI（POI：Point Of Interest）
            AMapGeocode *geo=  response.geocodes.firstObject;
            self.longitude = [NSString stringWithFormat:@"%.4f",geo.location.longitude];
            self.atitude = [NSString stringWithFormat:@"%.4f",geo.location.latitude];
            self.addrId = @"";
        }
        
        
    }
}
//根据 objid 获取地址
-(void)selectObjAdress:(NSString*)ID{
   
    [self.viewModel getAddressReservationWithParameters: @{@"careObjId":ID} completionHandler:^(NSError *error, id result) {
        //LXWeakSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            
            self.addressString = result[@"address"];
            self.addrId = result[@"addrId"];
            
            AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc]init];
            request.address = _addressString;
            [self.search AMapGeocodeSearch:request];

            [self updateView];
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}

#pragma mark - Configure

- (void)congfigreView {
    [self.confirmView removeFromSuperview];
    self.confirmView = nil;
    [self.view addSubview:self.confirmView];
    self.confirmView.totalSum = [NSString stringWithFormat:@"总价：%ld", (long)self.totalPrice*self.timeArray_0.count];
    self.confirmView.timeArr = self.timeArray_0;
    self.confirmView.dataSource = self.orderArray;
    [self.view bringSubviewToFront:self.confirmView];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 4;
    }else if (section==1){
        return 3;
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *leadingString =self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            LXReservationVCTableViewCellSelectEnter *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellSelectEnter" owner:self options:nil].firstObject;
            cell.middleL.textColor = LXMainColor;
            cell.leadingL.text = leadingString;
            cell.middleL.text = self.careName;
            self.selectCareL = cell.middleL;
            
            return cell;
        }else if (indexPath.row==3){
            LXReservationVCTableViewCellNormalBig *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellNormalBig" owner:self options:nil].firstObject;
            
            cell.leadingL.text = leadingString;
            cell.trailingTF.hidden = YES;
            self.addressTV = [[UITextView alloc]init];
            [cell.contentView addSubview:self.addressTV];
            [_addressTV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(cell.contentView).offset(-10);
                make.top.equalTo(cell.leadingL).offset(-8);
                make.width.offset(250);
                make.bottom.equalTo(cell.contentView).offset(-10);
            }];
            self.addressTV.delegate = self;
            self.addressTV.font =[UIFont systemFontOfSize:14.f];
            self.addressTV.returnKeyType = UIReturnKeyDefault;
            if (self.addressString.length > 0) {
                self.addressTV.text = self.addressString;
            }
            else {
                [self.addressTV setTextColor:LXColorHex(0xb2b2b2)];
                self.addressTV.text = @"请输入你的联系地址";
            }
            return cell;
        }
        else {
            LXReservationVCTableViewCellNormal *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellNormal" owner:self options:nil].firstObject;
            
            if (indexPath.row == 0) {
                self.nameTF = cell.trailingTF;
                self.nameTF.delegate = self;
                self.nameTF.returnKeyType = UIReturnKeyDefault;
                if (self.nameString.length > 0) {
                    self.nameTF.text = self.nameString;
                }
                else {
                    self.nameTF.placeholder = @"请输入联系人的姓名";
                    [self.nameTF setValue:LXMainColor forKeyPath:@"_placeholderLabel.textColor"];
                }
            }
            else {
                self.phoneTF = cell.trailingTF;
                self.phoneTF.delegate =self;
                self.phoneTF.returnKeyType = UIReturnKeyDefault;
                if (self.phoneString.length > 0) {
                    self.phoneTF.text = self.phoneString;
                }
                else {
                    self.phoneTF.placeholder = @"请输入联系电话";
                    [self.phoneTF setValue:LXMainColor forKeyPath:@"_placeholderLabel.textColor"];
                }
            }
            
            cell.leadingL.text = leadingString;
            
            return cell;
        }
    }
    
    else if (indexPath.section == 1) {
       
            LXReservationVCTableViewCellSelectEnter *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellSelectEnter" owner:self options:nil].firstObject;
            
            cell.leadingL.text = leadingString;
        cell.middleL.textColor = LXMainColor;
        if (indexPath.row==1) {
            if(self.goodsName.length<=0){
                cell.middleL.text =@"请选择服务项目";
            }else{
                cell.middleL.text =self.goodsName;
            }
        }else if (indexPath.row==2){
            if(self.timeString.length<=0){
                cell.middleL.text =@"请选择服务时间";
            }else{
                cell.middleL.text =self.timeString;
            }
        }else{
            if(self.serverType ==1){
                cell.middleL.text =@"基本生活照料服务";

            }else if(self.serverType ==2){
                cell.middleL.text =@"医疗护理服务";

            }else{
                cell.middleL.text =@"请选择服务类型";

            }
        }
            
         return cell;
    
    }
    else if (indexPath.section == 2) {
         if (indexPath.row == 0) {
            LXReservationVCTableViewCellNormalBig *cell = [[NSBundle mainBundle] loadNibNamed:@"LXReservationVCTableViewCellNormalBig" owner:self options:nil].firstObject;
            
            cell.leadingL.text = leadingString;
           
            cell.trailingTF.hidden = YES;
            self.remarkTV = [[UITextView alloc]init];
            [cell.contentView addSubview:self.remarkTV];
            [_remarkTV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(10);
                make.trailing.equalTo(cell.contentView).offset(-10);
                make.top.equalTo(cell.contentView).offset(0);
                make.bottom.equalTo(cell.contentView);
            }];
            self.remarkTV.delegate = self;
            self.remarkTV.font =[UIFont systemFontOfSize:14.f];
            self.remarkTV.returnKeyType = UIReturnKeyDefault;
            if (self.remarkString.length > 0) {
                self.remarkTV.text = self.remarkString;
            }
            else {
                [self.remarkTV setTextColor:LXColorHex(0xb2b2b2)];
                self.remarkTV.text = @"请输入30字以内的备注";
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
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
   
    if(textView==self.addressTV){
        if([textView.text isEqualToString:@"请输入你的联系地址"]){
            textView.text=@"";
            textView.textColor =[UIColor blackColor];
        }
    }else{
        if([textView.text isEqualToString:@"请输入30字以内的备注"]){
            textView.text=@"";
            textView.textColor =[UIColor blackColor];
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label =[UILabel new];
    label.frame = CGRectMake(0, 0, 100, 20);
    label.font = [UIFont systemFontOfSize:14.5];
    if(section==0){
        label.text = @"丨基本信息";
    }else if (section==1){
        label.text = @"丨服务信息";
    }else{
        label.text = @"丨备注";
    }
    
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView == self.addressTV){
        self.addressString = self.addressTV.text;
        if(textView.text.length>0){
            [SVProgressHUD showWithStatus:@"正在为您定位..."];
            AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc]init];
            request.address = textView.text;
            [self.search AMapGeocodeSearch:request];
        }else if (textView.text.length<=0){
            self.addressTV.text = @"请输入你的联系地址";
            [textView setTextColor:LXColorHex(0xb2b2b2)];
        }

    }else{
         self.remarkString = self.remarkTV.text;
        if(textView.text.length>0){
        
        }else if (textView.text.length<=0){
            self.remarkTV.text = @"请输入30字以内的备注";
            [textView setTextColor:LXColorHex(0xb2b2b2)];
        }
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(self.remarkTV){
        NSString *bankCode= [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
        
        if (bankCode.length>30) {
            return NO;
        }

    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempStrig = self.dataSource[indexPath.section][indexPath.row];
    
    if ([tempStrig isEqualToString:@"时间"]) {
        return 100;
    }
    else if ([tempStrig isEqualToString:@"服务地址"]||[tempStrig isEqualToString:@""]) {
        return 65;
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
        careViewController.isOrder = YES;
        careViewController.careID_0 = self.careID;
        LXWeakSelf(self);
        careViewController.selectBlock = ^(NSString *careID, NSString *name) {
             [SVProgressHUD showWithStatus:@"正在获取对象地址.."];
            weakself.careID = careID;
            weakself.careName = name;
            [weakself selectObjAdress:careID];
            weakself.orderArray = [NSMutableArray array];
            weakself.indexArr1 =[NSMutableArray array];
            weakself.goodsName = @"";
            weakself.totalPrice = 0;
            weakself.timeString = @"";
            weakself.serverType = 0;
            [weakself updateView];
            
        };
        
        [self.navigationController pushViewController:careViewController animated:YES];
    }
    else if ([tempStrig isEqualToString:@"服务时间"]) {
        LXTimeSelectViewController *timeSVC = [[LXTimeSelectViewController alloc] init];
        NSString *repeatWeek = nil;
        repeatWeek = self.repeatLString;
        if([repeatWeek isEqualToString:@"一周"]){
            repeatWeek=@"1";
        }else if([repeatWeek isEqualToString:@"两周"]){
            repeatWeek = @"2";
        }else if([repeatWeek isEqualToString:@"三周"]){
            repeatWeek = @"3";
        }else if([repeatWeek isEqualToString:@"四周"]){
            repeatWeek=@"4";
        } else{
            repeatWeek=@"0";
        }
        timeSVC.repeatTimeInter =repeatWeek.integerValue;
        timeSVC.timeStringArr = (NSMutableArray *)[self.timeString componentsSeparatedByString:@","];
        LXWeakSelf(self);
        timeSVC.selectBlock = ^(NSArray *timeArray, NSString *repeat) {
            weakself.timeString = @"";
            weakself.timeArray_0 = timeArray;
             if ([timeArray count] == 1) {
                NSString *time1 =[timeArray[0] substringToIndex:16];
//                NSString *time11= [time1 substringFromIndex:5];
//                NSString *time111 =[time11 stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
//                weakself.timeL1String =[time111 stringByReplacingOccurrencesOfString:@" " withString:@"日 "] ;
                weakself.timeString = time1;
                
            }
            else if ([timeArray count] >= 2) {
//                NSString *time1 =[timeArray[0] substringToIndex:16];
//                NSString *time11= [time1 substringFromIndex:5];
//                NSString *time111 =[time11 stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
//                weakself.timeL1String =[time111 stringByReplacingOccurrencesOfString:@" " withString:@"日 "] ;
               
                
//                NSString *time2 =[timeArray[1] substringToIndex:16];
//                NSString *time22= [time2 substringFromIndex:5];
//                NSString *time222 =[time22 stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
//                weakself.timeL2String =[time222 stringByReplacingOccurrencesOfString:@" " withString:@"日 "] ;
                
                for (NSString *timeS in timeArray) {
                  NSString *tempS =  [timeS substringToIndex:16];
                     weakself.timeString =[weakself.timeString stringByAppendingString:[NSString stringWithFormat:@"%@,",tempS]];
                }
                weakself.timeString = [weakself.timeString substringToIndex:weakself.timeString.length-1];
                
            }
            weakself.repeatLString = repeat;
            [weakself updateView];
        };
        
        [self.navigationController pushViewController:timeSVC animated:YES];
    }
    else if ([tempStrig isEqualToString:@"服务项目"]) {
        if(self.serverType<1){
            [SVProgressHUD showInfoWithStatus:@"请先选择服务类型"];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        LXServiceProjectViewController *servicePVC = [[LXServiceProjectViewController alloc] init];
        servicePVC.addBlock = ^(NSArray *arr,NSArray *indexArr) {
            self.totalPrice = 0;
            self.goodsName = @"";
            self.orderArray = [NSMutableArray arrayWithArray:arr];
            self.indexArr1 =[NSMutableArray arrayWithArray:indexArr];
            if (self.orderArray.count > 0) {
                for (LXServiceProjectModel *model in self.orderArray) {
                    self.totalPrice += model.price.integerValue;
                    self.goodsName =[self.goodsName stringByAppendingString:[NSString stringWithFormat:@" %@",model.goodsName]] ;
                }
            }
            
            [self updateView];
        };
        servicePVC.careID = self.careID;
        servicePVC.indexArr = self.indexArr1;
        servicePVC.selectArr_pass = self.orderArray;
        servicePVC.servType =[NSString stringWithFormat:@"%ld",self.serverType] ;
        [self.navigationController pushViewController:servicePVC animated:YES];
    }
    else if ([tempStrig isEqualToString:@"服务类型"]) {
        LXWeakSelf(self);
        ReservationStadusController *statusVC =[ReservationStadusController new];
        statusVC.careID_0 =[NSString stringWithFormat:@"%ld",self.serverType];
        statusVC.black = ^(NSInteger reID) {
            if(reID != weakself.serverType){
                weakself.serverType = reID;
                weakself.orderArray = [NSMutableArray array];
                weakself.indexArr1 =[NSMutableArray array];
                weakself.goodsName = @"";
                weakself.totalPrice = 0;
                weakself.timeString = @"";
                [weakself updateView];
            }
        };
        [self.navigationController pushViewController:statusVC animated:YES];
    }else{
        return;
    }
   
    [_tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
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
    [self.addressTV resignFirstResponder];
    [self.remarkTV resignFirstResponder];
    

    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];

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
        [SVProgressHUD showInfoWithStatus:@"请选择服务类型"];
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
        [SVProgressHUD showInfoWithStatus:@"请选择服务项目"];
        return;
    }
    
   
   
   if(self.nameString.length<=0) {
        [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
        return;
    }
    
    if(self.phoneString.length<=0) {
        [SVProgressHUD showInfoWithStatus:@"请输入电话"];
        return;
    }
    
    NSString *careObject = nil;
    if (self.careID) {
        careObject = self.careID;
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择照护对象"];
        return;
    }
    
    NSString *serTime = @"";
    if(self.timeString.length<=0) {
        [SVProgressHUD showInfoWithStatus:@"请选择预约时间"];
        return;
    }else{
        NSArray *timeArr = [self.timeString componentsSeparatedByString:@","];
        if(timeArr.count==1){
            serTime= [self.timeString stringByAppendingString:@":00"];
        }else if (timeArr.count>=2){
            for (NSString *t in timeArr) {
                serTime=[serTime stringByAppendingString:[NSString stringWithFormat:@"%@,",[t stringByAppendingString:@":00"]] ];
            }
            serTime = [serTime substringToIndex:serTime.length-1];
        }
    }
    
    
    if(self.addressString.length<=0) {
        [SVProgressHUD showInfoWithStatus:@"请输入地址"];
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
    
    NSString *repeatWeek = nil;
    repeatWeek = self.repeatLString;
    if([repeatWeek isEqualToString:@"一周"]){
        repeatWeek=@"1";
    }else if([repeatWeek isEqualToString:@"两周"]){
        repeatWeek = @"2";
    }else if([repeatWeek isEqualToString:@"三周"]){
        repeatWeek = @"3";
    }else if([repeatWeek isEqualToString:@"四周"]){
        repeatWeek=@"4";
    } else{
        repeatWeek=@"";
    }
    
    if(self.addrId.length<=0){
        
    }else{
       self.addressString = @"";
    }
    if(self.addrId==nil){
        self.addrId = @"";
    }
    
    NSDictionary *dictP = @{ @"servType":serverT,
                             @"servItem":serverItem,
                             @"contactUser":_nameString,
                             @"contactPhone":_phoneString,
                             @"careObjId":careObject,
                             @"servTime":serTime,
                             @"repeatWeek":repeatWeek,
                             @"address":_addressString,
                             @"otherContent":_remarkString,
                             @"orderPrice":orderPrice,
                             @"goodsPrice":goodsPrice,
                             @"longitude":_longitude,
                             @"atitude":_atitude,
                             @"addrId":_addrId
                             };

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
        _tableView.sectionFooterHeight = 0.1;
        //_tableView.sectionHeaderHeight = 0;
        //_tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        
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
        [seciton0 addObject:@"服务地址"];
        
        [_dataSource addObject:seciton0];
        
        NSMutableArray *section1 = [NSMutableArray array];
        [section1 addObject:@"服务类型"];
        [section1 addObject:@"服务项目"];
        [section1 addObject:@"服务时间"];
        [_dataSource addObject:section1];
        
        NSMutableArray *seciton2 = [NSMutableArray array];
       
        [seciton2 addObject:@""];
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
