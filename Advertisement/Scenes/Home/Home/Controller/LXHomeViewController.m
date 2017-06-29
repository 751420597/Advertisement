//
//  LXHomeViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXHomeViewController.h"

#import "LXHomeSearchView.h"
#import "LXHomeReservationView.h"
#import "LXHomeOrderView.h"
#import "LXHomeRemindView.h"
#import "LXHomeTitleView.h"

#import "LXReservationViewController.h"
#import "LXSelectCityViewController.h"
#import "AddressViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface LXHomeViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    CLLocation *location;//用户定位地址
    
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
@property (nonatomic, strong) UITableView *mapTableView;
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
    
    
    [self.view addSubview:self.mapTableView];
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
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self setUpSubViews];
    [self setUpMapUserLocation];
    
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

- (void)setUpMapUserLocation {
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = YES;
    r.showsHeadingIndicator = YES;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
    r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
    r.strokeColor = [UIColor blackColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
    r.lineWidth = 50;///精度圈 边线宽度，默认0
    [self.mapView updateUserLocationRepresentation:r];
}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    location = userLocation.location;
    
    //确定地图经纬度
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    //设置的当前位置 为地图中心
    _mapView.centerCoordinate = coordinate;
//    if (_isFirstAppear)
//    {
//        //周边检索
//        [self CloudSearch:coordinate];
//    }
}
//#pragma  mark - 建立周边检索
//- (void)CloudSearch:(CLLocationCoordinate2D)coordinate
//{
//    /**请求参数类为 AMapPOIAroundSearchRequest，location是必设参数。 */
//    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
//    request.location            = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    
//        /* 按照距离排序. */
//        request.sortrule            = 0;
//        //request.radius = Kdistance;
//        request.requireExtension    = YES;
//    
//    
//    // 调用 AMapSearchAPI 的 AMapPOIAroundSearch 并发起周边检索。
//    [self.search AMapPOIAroundSearch:request];
//}
//#pragma mark - POI 搜索回调
//- (void)searchRequest:(id)request didFailWithError:(NSError *)error
//{
//    NSLog(@"搜索失败");
//}
///**
// * 当检索成功时，会进到 onPOISearchDone 回调函数中，通过解析AMapPOISearchResponse 对象把检索结果在地图上绘制点展示出来。
// */
//- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
//{
//    [self.Titles removeAllObjects];
//    //判断是否为空
//    if (response) {
//        //取出搜索到的POI（POI：Point Of Interest）
//        for (AMapPOI *poi in response.pois) {
//            
//            [self.Titles addObject:poi];
//            [_mapTableView reloadData];
//            
//            _isFirstAppear = NO;
//        }
//    }
//}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.Titles.count;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident =@"cell";
    UITableViewCell *taskListCell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!taskListCell) {
        taskListCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    AMapTip *tip =self.Titles[indexPath.row];
    taskListCell.textLabel.text = tip.name;
    taskListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return taskListCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapTip *tip =self.Titles[indexPath.row];
    _selectAdressTF.text =tip.name;
    [self.view sendSubviewToBack:_mapTableView];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.text.length>0){
        [self searchTipsWithKey:textField.text];
        [self.view bringSubviewToFront:_mapTableView];
    }

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //整数控制在八位,小数最多为11位...
    NSString *keyword = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(keyword.length==0){
        [self.view sendSubviewToBack:_mapTableView];
    }
    return YES;
}
#pragma  mark - /* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    //以北京为主要城市进行搜索，可搜索其他城市
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city     = @"北京";
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - AMapSearchDelegate
/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.Titles removeAllObjects];
    //判断是否为空
    if (response) {
        //取出搜索到的POI（POI：Point Of Interest）
        for (AMapTip *tip in response.tips) {
            [self.Titles addObject:tip];
        }
        [_mapTableView reloadData];
    }
}
-(UITableView *)mapTableView{
    if(!_mapTableView){
    _mapTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchView.frame), LXScreenWidth, LXScreenHeight-65-CGRectGetMaxY(_searchView.frame))];
    _mapTableView.delegate = self;
    _mapTableView.dataSource = self;
    _mapTableView.backgroundColor =[UIColor whiteColor];
    _mapTableView.tableFooterView = [[UIView alloc]init];
    }
    return _mapTableView;
}

#pragma mark - Aciton

- (void)callUp {
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"平台电话" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *call1 = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alterVC addAction:cancel];
    [alterVC addAction:call1];

    [self presentViewController:alterVC animated:YES completion:^{
        
    }];
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
        
        _searchView.block = ^{
            
        };
        [_searchView setLayerShadow:[UIColor lightGrayColor] offset:CGSizeMake(5, 5) radius:3];
    }
    return _searchView;
}

-(UITextField *)selectAdressTF{
    if (!_selectAdressTF) {
        
        _selectAdressTF =[[UITextField alloc]initWithFrame:CGRectMake(36, 0,LXScreenWidth - 10 * 2-16 , 37)];
        _selectAdressTF.placeholder = @"请输入地址";
        _selectAdressTF.delegate = self;
    }
    return _selectAdressTF;
}
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
        _orderView = [[LXHomeOrderView alloc] initWithImageString:@"Home_order" block:^{
            
        }];
    }
    return _orderView;
}

- (LXHomeRemindView *)remindView {
    if (!_remindView) {
        _remindView = [[LXHomeRemindView alloc] initWithRemindString:@"温馨提示：老司机开车咯！" didClosedBlock:^{
            
        }];
        
        [_remindView setFrame:CGRectMake(10, self.searchView.bottom + 10, LXScreenWidth - 10 * 2, 30)];
    }
    return _remindView;
}

- (LXHomeTitleView *)titleView {
    if (!_titleView) {
        LXWeakSelf(self);
        
        _titleView = [[LXHomeTitleView alloc] initWithClickBlock:^{
            LXSelectCityViewController *selectCityVC = [[LXSelectCityViewController alloc] init];
            selectCityVC.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:selectCityVC animated:YES];
            
            NSLog(@"Click");
        }];
        
        [_titleView setFrame:CGRectMake(0, 0, 160, 30)];
    }
    return _titleView;
}


@end
