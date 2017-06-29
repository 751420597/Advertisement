//
//  LXMessageViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/8.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXMessageViewController.h"

#import "LXMessageVCTableViewCell.h"

#import "LXMessageModel.h"
#import "LXMessageViewModel.h"

static NSString *const LXMessageVCTableViewCellID = @"LXMessageVCTableViewCellID";

@interface LXMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) LXMessageViewModel *viewModel;

@end

@implementation LXMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息";
    [self.view setBackgroundColor:LXVCBackgroundColor];

    [self.view addSubview:self.tableView];
    
    [self fetchServerData];
}


#pragma mark - Service

- (void)fetchServerData {
    self.viewModel = [LXMessageViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
    [self.viewModel getMessageListWithParameters:nil completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *tArray = result[@"msgList"];
            if(tArray.count==0){
                [SVProgressHUD showInfoWithStatus:@"暂无消息！"];
            }
            for (NSDictionary *tempDict in tArray) {
                LXMessageModel *oModel = [LXMessageModel modelWithDictionary:tempDict];
                [self.dataSource addObject:oModel];
            }
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXMessageVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXMessageVCTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXMessageVCTableViewCell" owner:self options:nil] lastObject];
    }
    cell.messageModel = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeObjectAtIndex:indexPath.section];
        
        [self.tableView deleteSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - UITableViewDelegate



#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        
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
        _tableView.tableFooterView = [UIView new];
        [_tableView setBackgroundColor:LXColorHex(0xf5f5f5)];
        
        _tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
        _tableView.sectionFooterHeight = 10;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.rowHeight = LXRate(68);
    }
    return _tableView;
}

@end
