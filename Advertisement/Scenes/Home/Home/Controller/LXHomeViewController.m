//
//  LXHomeViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXHomeViewController.h"
#import "MapApiViewModel.h"
#import "LXHomeSearchView.h"
#import "LXHomeReservationView.h"
#import "LXHomeOrderView.h"
#import "LXHomeRemindView.h"
#import "LXHomeTitleView.h"
#import "LXWaitOrderViewController.h"
#import "LXReservationViewController.h"
#import "LXSelectCityViewController.h"
#import "AddressViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapViewController.h"
#define Kdistance 500
#define kMovePoint @"移动点"
@interface LXHomeViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    CLLocation *location;//用户定位地址
    MACircle *circle;   //浅蓝色圆圈
    MAPointAnnotation *movedPoint; //移动的大头针
    NSString *mapWorker;
    
}
@property (nonatomic, strong) UIButton *rightBarButton;
@property (nonatomic, strong) LXHomeSearchView *searchView;
@property (nonatomic, strong) LXHomeRemindView *remindView;
@property (nonatomic, strong) LXHomeReservationView *reservationView;
@property (nonatomic, strong) LXHomeOrderView *orderView;
@property (nonatomic, strong) LXHomeTitleView *titleView;
@property (nonatomic, strong) UITextField *selectAdressTF;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, assign) BOOL isFirstAppear;   //是否第一次加载地图
@property (nonatomic, strong) NSMutableArray *Titles;    //poi范围搜索结果
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) NSMutableArray *annotations;//所有的大头针
@end


@implementation LXHomeViewController

#pragma mark - View Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
    
    
    self.Titles =[NSMutableArray array];
    [self.view addSubview:self.searchView];
    [self.searchView addSubview:self.selectAdressTF];
    
    
    [self.view sendSubviewToBack:self.searchView];
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    _isFirstAppear = YES;
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    //[self.view sendSubviewToBack:self.mapView];
    self.mapView.showsCompass = NO;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    
    [self setUpSubViews];
//    [self setUpMapUserLocation];
    //确定地图经纬度
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(23.1494,113.2572);
            //设置的当前位置 为地图中心
    _mapView.centerCoordinate = coordinate;
    [_mapView setZoomLevel:10.5 animated:YES];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


#pragma mark - Set up

- (void)setUpSubViews {
    LXWeakSelf(self);
    
    [self.view bringSubviewToFront:self.searchView];
    [self.view addSubview:self.remindView];
    [self.view bringSubviewToFront:self.remindView];
    
    [self.view addSubview:self.reservationView];
    [self.view bringSubviewToFront:self.reservationView];
    [self.reservationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.view).mas_offset(LXRate(20));
        make.bottom.mas_equalTo(weakself.mas_bottomLayoutGuide).mas_offset(LXRate(-20));
        make.width.mas_equalTo(LXRate(115));
        make.height.mas_equalTo(LXRate(44));
    }];
    self.reservationView.layer.cornerRadius = LXRate(44) / 2;
    
    [self.view addSubview:self.orderView];
    [self.view bringSubviewToFront:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakself.view).mas_offset(LXRate(-20));
        make.bottom.mas_equalTo(weakself.mas_bottomLayoutGuide).mas_offset(LXRate(-20));
        make.width.mas_equalTo(LXRate(115));
        make.height.mas_equalTo(LXRate(44));
    }];
    self.orderView.layer.cornerRadius = LXRate(44) / 2;
}

//- (void)setUpMapUserLocation {
//    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
//    r.showsAccuracyRing = YES;
//    r.showsHeadingIndicator = YES;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
//    r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
//    r.strokeColor = [UIColor blackColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
//    r.lineWidth = 50;///精度圈 边线宽度，默认0
//    [self.mapView updateUserLocationRepresentation:r];
//}
//-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
//{
//    if(updatingLocation){
//        location = userLocation.location;
//        
//        //确定地图经纬度
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//        //设置的当前位置 为地图中心
//        _mapView.centerCoordinate = coordinate;
//        if (_isFirstAppear)
//        {
//            //周边检索
//            [self CloudSearch:coordinate];
//        }
//    }
//    
//}
#pragma mark - MAMapViewDelegate
//大头针样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *pointReuseIndetifier;
        if (annotation ==self.annotations.firstObject) {
            pointReuseIndetifier = @"pointReuseIndetifier2";
        }
        else{
            pointReuseIndetifier = @"pointReuseIndetifier";
        }
        MAAnnotationView *annotationView =[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
           // annotationView.tintColor                     = [self.annotations indexOfObject:annotation] % 3;
        }
        annotationView.canShowCallout               = YES;
        annotationView.image =[UIImage imageNamed:@"Home_reservation_ pin"];
        
//        if (annotation !=self.annotations.firstObject)
//        {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame = CGRectMake(0, 0, 30, 30);
//            [btn setBackgroundImage:[UIImage imageNamed:@"totle3"] forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            annotationView.rightCalloutAccessoryView = btn;
//            annotationView.rightCalloutAccessoryView.hidden = YES;
//        }
        
        return annotationView;
    }
    else if([annotation isKindOfClass:[MKUserLocation class]] )
    {
        [mapView deselectAnnotation:annotation animated:NO];
    }
    return nil;
}

-(void)searchMapWithCClongitude:(CGFloat)longitude Withlatitude:(CGFloat)latitude
{
    //    [self.mapView removeAnnotations:self.mapView.annotations];
    //    [self.mapView addAnnotation:movedPoint];
    
    //清除除移动点以外的图钉
    for (MAPointAnnotation *annotation in self.mapView.annotations) {
        if (![annotation.title isEqualToString:kMovePoint]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    
    NSMutableArray *poiAnnotations = [NSMutableArray array];
    
    
           // AMapGeoPoint *position = locationModel.location;
        
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude,longitude);
            
    //NSString *address = locationModel.district;
            
   // BOOL isContains = MACircleContainsCoordinate(location, self.mapView.centerCoordinate, 1000); //是否在区域范围内
//    if (isContains)
//        {
            MAPointAnnotation *poiAnnotation = [[MAPointAnnotation alloc] init];
            poiAnnotation.coordinate = location;
            poiAnnotation.title = mapWorker;
            //poiAnnotation.subtitle = address;
            [poiAnnotations addObject:poiAnnotation];
//        }
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    [self.mapView setSelectedAnnotations:poiAnnotations];
    [self addMACircleViewWithCenter:CLLocationCoordinate2DMake(latitude, longitude) radius:1000];
}
- (void)addMACircleViewWithCenter:(CLLocationCoordinate2D)center radius:(double)radius
{
    if (circle != nil)
    {
        [self.mapView removeOverlays:self.mapView.overlays];
    }
    
    NSLog(@"%lu",(unsigned long)self.mapView.overlays.count);
    //CLLocationCoordinate2D coord =[self.mapView convertPoint:movedPoint.lockedScreenPoint toCoordinateFromView:self.view];
    CLLocationCoordinate2D coord = center;
    circle = [MACircle circleWithCenterCoordinate:coord radius:radius];
    
    [self.mapView addOverlay:circle];
    [_mapView setZoomLevel:13.5 animated:YES];
    [_mapView setCenterCoordinate:center animated:YES];
}

#pragma mark - MAMapViewDelegate
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.fillColor        = LXColorHex(0x3385ff);
        circleRenderer.strokeColor      = LXColorHex(0x3385ff);
        circleRenderer.lineWidth = 2.5;
        circleRenderer.alpha = 0.16;
        return circleRenderer;
    }
    return nil;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if(textField.text.length>0){
//        self.mapView.showsUserLocation= NO;
//        //AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc]init];
//        //request.address = textField.text;
//       // [self.search AMapGeocodeSearch:request];
//
//        [self searchTipsWithKey:textField.text];
//    }
//
//}

#pragma mark - AMapSearchDelegate

///* 理编码回调. */
//- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
//{
//    if (response.geocodes.count == 0)
//    {
//        return;
//    }else{
//        [self.Titles removeAllObjects];
//                    //判断是否为空
//            if (response) {
//                //取出搜索到的POI（POI：Point Of Interest）
//                for (AMapGeocode *geocode in response.geocodes) {
//            
//                    [self.Titles addObject:geocode];
//                    _isFirstAppear = NO;
//                }
//            }
//        AMapGeocode *geo =self.Titles.firstObject;
//        [self searchMapWithCClongitude:geo.location.longitude Withlatitude:geo.location.latitude];
//    }
//}
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    if (response.regeocode != nil )
//    {
//        [self.Titles removeAllObjects];
//        //判断是否为空
//        if (response) {
//            //取出搜索到的POI（POI：Point Of Interest）
//            for (AMapPOI *poi in response.regeocode.pois) {
//                
//                [self.Titles addObject:poi];
//                
//                
//                _isFirstAppear = NO;
//            }
//        }
//    }
//}

//#pragma mark - TableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return self.Titles.count;
//    
//    
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *ident =@"cell";
//    UITableViewCell *taskListCell = [tableView dequeueReusableCellWithIdentifier:ident];
//    if (!taskListCell) {
//        taskListCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
//    }
//    AMapTip *tip =self.Titles[indexPath.row];
//    taskListCell.textLabel.text = tip.name;
//    taskListCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return taskListCell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AMapTip *tip =self.Titles[indexPath.row];
//    _selectAdressTF.text =tip.name;
//    
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if(textField.text.length>0){
//        [self searchTipsWithKey:textField.text];
//        
//    }
//
//}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    //整数控制在八位,小数最多为11位...
//    NSString *keyword = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if(keyword.length==0){
//       
//    }
//    return YES;
//}
//#pragma  mark - /* 输入提示 搜索.*/
//- (void)searchTipsWithKey:(NSString *)key
//{
//    if (key.length == 0)
//    {
//        return;
//    }
//    //以北京为主要城市进行搜索，可搜索其他城市
//    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
//    tips.keywords = key;
//    tips.city     = @"广州";
//    tips. cityLimit = NO;
//    [self.search AMapInputTipsSearch:tips];
//}
////
//#pragma mark - AMapSearchDelegate
///* 输入提示回调. */
//- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
//{
//    [self.Titles removeAllObjects];
//    //判断是否为空
//    if (response) {
//        //取出搜索到的POI（POI：Point Of Interest）
//        for (AMapTip *tip in response.tips) {
//            [self.Titles addObject:tip];
//        }
//        if(self.Titles.count>1){
//            AMapTip *geo =self.Titles[1];
//            CGFloat longitude = geo.location.longitude;
//            CGFloat latitude = geo.location.latitude;
//            LXWeakSelf(self);
//            NSBlockOperation *loadPeopleOperation = [NSBlockOperation blockOperationWithBlock:^{
//                
//                [weakself loadPeopleLongitude:[NSString stringWithFormat:@"%.4f",longitude] latitude:[NSString stringWithFormat:@"%.4f",latitude]];
//            }];
//            
//            NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
//            [operationQueue addOperations:@[loadPeopleOperation] waitUntilFinished:YES];
//           
//        }else if(self.Titles.count==1){
//            AMapTip *geo =self.Titles[0];
//            CGFloat longitude = geo.location.longitude;
//            CGFloat latitude = geo.location.latitude;
//            
//            NSBlockOperation *loadPeopleOperation = [NSBlockOperation blockOperationWithBlock:^{
//                [self loadPeopleLongitude:[NSString stringWithFormat:@"%.4f",longitude] latitude:[NSString stringWithFormat:@"%.4f",latitude]];
//            }];
//            
//            //NSBlockOperation *mapOperation = [NSBlockOperation blockOperationWithBlock:^{
//            
//            
//            //}];
//            
//            //[mapOperation addDependency:loadPeopleOperation];
//            NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
//            [operationQueue addOperations:@[loadPeopleOperation] waitUntilFinished:YES];
//            
//        }else{
//            [SVProgressHUD showInfoWithStatus:@"未查到该地址!"];
//        }
//       
//    }
//}
-(void)loadPeopleLongitude:(NSString *)longitude latitude:(NSString *)latitude {
    
    [SVProgressHUD showInfoWithStatus:@"正在为您查询..."];
    MapApiViewModel *viewModel = [[MapApiViewModel alloc]init];
    [viewModel loadMapSourceWithDictionaryfetchOrganizaitonListWithParameters:@{@"longitude":longitude,@"latitude":latitude} completionHandler:^(NSError *error, id result) {
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if(code==0){
            mapWorker = [NSString stringWithFormat:@"附近有%d位服务者",[result[@"workerCount"] intValue]];
             [self searchMapWithCClongitude:[longitude floatValue] Withlatitude:[latitude floatValue]];
        }else{
            mapWorker = @"获取附近服务者失败!";
        }
        
     }];
}
#pragma mark - Aciton

- (void)callUp {
//    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"平台电话" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    
//    UIAlertAction *call1 = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    
//    [alterVC addAction:cancel];
//    [alterVC addAction:call1];
//
//    [self presentViewController:alterVC animated:YES completion:^{
//    
//        
//    }];
    
    UIWebView *callWebView = [[UIWebView alloc]init];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:010-52905489"]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:callWebView];

}


#pragma mark - Getter

- (UIButton *)rightBarButton {
    if (!_rightBarButton) {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setBackgroundImage:[UIImage imageNamed:@"Home_telephone"] forState:UIControlStateNormal];
        [_rightBarButton setFrame:CGRectMake(0, 0, 20, 20)];
        [_rightBarButton addTarget:self action:@selector(callUp) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

- (LXHomeSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[LXHomeSearchView alloc] initWithFrame:CGRectMake(10, 10, LXScreenWidth - 10 * 2, 37)];
        _searchView.layer.cornerRadius = 37 / 2;
        _searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _searchView.layer.borderWidth = .5f;
        LXWeakSelf(self);
        _searchView.block = ^{
            MapViewController *mapViewVC =[MapViewController new];
            mapViewVC.hidesBottomBarWhenPushed = YES;
            LXStrongSelf(self);
            mapViewVC.mapBlock = ^(CGFloat longatiude, CGFloat latitudu) {
                NSBlockOperation *loadPeopleOperation = [NSBlockOperation blockOperationWithBlock:^{
                                    [self loadPeopleLongitude:[NSString stringWithFormat:@"%.4f",longatiude] latitude:[NSString stringWithFormat:@"%.4f",latitudu]];
                                }];
                    
                                //[mapOperation addDependency:loadPeopleOperation];
                                NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
                                [operationQueue addOperations:@[loadPeopleOperation] waitUntilFinished:YES];
            };
            [weakself.navigationController pushViewController:mapViewVC animated:YES];
        };
        [_searchView setLayerShadow:[UIColor lightGrayColor] offset:CGSizeMake(5, 5) radius:3];
    }
    return _searchView;
}

-(UITextField *)selectAdressTF{
    if (!_selectAdressTF) {
        
        _selectAdressTF =[[UITextField alloc]initWithFrame:CGRectMake(36, 0,LXScreenWidth - 10 * 2-16 , 37)];
        _selectAdressTF.placeholder = @"请输入地址";
        _selectAdressTF.enabled = NO;
        _selectAdressTF.delegate = self;
        _selectAdressTF.returnKeyType = UIReturnKeyDefault;
    }
    return _selectAdressTF;
}
//预约服务按钮
- (LXHomeReservationView *)reservationView {
    if (!_reservationView) {
        LXWeakSelf(self);
        _reservationView = [[LXHomeReservationView alloc] initWithClickBlock:^{
            LXReservationViewController *reservationVC = [[LXReservationViewController alloc] init];
            reservationVC.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:reservationVC animated:YES];
        }];
        [_reservationView setFrame:CGRectZero];
    }
    return _reservationView;
}

- (LXHomeOrderView *)orderView {
    if (!_orderView) {
         LXWeakSelf(self);
        _orderView = [[LXHomeOrderView alloc] initWithImageString:@"Home_order" block:^{
         LXWaitOrderViewController *waitOder=  [[LXWaitOrderViewController alloc] init];
            waitOder.title = @"待接单";
            waitOder.isHome = YES;
            waitOder.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:waitOder animated:YES];
        }];
    }
    return _orderView;
}

- (LXHomeRemindView *)remindView {
    if (!_remindView) {
        LXWeakSelf(self)
        _remindView = [[LXHomeRemindView alloc] initWithRemindString:@"温馨提示：可到“我的-照护对象”中进行长护险待遇申请。" didClosedBlock:^{
            [weakself.remindView removeFromSuperview];
        }];
        
        [_remindView setFrame:CGRectMake(10, self.searchView.bottom + 10, LXScreenWidth - 10 * 2, 30)];
    }
    return _remindView;
}

- (LXHomeTitleView *)titleView {
    if (!_titleView) {
        LXWeakSelf(self);
        
        _titleView = [[LXHomeTitleView alloc] initWithClickBlock:^{
//           LXSelectCityViewController *selectCityVC = [[LXSelectCityViewController alloc] init];
//            selectCityVC.hidesBottomBarWhenPushed = YES;
//            [weakself.navigationController pushViewController:selectCityVC animated:YES];
            
            NSLog(@"Click");
        }];
        
        [_titleView setFrame:CGRectMake(0, 0, 160, 30)];
    }
    return _titleView;
}


@end
