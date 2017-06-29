//
//  LXSettingViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/8.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXSettingViewController.h"

#import "LXSettingVCTableViewCell.h"

#import "LXSuggestViewController.h"
#import "LXAboutUsViewController.h"
#import "LXUserProtocolViewController.h"

static NSString *const LXSettingVCTableViewCellID = @"LXSettingVCTableViewCellID";

@interface LXSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation LXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    [self.view setBackgroundColor:LXVCBackgroundColor];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXSettingVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXSettingVCTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXSettingVCTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.myLabel.text = self.dataSource[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempString = self.dataSource[indexPath.row];
    
    if ([tempString isEqualToString:@"关于我们"]) {
        LXAboutUsViewController *auVC = [LXAboutUsViewController new];
        [self.navigationController pushViewController:auVC animated:YES];
    }
    else if ([tempString isEqualToString:@"投诉建议"]) {
        LXSuggestViewController *sVC = [LXSuggestViewController new];
        [self.navigationController pushViewController:sVC animated:YES];
    }
    else if ([tempString isEqualToString:@"用户协议"]) {
        LXUserProtocolViewController *upVC = [LXUserProtocolViewController new];
        [self.navigationController pushViewController:upVC animated:YES];
    }
}



#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@"关于我们"];
        [_dataSource addObject:@"投诉建议"];
        [_dataSource addObject:@"用户协议"];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth, LXScreenHeight - LXNavigaitonBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:LXVCBackgroundColor];
        
        _tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
        _tableView.sectionFooterHeight = 10;
        _tableView.sectionFooterHeight = 10;
        
        _tableView.rowHeight = 53;
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth, 53)];
        [bottomView setBackgroundColor:LXVCBackgroundColor];
        
        CGRect btnRect = bottomView.frame;
        btnRect.origin.x += 10;
        btnRect.size.width -= 20;
        [self.logoutBtn setFrame:btnRect];
        
        [bottomView addSubview:self.logoutBtn];
        _tableView.tableFooterView = bottomView;
        
    }
    return _tableView;
}

- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:LXColorHex(0x4c4c4c) forState:UIControlStateNormal];
        [_logoutBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_logoutBtn setBackgroundColor:[UIColor whiteColor]];
        
        _logoutBtn.layer.borderWidth = 1.f;
        _logoutBtn.layer.borderColor = LXCellBorderColor.CGColor;
        _logoutBtn.layer.cornerRadius = 5.f;
    }
    return _logoutBtn;
}

@end
