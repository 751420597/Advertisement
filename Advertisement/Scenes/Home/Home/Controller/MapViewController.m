//
//  MapViewController.m
//  OA
//
//  Created by xinping-2 on 16/9/19.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "LXHomeSearchView.h"
#define TipPlaceHolder @"搜索地点"
#define Kdistance 500

@import MapKit;
@interface MapViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
   
    UITableView *_mapTableView;
    UISearchDisplayController *searchDisplayController;//搜索展示界面
}
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UITextField *selectAdressTF;
@property (nonatomic, strong) LXHomeSearchView *searchView;

@property (nonatomic, strong) NSMutableArray *Titles;    //poi范围搜索结果

@property (nonatomic,strong) UISearchBar *searchBar;//搜索框

@property (nonatomic, strong) NSMutableArray *tips; //搜索结果

@end

@implementation MapViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.searchView ;
    [self.searchView addSubview:self.selectAdressTF];
    self.view.backgroundColor =[UIColor whiteColor];
    self.Titles = [NSMutableArray array];
    self.tips = [NSMutableArray array];
    
    //[self initSearchBar];
    
    _mapTableView = [[UITableView alloc] init];
    _mapTableView.frame = CGRectMake(0, 0, LXScreenWidth, LXScreenHeight-LXNavigaitonBarHeight);
    _mapTableView.dataSource = self;
    _mapTableView.delegate = self;
    _mapTableView.showsVerticalScrollIndicator = NO;
    _mapTableView.rowHeight = LXScreenHeight/11;
    _mapTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_mapTableView];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}
- (void)setCoordinate2:(CLLocationCoordinate2D)coordinate2
{
    _coordinate2 = coordinate2;
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"Cell_MapCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.tag = 19997;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailLabel.textColor = LXColorHex(0x999999);
        detailLabel.tag = 19998;
        detailLabel.font = [UIFont systemFontOfSize:14.f];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:detailLabel];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.tag = 19999;
        [cell.contentView addSubview:image];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //标题
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:19997];
    //titleLabel.frame = CGRectMake([AdaptInterface convertWidthWithWidth:15], [AdaptInterface convertHeightWithHeight:8], [AdaptInterface convertWidthWithWidth:320], [AdaptInterface convertWidthWithWidth:20]);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(cell.contentView).mas_offset(38);
        make.top.mas_equalTo(cell.contentView).mas_offset(8);
        make.trailing.mas_equalTo(cell.contentView).mas_offset(-15);
    }];
    
     UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:19998];
        //detailLabel.frame = CGRectMake([AdaptInterface convertWidthWithWidth:15], CGRectGetMaxY(titleLabel.frame), [AdaptInterface convertWidthWithWidth:320], [AdaptInterface convertWidthWithWidth:20]);
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(cell.contentView).mas_offset(38);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(7);
        make.trailing.mas_equalTo(cell.contentView).mas_offset(-15);
    }];
    
    UIImageView *mark = (UIImageView *)[cell.contentView viewWithTag:19999];
    //mark.frame = CGRectMake(currentViewWidth- [AdaptInterface convertWidthWithWidth:10+40/2], [AdaptInterface convertHeightWithHeight:34/2], [AdaptInterface convertWidthWithWidth:40/2], [AdaptInterface convertHeightWithHeight:40/2]);
    mark.image = [UIImage imageNamed:@"Home_reservation_ pin"];
    [mark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(cell.contentView).mas_offset(15);
        make.top.mas_equalTo(cell.contentView).mas_offset(10);
        make.width.mas_offset(18);
        make.height.mas_offset(18);

    }];
    
    
        if (self.tips.count > 0) {
         AMapTip *tip = self.tips[indexPath.row];
            if (tip != nil)
            {
                titleLabel.text = tip.name;
                detailLabel.text = [NSString stringWithFormat:@"%@%@",tip.district,tip.address];
            }
        }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if (self.tips.count > 0) {
            AMapTip *tip = self.tips[indexPath.row];
            if (tip != nil) {
                //[self changeAnnotationWithLatitude:tip.location.latitude AndLongitude:tip.location.longitude];
                if(self.mapBlock){
                    self.mapBlock(tip.location.longitude, tip.location.latitude);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
                //selectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            }
        }
}

- (LXHomeSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[LXHomeSearchView alloc] initWithFrame:CGRectMake(10, 10, LXScreenWidth - 10 * 2-30, 30)];
        _searchView.layer.cornerRadius = 30 / 2;
        _searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _searchView.layer.borderWidth = .5f;
        _searchView.backgroundColor =[UIColor whiteColor];
       
        _searchView.block = ^{
        };
        [_searchView setLayerShadow:[UIColor lightGrayColor] offset:CGSizeMake(5, 5) radius:3];
    }
    return _searchView;
}

-(UITextField *)selectAdressTF{
    if (!_selectAdressTF) {
        
        _selectAdressTF =[[UITextField alloc]initWithFrame:CGRectMake(36, 0,LXScreenWidth - 10 * 2-30 , 30)];
        _selectAdressTF.placeholder = @"请输入地址";
        _selectAdressTF.font =[UIFont systemFontOfSize:14.5f];
        _selectAdressTF.delegate = self;
        _selectAdressTF.returnKeyType = UIReturnKeyDone;
    }
    return _selectAdressTF;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - UISearchBarDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self searchTipsWithKey:self.selectAdressTF.text];
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
    tips.city     = @"广州";
    tips.cityLimit = YES;
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - AMapSearchDelegate
/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips removeAllObjects];
    //判断是否为空
    if (response) {
        //取出搜索到的POI（POI：Point Of Interest）
        for (AMapTip *tip in response.tips) {
            if(tip.location!=nil &&tip.uid !=nil){
                [self.tips addObject:tip];
            }
            
            [_mapTableView reloadData];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"未查到相关地址"];
    }
}

//- (void)searchTap
//{
//    [self searchReGeocodeWithCoordinate:_tapCoordinate];
//}
//
//- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
//{
//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    regeo.requireExtension = YES;
//    [self.search AMapReGoecodeSearch:regeo];
//}
//
//#pragma mark - AMapSearchDelegate
///* 逆地理编码回调. */
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    if (response.regeocode != nil && _isSearchFromDragging == NO)
//    {
//        [self.Titles removeAllObjects];
//        //判断是否为空
//        if (response) {
//            //取出搜索到的POI（POI：Point Of Interest）
//            for (AMapPOI *poi in response.regeocode.pois) {
//                
//                [self.Titles addObject:poi];
//                [_mapTableView reloadData];
//                
//                _isFirstAppear = NO;
//            }
//        }
//    }
//}
@end
