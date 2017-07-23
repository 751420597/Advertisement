//
//  LXServiceDetailViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXServiceDetailViewController.h"

#import "LXServiceDetailVCTableCell.h"
#import "PSCarouselView.h"

#import "LXServiceDetailModel.h"
#import "LXServiceDetailViewModel.h"

static NSString *const LXServiceDetailVCTableCellID = @"LXServiceDetailVCTableCellID";
static CGFloat LXServiceDetailTableViewOriginX = 0;
static CGFloat LXServiceDetailTableViewOriginY = 0;
#define LXServiceDetailTableViewHeight  (LXScreenHeight - LXNavigaitonBarHeight - LXServiceDetailTableViewOriginY)
#define LXServiceDetailTableViewWidth   (LXScreenWidth - LXServiceDetailTableViewOriginX * 2)

static CGFloat LXServiceDetailTableViewRowHeight = 35;
static CGFloat LXServiceDetailBannerHeight = 175;

@interface LXServiceDetailViewController () <PSCarouselDelegate>

@property (nonatomic, strong) LXServiceDetailViewModel *viewModel;


@end


@implementation LXServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务详情";
    self.view.backgroundColor = LXVCBackgroundColor;

    [self setUpTable];
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXServiceDetailViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{ @"goodsId":self.goodsId};
    
    [self.viewModel getServiceDetailWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            [self.dataSource removeAllObjects];
            NSMutableArray *section0 = [NSMutableArray array];
            NSString *goodsPrice =result[@"goodsPrice"];
            goodsPrice= [goodsPrice substringWithRange:NSMakeRange(0, goodsPrice.length-2)];
            [section0 addObject:@"服务项目"];
            [section0 addObject:result[@"goodsName"]];
            
            NSMutableArray *seciton1 = [NSMutableArray array];
            [seciton1 addObject:@"服务价格"];
            [seciton1 addObject:[NSString stringWithFormat:@"￥：%@元/次", goodsPrice  ]];
            
            NSMutableArray *section2 = [NSMutableArray array];
            [section2 addObject:@"服务内容"];
            [section2 addObject:result[@"goodsDesc"]];
            
            [self.dataSource addObject:section0];
            [self.dataSource addObject:seciton1];
            [self.dataSource addObject:section2];
            
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - Set up

- (void)setUpTable {
    PSCarouselView *carouseView = [[PSCarouselView alloc] initWithFrame:CGRectMake(0, 0, LXServiceDetailTableViewWidth, LXServiceDetailBannerHeight) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    carouseView.pageDelegate = self;
    carouseView.autoMoving = NO;
    carouseView.placeholder = [UIImage imageNamed:@"Mine_top_backgroud"];
    carouseView.imageURLs = @[@"Mine_top_backgroud"];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXServiceDetailTableViewWidth, LXServiceDetailBannerHeight)];
    [topView addSubview:carouseView];
    
    [self setUpTableViewWithFrame:CGRectMake(LXServiceDetailTableViewOriginX, LXServiceDetailTableViewOriginY, LXServiceDetailTableViewWidth, LXServiceDetailTableViewHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    self.tableView.separatorColor = LXCellBorderColor;
    self.tableView.sectionHeaderHeight = 10;
    [self.tableView setTableHeaderView:topView];
    
    NSMutableArray *section0 = [NSMutableArray array];
    [section0 addObject:@"服务项目"];
    [section0 addObject:@"头面部部清洁、梳理服务"];
    
    NSMutableArray *seciton1 = [NSMutableArray array];
    [seciton1 addObject:@"服务价格"];
    [seciton1 addObject:@"￥:50元/人次"];
    
    NSMutableArray *section2 = [NSMutableArray array];
    [section2 addObject:@"服务内容"];
    [section2 addObject:@"让护理对象"];
    
    [self.dataSource addObject:section0];
    [self.dataSource addObject:seciton1];
    [self.dataSource addObject:section2];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXServiceDetailVCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:LXServiceDetailVCTableCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXServiceDetailVCTableCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell value:tempString];
    
    cell.detailL.text = tempString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    
    if ([tempIndexPath isEqual:indexPath]) {
        return 50;
    }
    else {
        return LXServiceDetailTableViewRowHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXServiceDetailTableViewWidth, 10)];
    [tempView setBackgroundColor:LXVCBackgroundColor];
    return tempView;
}


#pragma mark - Private

- (void)configureCell:(LXServiceDetailVCTableCell *)cell value:(NSString *)value {
    if (!([value isEqualToString:@"服务项目"] || [value isEqualToString:@"服务价格"] || [value isEqualToString:@"服务内容"])) {
        cell.widthConstraint.constant = 0;
        [cell.detailL setTextColor:LXColorHex(0x666666)];
    }
}

@end
