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

static CGFloat OrderDealViewHeight = 0;
static NSString *const LXServiceRecordeVCTableViewCellID = @"LXServiceRecordeVCTableViewCellID";

@interface LXServiceRecordeViewController ()

@property (nonatomic, assign) LXReservationBottomType reservationBottomType;
@property (nonatomic, strong) LXOderDealView *orderDealView;

@property (nonatomic, strong) NSMutableArray *secitonTitles;

@property (nonatomic, strong) LXServiceRecordeViewModel *viewModel;

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
    
    [self setUpTabale];
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXServiceRecordeViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{ @"orderId":self.orderId };
    
    [self.viewModel getRecordeWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
           
            
            [self.tableView reloadData];
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
    
    [self.dataSource addObject:@"请耐心等待处理订单"];
    [self.dataSource addObject:@"请耐心等待处理订单"];
    [self.dataSource addObject:@"请耐心等待处理订单"];
    [self.dataSource addObject:@"Mine_top_backgroud"];
    [self.dataSource addObject:@"Mine_top_backgroud"];
    [self.dataSource addObject:@"Mine_top_backgroud"];
    
    self.secitonTitles = [NSMutableArray array];
    [self.secitonTitles addObject:@"服务已提交"];
    [self.secitonTitles addObject:@"服务已接单"];
    [self.secitonTitles addObject:@"开始服务"];
    [self.secitonTitles addObject:@"护工位置"];
    [self.secitonTitles addObject:@"照片"];
    [self.secitonTitles addObject:@"服务完成"];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.secitonTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXServiceRecordeVCTableViewCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LXServiceRecordeVCTableViewCellID];
    }
    
    NSString *tempString = self.secitonTitles[indexPath.section];
    
    if ([tempString isEqualToString:@"服务已提交"] || [tempString isEqualToString:@"服务已接单"] || [tempString isEqualToString:@"开始服务"]) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = LXColorHex(0xb2b2b2);
        timeLabel.text = self.dataSource[indexPath.section];
        [cell.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView).mas_offset(40);
            make.centerY.mas_equalTo(cell.contentView);
        }];
    }
    else if ([tempString isEqualToString:@"护工位置"] || [tempString isEqualToString:@"照片"]) {
        UIImageView *myImageView = [[UIImageView alloc] init];
        [myImageView setImage:[UIImage imageNamed:@"Mine_top_backgroud"]];
        [cell.contentView addSubview:myImageView];
        [myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell.contentView).mas_equalTo(UIEdgeInsetsMake(10, 40, 10, 10));
        }];
    }
    else if ([tempString isEqualToString:@"服务完成"]) {
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempString = self.secitonTitles[indexPath.section];
    
    if ([tempString isEqualToString:@"服务已提交"] || [tempString isEqualToString:@"服务已接单"] ||    [tempString isEqualToString:@"开始服务"]) {
        return 20;
    }
    else if ([tempString isEqualToString:@"护工位置"] || [tempString isEqualToString:@"照片"]) {
       return 120;
    }
    else if ([tempString isEqualToString:@"服务完成"]) {
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth - 20, 30)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
    if (section == 0) {
        [btnImage setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    else if (section == [self.secitonTitles count] - 1) {
        [btnImage setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    else {
        [btnImage setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    [bgView addSubview:btnImage];
    [btnImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.leading.mas_equalTo(bgView).mas_offset(10);
        make.centerY.mas_equalTo(bgView);
    }];
    
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.textColor = LXColorHex(0x4c4c4c);
    dateLabel.text = self.secitonTitles[section];
    [bgView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).mas_offset(40);
        make.centerY.mas_equalTo(bgView);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = LXColorHex(0xb2b2b2);
    timeLabel.text = @"2017-6-2";
    [bgView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(bgView.mas_trailing).mas_offset(-10);
        make.centerY.mas_equalTo(bgView);
    }];
    
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
            if (weakself.reservationBottomType == LXReservationBottomTypeWaitCommentOrder) {
                LXOrderCommentViewController *ocVC = [[LXOrderCommentViewController alloc] init];
                [weakself.navigationController pushViewController:ocVC animated:YES];
            }
        }];
        
        [_orderDealView setFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - 50, LXScreenWidth, 50)];
        [_orderDealView setLeadingString:@"￥：50"];
        
        if (self.reservationBottomType == LXReservationBottomTypeWaitCommentOrder) {
            [_orderDealView setTrailingString:@"待评价"];
        }
        else if (self.reservationBottomType == LXReservationBottomTypeHavenCommentOrder) {
            [_orderDealView setTrailingString:@"已评价"];
        }
        else if (self.reservationBottomType == LXReservationBottomTypeDeleteOrder) {
            [_orderDealView setTrailingString:@"删除订单"];
        }
    }
    return _orderDealView;
}

@end
