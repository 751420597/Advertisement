//
//  LXServiceRecordeViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/13.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXServiceRecordeViewController.h"

#import "LXOderDealView.h"

#import "LXOrderCommentViewController.h"

#import "LXServiceRecordeModel.h"
#import "LXServiceRecordeViewModel.h"
#import "itemModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CWStarRateView.h"
#import "LXOrderDetailViewModel.h"
#import "LXReservationModel.h"
#import "OrderViewModel.h"
static CGFloat OrderDealViewHeight = 0;
static NSString *const LXServiceRecordeVCTableViewCellID = @"LXServiceRecordeVCTableViewCellID";
static NSString *const LXServiceRecordeVCTableViewCellID2 = @"LXServiceRecordeVCTableViewCellID2";

@interface LXServiceRecordeViewController ()<MAMapViewDelegate>
{
    MAPointAnnotation *ann;
    
}
@property (nonatomic, strong) OrderViewModel *orderViewModel;
@property (nonatomic, assign) LXReservationBottomType reservationBottomType;
@property (nonatomic, strong) LXOderDealView *orderDealView;

@property (nonatomic, strong) NSMutableArray *secitonTitles;

@property (nonatomic, strong) LXServiceRecordeViewModel *viewModel;
@property (nonatomic, strong) LXServiceRecordeModel *model;
@property (nonatomic, strong) LXOrderDetailViewModel *viewModel2;
@property (nonatomic, strong) LXReservationModel *reservationModel;
@end


@implementation LXServiceRecordeViewController

- (instancetype)initWithBottomType:(LXReservationBottomType)bottomeType {
    if (self = [super init]) {
        // 只有删除订单、待评价、已评价
        self.reservationBottomType = bottomeType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:LXVCBackgroundColor];
    
    [self setUpSubViews];
    
    
    [self getServiceData];
    [self getServiceData2];
}

- (void)getServiceData2 {
    self.viewModel2 = [LXOrderDetailViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{ @"orderId":self.orderId };
    
    [self.viewModel2 getDetailWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            self.reservationModel = [LXReservationModel modelWithDictionary:result];
            self.reservationModel.ordPrice = [ self.reservationModel.ordPrice substringWithRange:NSMakeRange(0, self.reservationModel.ordPrice.length-2)];
            [_orderDealView setLeadingString:[NSString stringWithFormat:@"￥：%@",self.reservationModel.ordPrice]];
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}

#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXServiceRecordeViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{ @"orderId":self.orderId };
    
    [self.viewModel getRecordeWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
        
            self.model = [LXServiceRecordeModel modelWithDictionary:result];
            if(self.model.takOrdTime.length>2){
                 self.model.takOrdTime = [self.model.takOrdTime substringWithRange:NSMakeRange(0, self.model.takOrdTime.length-2)];
            }else if(self.model.takOrdTime!=nil){
                self.model.takOrdTime = @"";
            }
            if(self.model.startTime.length>2){
                self.model.startTime =[self.model.startTime substringWithRange:NSMakeRange(0, self.model.startTime.length-2)];
            }else if(self.model.startTime!=nil){
                self.model.startTime = @"";
            }
            if(self.model.subOrdTime.length>2){
                self.model.subOrdTime =[self.model.subOrdTime substringWithRange:NSMakeRange(0, self.model.subOrdTime.length-2)];
            }else if(self.model.subOrdTime!=nil){
                self.model.subOrdTime = @"";
            }
            
            [self setUpTabale];
           
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}



#pragma mark - Set Up

- (void)setUpSubViews {
    [self.view addSubview:self.orderDealView];
    [self.view bringSubviewToFront:self.orderDealView];
    
    if (self.reservationBottomType == LXReservationBottomTypeNone) {
        self.orderDealView.hidden = YES;
        OrderDealViewHeight = 0;
    }
    else {
        self.orderDealView.hidden = NO;
        OrderDealViewHeight = 50;
    }
}

- (void)setUpTabale {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - LXNavigaitonBarHeight - 10 - OrderDealViewHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;

    
    self.secitonTitles = [NSMutableArray array];
    [self.secitonTitles addObject:@"服务已提交"];
    if([self.model.ordStateId isEqualToString:@"98"]){
        [self.secitonTitles addObject:@"服务已取消"];
    }
    if(self.model.takOrdTime!=nil){
        [self.secitonTitles addObject:@"服务已接单"];
    }
    if(self.model.startTime!=nil){
        [self.secitonTitles addObject:@"开始服务"];
    }
    if(self.model.longitude!=nil){
         [self.secitonTitles addObject:@"护工位置"];
    }
    if(self.model.serviceRecordList.count>0){
        for (NSDictionary *itemDic in self.model.serviceRecordList) {
            itemModel *itemM=[itemModel modelWithDictionary:itemDic];
            [self.secitonTitles addObject:itemM];
        }
        
    }
    if([self.model.isDone isEqualToString:@"1"]){
        [self.secitonTitles addObject:@"服务完成"];

    }
    
    [self.view addSubview:self.tableView];
    if(self.model.longitude!=nil){
        [self.tableView reloadRow:3 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return   [self.secitonTitles count];
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.model.cwEvList.count>0){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if(indexPath.section==0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXServiceRecordeVCTableViewCellID];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LXServiceRecordeVCTableViewCellID];
                UILabel *keyLabel = [[UILabel alloc] init];
                keyLabel.font = [UIFont systemFontOfSize:14];
                keyLabel.textColor = LXColorHex(0x4c4c4c);
                keyLabel.tag = 100;
                [cell.contentView addSubview:keyLabel];
                
                
                UILabel *timeLabel = [[UILabel alloc] init];
                timeLabel.font = [UIFont systemFontOfSize:12];
                timeLabel.textColor = LXColorHex(0xb2b2b2);
                timeLabel.tag = 101;
                [cell.contentView addSubview:timeLabel];
                
                UILabel *contentLabel = [[UILabel alloc] init];
                contentLabel.font = [UIFont systemFontOfSize:12];
                contentLabel.textColor = LXColorHex(0xb2b2b2);
                contentLabel.tag = 102;
                [cell.contentView addSubview:contentLabel];
                
                UIImageView *myImageView = [[UIImageView alloc] init];
                myImageView.tag = 103;
                myImageView.contentMode = UIViewContentModeScaleAspectFit;
                [myImageView setImage:[UIImage imageNamed:@"Mine_top_backgroud"]];
                [cell.contentView addSubview:myImageView];
                
                UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnImage setBackgroundImage:[UIImage imageNamed:@"Mine_massage_dot"] forState:UIControlStateNormal];
                btnImage.tag = 104;
                [cell.contentView addSubview:btnImage];
                
                UILabel *line = [[UILabel alloc] init];
                line.tag =105;
                line.backgroundColor = LXColorHex(0xb2b2b2);
                [cell.contentView addSubview:line];
                
                UILabel *titleLB =[[UILabel alloc]init];
                titleLB.font = [UIFont systemFontOfSize:14];
                titleLB.textColor = LXColorHex(0x4c4c4c);
                titleLB.tag = 106;
                [cell.contentView addSubview:titleLB];
                
                /** 在使用地图SDK时，需要对应用做Key机制验证,配置之前在官网上申请的Key*/
                [AMapServices sharedServices].apiKey =AMapAPIKey;
                /**创建地图*/
                
                MAMapView *_mapView = [[MAMapView alloc] init];
                //_mapView.userInteractionEnabled = NO;
                _mapView.delegate = self;
                _mapView.tag = 107;
                [cell.contentView addSubview:_mapView];
                
                ann = [[MAPointAnnotation alloc] init];
                
                [_mapView addAnnotation:ann];
                
            }
            UILabel *keyLabel = [cell.contentView viewWithTag:100];
            UILabel * timeLabel= [cell.contentView viewWithTag:101];
            UILabel * contentLabel= [cell.contentView viewWithTag:102];
            UIImageView * myImageView= [cell.contentView viewWithTag:103];
            UIButton *btnImage =[cell.contentView viewWithTag:104];
            UILabel *line = [cell.contentView viewWithTag:105];
            UILabel *titleLB = [cell.contentView viewWithTag:106];
            MAMapView *_mapView = [cell.contentView viewWithTag:107];
            line.hidden = NO;
            myImageView.hidden = YES;
            contentLabel.hidden = YES;
            _mapView.hidden = YES;
            [btnImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(10);
                make.height.mas_equalTo(10);
                make.leading.mas_equalTo(cell.contentView).mas_offset(10);
                make.top.mas_equalTo(cell.contentView).mas_offset(6);
            }];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView).mas_offset(14.5);
                make.width.mas_equalTo(1);
                make.top.mas_equalTo(btnImage).mas_offset(12);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(0);
            }];
            
            NSString *tempString = nil;
            itemModel *itemM = nil;
            if([self.secitonTitles[indexPath.row] isKindOfClass:[NSString class]]){
                tempString = self.secitonTitles[indexPath.row];
            }else{
                itemM =self.secitonTitles[indexPath.row];
            }

            keyLabel.text = tempString;
            if([tempString isEqualToString:@"服务已提交"]||[tempString isEqualToString:@"服务已接单"]||[tempString isEqualToString:@"服务已取消"]){
            if(indexPath.row==0){
                contentLabel.hidden = NO;
                timeLabel.text =self.model.subOrdTime;
                contentLabel.text=@"请耐心等待护理接单";
            }else {
                contentLabel.hidden = NO;
                timeLabel.text =self.model.takOrdTime;
                if(![tempString isEqualToString:@"服务已取消"]){
                contentLabel.text=@"请耐心等待服务";
                }
            }
            [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView).mas_offset(40);
                make.top.mas_equalTo(cell.contentView).mas_offset(5);
            }];
        
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-20);
                make.centerY.mas_equalTo(keyLabel);
            }];
            
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView).mas_offset(40);
                make.centerY.mas_equalTo(cell.contentView).mas_offset(10);
            }];
        }else if([tempString isEqualToString:@"开始服务"]){
            
            timeLabel.text = self.model.startTime;
            [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView).mas_offset(40);
                make.top.mas_equalTo(cell.contentView).mas_offset(5);
            }];
            
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-20);
                make.centerY.mas_equalTo(keyLabel);
            }];
            
        }else if ([tempString isEqualToString:@"服务完成"]) {
            line.hidden = YES;
            
            [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView).mas_offset(40);
                make.top.mas_equalTo(cell.contentView).mas_offset(5);
            }];
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-20);
                make.centerY.mas_equalTo(keyLabel);
            }];
        }else if([tempString isEqualToString:@"护工位置"]){
           
            //设置缩放级别
            //_mapView.visibleMapRect = MAMapRectMake(220880104, 101476980,100000, 100000);
            // 是否显示指南针
            _mapView.showsCompass = NO;
            // 是否显示比例尺
            _mapView.showsScale = NO;
            /**YES 为打开定位，NO为关闭定位*/
            _mapView.showsUserLocation = NO;
           [_mapView setZoomLevel:13.5 animated:YES];
            _mapView.scrollEnabled = NO;
            _mapView.zoomEnabled = YES;
            _mapView.hidden = NO;
            //地图类型，是一个枚举：MKMapTypeStandard :标准地图，一般情况下使用此地图即可满足；MKMapTypeSatellite ：卫星地图；MKMapTypeHybrid ：混合地图，加载最慢比较消耗资源；mapType
            _mapView.mapType = MKMapTypeStandard;
            
            
            ann.coordinate = CLLocationCoordinate2DMake([self.model.latitude floatValue], [self.model.longitude floatValue]);
            
            
            [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView).mas_offset(40);
                make.top.mas_equalTo(cell.contentView).mas_offset(5);
            }];
            
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-20);
                make.centerY.mas_equalTo(keyLabel);
            }];
            
            _mapView.frame = CGRectMake(40, 30,LXScreenWidth-70, 115);
            [_mapView setCenterCoordinate:ann.coordinate animated:YES];
        }else{
            myImageView.hidden = NO;
            keyLabel.text = itemM.itemName;
            [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView).mas_offset(40);
                make.top.mas_equalTo(cell.contentView).mas_offset(5);
            }];
            
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-20);
                make.centerY.mas_equalTo(keyLabel);
            }];
            [ myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.htm?id=%@", GetImage, itemM.imgId]] placeholderImage:[UIImage imageNamed:@"Mine_top_backgroud"]];
            [myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell.contentView).mas_equalTo(UIEdgeInsetsMake(30, 40, 5, 10));
            }];

        }
        
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXServiceRecordeVCTableViewCellID2];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LXServiceRecordeVCTableViewCellID2];
            UILabel *keyLabel = [[UILabel alloc] init];
            keyLabel.font = [UIFont systemFontOfSize:14];
            keyLabel.textColor = LXColorHex(0x4c4c4c);
            keyLabel.tag = 1000;
            [cell.contentView addSubview:keyLabel];
            
            
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.font = [UIFont systemFontOfSize:12];
            timeLabel.textColor = LXColorHex(0xb2b2b2);
            timeLabel.tag = 1001;
            [cell.contentView addSubview:timeLabel];
            
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.font = [UIFont systemFontOfSize:12];
            contentLabel.textColor = LXColorHex(0xb2b2b2);
            contentLabel.tag = 1002;
            [cell.contentView addSubview:contentLabel];
        
            
            UILabel *titleLB =[[UILabel alloc]init];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.textColor = LXColorHex(0x4c4c4c);
            titleLB.tag = 1006;
            [cell.contentView addSubview:titleLB];
            
            CWStarRateView *starView = [[CWStarRateView alloc]initWithFrame:CGRectMake(100, 16, 80, 40) numberOfStars:5];
            
            starView.allowIncompleteStar = YES;
            starView.hasAnimation = NO;
            starView.tag = 1007;
            starView.userInteractionEnabled = NO;
             starView.scorePercent = [self.model.cwEvList.firstObject[@"starLvlAll"] floatValue]/5;
            [cell.contentView addSubview:starView];
            
        }
        UILabel *keyLabel = [cell.contentView viewWithTag:1000];
        UILabel * timeLabel= [cell.contentView viewWithTag:1001];
        UILabel * contentLabel= [cell.contentView viewWithTag:1002];

        UILabel *titleLB = [cell.contentView viewWithTag:1006];
        titleLB . text = @"服务评价";
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView).mas_offset(20);
            make.top.mas_equalTo(cell.contentView).mas_offset(5);
        }];
        NSString *isAnon =self.model.cwEvList.firstObject[@"isAnon"];
        if([isAnon isEqualToString:@"1"]){
            keyLabel.text = @"匿名评价";
        }else{
            keyLabel.text = self.model.cwEvList.firstObject[@"tmUserName"];
        }
        
        [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView).mas_offset(20);
            make.top.mas_equalTo(titleLB).mas_offset(23);
        }];
        
       
        
        
        NSString *timeStr =self.model.cwEvList.firstObject[@"updTime"];
        timeLabel.text = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-2)];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(cell.contentView).mas_offset(-20);
            make.centerY.mas_equalTo(keyLabel);
        }];
        
        contentLabel.text = self.model.cwEvList.firstObject[@"evContent"];
        contentLabel.numberOfLines = 0;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView).mas_offset(20);
            make.top.mas_equalTo(keyLabel).mas_offset(23);
            make.trailing.mas_equalTo(cell.contentView).mas_offset(20);
            //make.bottom.mas_equalTo(cell.contentView).mas_offset(10);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *tempString = self.secitonTitles[indexPath.row];
    NSString *tempString = nil;
    itemModel *itemM = nil;
    if([self.secitonTitles[indexPath.row] isKindOfClass:[NSString class]]){
        tempString = self.secitonTitles[indexPath.row];
    }else{
        itemM =self.secitonTitles[indexPath.row];
    }
    if(indexPath.section==0){
        if ([tempString isEqualToString:@"服务已提交"] || [tempString isEqualToString:@"服务已接单"] ||[tempString isEqualToString:@"服务已取消"]) {
            return 60;
        }
        else if ([tempString isEqualToString:@"服务完成"]|| [tempString isEqualToString:@"开始服务"]) {
            return 30;
        }else{
            return 150;
        }
        
    }else{
        return 100;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
        return 0.1;
    }else{
        return 15;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth - 20, 30)];
    [bgView setBackgroundColor:LXVCBackgroundColor];
    
//    UILabel *dateLabel = [[UILabel alloc] init];
//    dateLabel.font = [UIFont systemFontOfSize:14];
//    dateLabel.backgroundColor = LXCellBorderColor;
//    
//    
//    [bgView addSubview:dateLabel];
//    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(bgView).mas_offset(40);
//        make.centerY.mas_equalTo(bgView);
//    }];
    
    return bgView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - Getter

- (LXOderDealView *)orderDealView {
    if (!_orderDealView) {
        LXWeakSelf(self);
        
        _orderDealView = [[LXOderDealView alloc] initWithTrailingClick:^{
            if ([self.orderIdState isEqualToString:@"5"]) {
                //[_orderDealView setTrailingString:@"待评价"];
                    LXOrderCommentViewController *ocVC = [[LXOrderCommentViewController alloc] init];
                    ocVC.orderId = self.orderId;
                    [weakself.navigationController pushViewController:ocVC animated:YES];
                
            }else if (self.reservationBottomType == LXReservationBottomTypeDeleteOrder) {
               // [_orderDealView setTrailingString:@"删除订单"];
                self.orderViewModel = [[OrderViewModel alloc]init];
                UIAlertAction *cancleAlter = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *confirmAlter = [UIAlertAction actionWithTitle:@" 确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.orderViewModel deleteOrderWithParameters:@{@"orderId":self.orderId} completionHandler:^(NSError *error, id result) {
                        int code = [result[@"code"] intValue];
                        if(code==0){
                            [SVProgressHUD showInfoWithStatus:@"订单删除成功!"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"哎呀,出错了!"];
                        }
                        
                        
                    }];
                    
                }];
                UIAlertController *alterVC =[UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除该条订单？" preferredStyle:UIAlertControllerStyleAlert];
                [alterVC addAction:cancleAlter];
                [alterVC addAction:confirmAlter];
                [self.navigationController presentViewController:alterVC animated:YES completion:nil];
            }

        }];
        
        [_orderDealView setFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - 50, LXScreenWidth, 50)];
        
//        
//        if (self.reservationBottomType == LXReservationBottomTypeWaitCommentOrder) {
//            [_orderDealView setTrailingString:@"待评价"];
//        }
//        else if (self.reservationBottomType == LXReservationBottomTypeHavenCommentOrder) {
//            [_orderDealView setTrailingString:@"已评价"];
//        }
//        else if (self.reservationBottomType == LXReservationBottomTypeDeleteOrder) {
//            [_orderDealView setTrailingString:@"删除订单"];
//        }
        
        
        if ([self.orderIdState isEqualToString:@"5"]) {
            [_orderDealView setTrailingString:@"待评价"];
        }else if ([self.orderIdState isEqualToString:@"6"]) {
            [_orderDealView setTrailingString:@"已评价"];
        }
        else if (self.reservationBottomType == LXReservationBottomTypeDeleteOrder) {
            [_orderDealView setTrailingString:@"删除订单"];
        }


    }
    return _orderDealView;
}

@end
