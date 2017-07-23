//
//  LXMineViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/5/17.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXMineViewController.h"

#import "LXMessageViewController.h"
#import "LXSettingViewController.h"
#import "LXMineInfoViewController.h"
#import "LXCareViewController.h"

#import "LXMineViewModel.h"
#import "LXMineModel.h"

static NSString *const LXMineViewControllerTableViewID = @"LXMineViewControllerTableViewID";

@interface LXMineViewController () <UITableViewDelegate, UITableViewDataSource>

// 多态指同一操作作用于不同的对象，可以有不同的解释，产生不同的执行结果
@property (nonatomic, strong) UIViewController *fromVC;
@property (nonatomic, strong) UIViewController *toVC;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UILabel *nameL;

@property (nonatomic, strong) LXMineViewModel *viewModel;
@property (nonatomic, strong) LXMineModel *mineModel;

@end


@implementation LXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:LXColorHex(0xf5f5f5)];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self getServiceData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXMineViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    [self.viewModel getMineWithParameters:nil completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            self.mineModel = [LXMineModel modelWithDictionary:result[@"userInfo"]];
            if(_mineModel!=nil){
                _imageBtn.enabled = YES;
                [self updateUI];
                
            }else{
                _imageBtn.enabled = NO;
            }
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
            _imageBtn.enabled = NO;
        }
    }];
}


#pragma mark - Action

- (void)addViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void)removeViewController:(UIViewController *)viewController {
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

- (void)avatarImageViewClick {
    LXMineInfoViewController *miVC = [LXMineInfoViewController new];
    miVC.okBlock = ^{
         [self getServiceData];
    };
    miVC.mineModel = self.mineModel;
    miVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:miVC animated:YES];
}


#pragma mark - Update

- (void)updateUI {
    NSString *requestString = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.mineModel.avatarImageId];
    [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:requestString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Mine_male"]];
    
    [self.nameL setText:self.mineModel.userName.length>0 ? self.mineModel.userName : @"还没有名字"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXMineViewControllerTableViewID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LXMineViewControllerTableViewID];
    }
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dict.allValues.firstObject]];
    [myImageView setFrame:CGRectMake(LXRate(10), LXRate(16), LXRate(18), LXRate(18))];
   
    UILabel *myLabel = [[UILabel alloc] init];
    [myLabel setFont:[UIFont systemFontOfSize:LXRate(16)]];
    [myLabel setText:dict.allKeys.firstObject];
    [myLabel setTextColor:LXColorHex(0x4c4c4c)];
    [myLabel sizeToFit];
    [myLabel setFrame:CGRectMake(myImageView.right + LXRate(10), (LXRate(50) - myLabel.height) / 2, myLabel.width, myLabel.height)];
   
    [cell.contentView addSubview:myImageView];
    [cell.contentView addSubview:myLabel];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataSource[indexPath.row];
    NSString *indexTitle = dict.allKeys.firstObject;
    
    if ([indexTitle isEqualToString:@"照护对象"]) {
        LXCareViewController *cVC = [[LXCareViewController alloc] initWithIsAddCare:YES];
        cVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cVC animated:YES];
    }
    else if ([indexTitle isEqualToString:@"消息"]) {
        LXMessageViewController *mVC = [LXMessageViewController new];
        mVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mVC animated:YES];
    }
    else if ([indexTitle isEqualToString:@"设置"]) {
        LXSettingViewController *sVC = [LXSettingViewController new];
        sVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sVC animated:YES];
    }
}


#pragma mark - Getter 

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth, LXRate(190))];
        
        UIImageView *backgroudImageView = [[UIImageView alloc] initWithFrame:_topView.frame];
        [backgroudImageView setImage:[UIImage imageNamed:@"Mine_top_backgroud"]];
        [_topView addSubview:backgroudImageView];
        
        self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.imageBtn setBackgroundImage:[UIImage imageNamed:@"Mine_male"] forState:UIControlStateNormal];
        [self.imageBtn setFrame:CGRectMake(0, 0, LXRate(70), LXRate(70))];
        [self.imageBtn setCenter:_topView.center];
        self.imageBtn.layer.cornerRadius =_imageBtn.frame.size.width/2;
        self.imageBtn.layer.masksToBounds = YES;
        [self.imageBtn addTarget:self action:@selector(avatarImageViewClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:self.imageBtn];
        
        self.nameL = [[UILabel alloc] init];
        [self.nameL setFont:[UIFont systemFontOfSize:LXRate(15)]];
        [self.nameL setTextColor:[UIColor whiteColor]];
        [self.nameL setText:@""];
        [self.nameL setTextAlignment:NSTextAlignmentCenter];
        [self.nameL setFrame:CGRectMake(0, self.imageBtn.bottom + LXRate(10), 80, 30)];
        [self.nameL setCenterX:_topView.centerX];
        [_topView addSubview:self.nameL];
        
        UIButton *sexual = [UIButton buttonWithType:UIButtonTypeCustom];
        [sexual setBackgroundImage:[UIImage imageNamed:@"Mine_top_sexual"] forState:UIControlStateNormal];
        [sexual setFrame:CGRectMake(self.nameL.right + LXRate(2), self.imageBtn.bottom + LXRate(10), LXRate(10), LXRate(10))];
        [sexual setCenterY:self.nameL.centerY];
        [_topView addSubview:sexual];
    }
    return _topView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSDictionary *dict1 = @{@"照护对象":@"Mine_tableview_person"};
        NSDictionary *dict2 = @{@"消息":@"Mine_tableview_message"};
        NSDictionary *dict3 = @{@"设置":@"Mine_tableview_setting"};
        
        [_dataSource addObject:dict1];
        [_dataSource addObject:dict2];
        [_dataSource addObject:dict3];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, LXRate(190) + 10, LXScreenWidth - 10 * 2, LXRate(50) * self.dataSource.count) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        _tableView.scrollEnabled = NO;
        
        _tableView.layer.cornerRadius = 5.f;
        _tableView.layer.borderColor = LXColorHex(0xf5f5f5).CGColor;
        _tableView.layer.borderWidth = 1;
        
        _tableView.rowHeight = LXRate(50);
    }
    return _tableView;
}

@end
