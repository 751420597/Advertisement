//
//  LXServiceProjectViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXServiceProjectViewController.h"

#import "LXServiceProjectVCTableCell.h"

#import "LXServiceDetailViewController.h"

#import "LXServiceProjectViewModel.h"
#import "LXServiceProjectModel.h"

static NSString *const LXServiceProjectVCTableCellID = @"LXServiceProjectVCTableCellID";
static CGFloat LXServiceProjectTableViewOriginX = 10;
static CGFloat LXServiceProjectTableViewOriginY = 10;
#define LXServiceProjectTableViewHeight  (LXScreenHeight - LXNavigaitonBarHeight - LXServiceProjectTableViewOriginY)
#define LXServiceProjectTableViewWidth   (LXScreenWidth - LXServiceProjectTableViewOriginX * 2)

static CGFloat LXServiceProjectTableViewRowHeight = 50;

@interface LXServiceProjectViewController ()

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) LXServiceProjectViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray *selectArray;

@end


@implementation LXServiceProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务项目";
    self.view.backgroundColor = LXVCBackgroundColor;
    self.selectArray = [NSMutableArray array];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpaceBarButtonItem.width = -10;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
    barButtonItem.width = 10;
    self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    
    [self setUpTable];
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
   
    if(self.careID.length<=0){
        [SVProgressHUD showErrorWithStatus:@"请先选择照护对象！"];
        return;
    }
    self.viewModel = [LXServiceProjectViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
   
    NSDictionary *dic =@{@"careObjId":self.careID};
    [self.viewModel getServiceListWithParameters:dic completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *objectArray = result[@"goodsList"];
            if(objectArray.count==0){
                [SVProgressHUD showErrorWithStatus:@"该照护对象未审核或审核失败！"];
            }else{
                for (NSDictionary *ojectDict in objectArray) {
                    LXServiceProjectModel *tempModel = [LXServiceProjectModel modelWithDictionary:ojectDict];
                    [self.dataSource addObject:tempModel];
                }
                
                [self.tableView reloadData];
            }
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - Set up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(LXServiceProjectTableViewOriginX, LXServiceProjectTableViewOriginY, LXServiceProjectTableViewWidth, LXServiceProjectTableViewHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    self.tableView.rowHeight = LXServiceProjectTableViewRowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsMultipleSelection = YES;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXServiceProjectVCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:LXServiceProjectVCTableCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXServiceProjectVCTableCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self addCustomeLineWithArray:[self.dataSource copy] indexPath:indexPath width:LXServiceProjectTableViewWidth height:LXServiceProjectTableViewRowHeight color:LXCellBorderColor cell:cell];
    }
    
    LXWeakSelf(self);
    
    LXServiceProjectModel *serviceProjectModel = self.dataSource[indexPath.row];
    
    cell.serviceProjectModel = serviceProjectModel;
    cell.cellSelectBlock = ^{
        LXServiceProjectModel *serviceProjectModel = self.dataSource[indexPath.row];
        
        LXServiceDetailViewController *sdVC = [LXServiceDetailViewController new];
        sdVC.goodsId = serviceProjectModel.goodsId;
        [weakself.navigationController pushViewController:sdVC animated:YES];
    };
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LXServiceProjectModel *serviceProjectModel = self.dataSource[indexPath.row];
    LXWeakSelf(self);
    
    if (![weakself.selectArray containsObject:serviceProjectModel]) {
        [weakself.selectArray addObject:serviceProjectModel];
        LXServiceProjectVCTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.arrowBtn setBackgroundImage:[UIImage imageNamed:@"Home_cell_selected"] forState:UIControlStateNormal];
    }else{
        [weakself.selectArray removeObject:serviceProjectModel];
        LXServiceProjectVCTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.arrowBtn setBackgroundImage:[UIImage imageNamed:@"Home_cell_normal"] forState:UIControlStateNormal];
    }
}


#pragma mark - Aciton

- (void)addBtnClick {
    if(self.addBlock){
        self.addBlock(self.selectArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Getter

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_addBtn setFrame:CGRectMake(0, 0, 40, 30)];
        [_addBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
