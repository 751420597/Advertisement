//
//  LXSelectOrganizationViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXSelectOrganizationViewController.h"

#import "LXSelectOrganizationVCTableViewCell.h"

#import "LXSelectOrganizationViewModel.h"


static NSString *const LXSelectOrganizationVCTableViewCellID = @"LXBarthelVCTableViewCellID";

@interface LXSelectOrganizationViewController ()

@property (nonatomic, strong) LXSelectOrganizationViewModel *viewModel;

@end


@implementation LXSelectOrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择机构";
    self.view.backgroundColor = LXVCBackgroundColor;
    
    [self setUpTable];
    [self getServiceData];
}

#pragma mark - Service 

- (void)getServiceData {
    self.viewModel = [LXSelectOrganizationViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    [self.viewModel getSelectOrganizaitonListWithParameters:_params completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *tArray = result[@"agencyList"];
            
            for (NSDictionary *tempDict in tArray) {
                LXOrganizaitonModel *organizaitonModel = [LXOrganizaitonModel modelWithDictionary:tempDict];
                [self.dataSource addObject:organizaitonModel];
            }
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - Set up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - 10 - LXNavigaitonBarHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    self.tableView.rowHeight = 68;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.userInteractionEnabled = _enbleEidts;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXSelectOrganizationVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXSelectOrganizationVCTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXSelectOrganizationVCTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self addCustomeLineWithArray:[self.dataSource copy] indexPath:indexPath width:LXScreenWidth - 20 height:68 color:LXCellBorderColor cell:cell];
    }
    LXOrganizaitonModel *model = self.dataSource[indexPath.row];
    cell.organizationModel =model;
    if([self.objID isEqualToString:model.corId]){
        cell.backgroundColor = LXCellBorderColor;
    }else{
        cell.backgroundColor = LXVCBackgroundColor;
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LXOrganizaitonModel *organizationModel = self.dataSource[indexPath.row];
    if(self.selectOrganizationBlock){
        self.selectOrganizationBlock(organizationModel);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
