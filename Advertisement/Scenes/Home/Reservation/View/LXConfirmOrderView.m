//
//  LXConfirmOrderView.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/10.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXConfirmOrderView.h"

#import "LXConfirmViewTableViewCell.h"

@interface LXConfirmOrderView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) dispatch_block_t detailB;
@property (nonatomic, copy) dispatch_block_t confirmB;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomBGView;
@property (nonatomic, strong) UILabel *totalLabel;

@end


@implementation LXConfirmOrderView

- (instancetype)initWithDetailBlock:(dispatch_block_t)dBlock confirmBlock:(dispatch_block_t)cBlock {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.detailB = dBlock;
        self.confirmB = cBlock;
        
        [self setUpSubViews];
    }
    return self;
}


#pragma mark - Set Up

- (void)setUpSubViews {
    LXWeakSelf(self);
    
    
    // *******************************
    self.bottomBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth, 50)];
    [self addSubview:self.bottomBGView];
    [self.bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(weakself);
        make.height.mas_equalTo(50);
    }];
    
    UIView *topView = [[UIView alloc] init];
    [topView setBackgroundColor:LXColorHex(0xD5D5D5)];
    [self.bottomBGView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(weakself.bottomBGView);
        make.right.mas_equalTo(weakself.bottomBGView);
        make.left.mas_equalTo(weakself.bottomBGView);
    }];
    
    self.totalLabel = [[UILabel alloc] init];
    [self.totalLabel setFont:[UIFont systemFontOfSize:15]];
    [self.totalLabel setTextColor:LXMainColor];
    [self.bottomBGView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.bottomBGView).mas_offset(10);
        make.center.mas_equalTo(weakself.bottomBGView);
    }];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundColor:LXMainColor];
    [confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [confirmBtn setTitle:@"确认下单" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBGView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakself.bottomBGView).mas_offset(0);
        make.width.mas_equalTo(135);
        make.top.mas_equalTo(weakself.bottomBGView);
        make.bottom.mas_equalTo(weakself.bottomBGView);
    }];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setImage:[UIImage imageNamed:@"Home_up_arrow"] forState:UIControlStateNormal];
    [detailBtn setTitleColor:LXColorHex(0x4c4c4c) forState:UIControlStateNormal];
    [detailBtn setTitleColor:LXColorHex(0x4c4c4c) forState:UIControlStateSelected];
    [detailBtn setTitle:@"详细" forState:UIControlStateNormal];
    [detailBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBGView addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakself.bottomBGView).mas_offset(-150);
        make.center.mas_equalTo(weakself.bottomBGView);
    }];
}


#pragma mark - Setter 

- (void)setTotalSum:(NSString *)totalSum {
    _totalSum = totalSum;
    
    [self.totalLabel setText:totalSum];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSource.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Section"];
        
        UILabel *leadingL = [[UILabel alloc] init];
        [leadingL setFont:[UIFont systemFontOfSize:16]];
        [leadingL setTextColor:LXMainColor];
        [leadingL setText:@"合计费用"];
        [cell.contentView addSubview:leadingL];
        [leadingL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(cell.contentView).mas_offset(10);
            make.centerY.mas_equalTo(cell.contentView);
        }];
        
        UILabel *totalL = [[UILabel alloc] init];
        [totalL setFont:[UIFont systemFontOfSize:16]];
        [totalL setTextColor:LXMainColor];
        [totalL setText:self.totalSum];
        [cell.contentView addSubview:totalL];
        [totalL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(cell.contentView).mas_offset(-10);
            make.centerY.mas_equalTo(cell.contentView);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        LXConfirmViewTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"LXConfirmViewTableViewCell" owner:self options:nil].firstObject;
        
        cell.serviceModel = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    [bgView setBackgroundColor:LXVCBackgroundColor];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:16];
    dateLabel.textColor = LXColorHex(0x4c4c4c);
    dateLabel.text = @"订单详情";
    [bgView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.centerY.mas_equalTo(bgView);
    }];
    
    return bgView;
}


#pragma mark - Getter 

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 50;
    }
    return _tableView;
}


#pragma mark - Action 

- (void)confirmBtnClick {
    if (self.confirmB) {
        self.confirmB();
    }
}

- (void)detailBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        if (self.detailB) {
            if (self.dataSource.count > 0) {
                [self setFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - 50 - (self.dataSource.count + 2) * 50, LXScreenWidth, 50 + (self.dataSource.count + 2) * 50)];
               
                if(self.height+50+LXNavigaitonBarHeight>=LXScreenHeight){
                    [self setFrame:CGRectMake(0, LXNavigaitonBarHeight-50-14, LXScreenWidth,LXScreenHeight-LXNavigaitonBarHeight)];
                    [self.tableView setFrame:CGRectMake(0,0, self.width, LXScreenHeight-50-LXNavigaitonBarHeight)];
                }else{
                    
                    [self.tableView setFrame:CGRectMake(0, 0, self.width, self.height - 50)];
                    
                }
               
                [self addSubview:self.tableView];
                
                self.detailB();
            }
        }
    }
    else {
        [self setFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - 50, LXScreenWidth, 50)];
        [self.tableView removeFromSuperview];
    }
}

@end
