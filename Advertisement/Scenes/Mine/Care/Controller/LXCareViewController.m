//
//  LXCareViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXCareViewController.h"

#import "LXCareVCTableCell.h"

#import "LXAddCareViewController.h"
#import "LXCareDetailViewController.h"

#import "LXCareModel.h"
#import "LXCareViewModel.h"
static NSString *const LXCareVCTableCellID = @"LXCareVCTableCellID";
static CGFloat LXCareTableViewOriginX = 10;
static CGFloat LXCareTableViewOriginY = 10;
#define LXCareTableViewHeight  (LXScreenHeight - LXNavigaitonBarHeight - LXCareTableViewOriginY)
#define LXCareTableViewWidth   (LXScreenWidth - LXCareTableViewOriginX * 2)

static CGFloat LXCareTableViewRowHeight = 70;

@interface LXCareViewController ()

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) LXCareViewModel *viewModel;

@property (nonatomic, assign) BOOL isAddCare;

@end


@implementation LXCareViewController

- (instancetype)initWithIsAddCare:(BOOL)isAdd {
    if (self = [super init]) {
        self.isAddCare = isAdd;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"照护对象";
    self.view.backgroundColor = LXVCBackgroundColor;
    
    if (self.isAddCare) {
        UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedSpaceBarButtonItem.width = -10;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
        barButtonItem.width = 10;
        self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    }

    [self setUpTable];
    
    [self getServiceData];
}
#pragma mark 导航栏右侧点击事件
-(void)moreOperation
{
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.title = [self titles][i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:150
                                                             item:obj
                                                           action:^(NSInteger index) {
                                                               NSLog(@"index:%ld",(long)index);
                                                               if (index ==0) {
                                                                   [self changhuxian];
                                                                   
                                                               }
                                                               if(index==1){
                                                                   [self haveCHangehuxian];
                                                               }
                                                               if(index==2){
                                                                   [self NoChanghuxian];
                                                               }
                                                               
                                                           }];
}
- (NSArray *) titles
{
    return @[@"申请长护险待遇",@"已有长护险待遇",@"没有参保长护险"];
}

-(void)changhuxian{
    
    LXAddCareViewController *acVC = [LXAddCareViewController new];
    acVC.states = 0;
    acVC.reloadBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getServiceData];
        });
        
    };
    [self.navigationController pushViewController:acVC animated:YES];
    
}
-(void)haveCHangehuxian{
    
    LXAddCareViewController *acVC = [LXAddCareViewController new];
    acVC.states = 1;
    acVC.reloadBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getServiceData];
        });
        
    };
    [self.navigationController pushViewController:acVC animated:YES];
    
}
-(void)NoChanghuxian{
    
    LXAddCareViewController *acVC = [LXAddCareViewController new];
    acVC.states = 2;
    acVC.reloadBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getServiceData];
        });
        
    };
    [self.navigationController pushViewController:acVC animated:YES];
     
}
#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXCareViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    if(self.isAddCare){
        [self.viewModel getCareListWithParameters:nil completionHandler:^(NSError *error, id result) {
            LXStrongSelf(self);
            [SVProgressHUD dismiss];
            int code = [result[@"code"] intValue];
            self.dataSource = [NSMutableArray array];
            if (code == 0) {
                NSArray *tempArray = result[@"careObjList"];
                
                for (NSDictionary *objectDict in tempArray) {
                    LXCareModel *careModel = [LXCareModel modelWithDictionary:objectDict];
                    if(careModel.checkTime.length>0){
                    careModel.checkTime=[careModel.checkTime  substringWithRange:NSMakeRange(0, careModel.checkTime.length-2)];
                    }
                    [self.dataSource addObject:careModel];
                }
                
                [self.tableView reloadData];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
            }
        }];

    }else{
        [self.viewModel getCareListByHomeWithParameters:nil completionHandler:^(NSError *error, id result) {
            LXStrongSelf(self);
            [SVProgressHUD dismiss];
            int code = [result[@"code"] intValue];
            self.dataSource = [NSMutableArray array];
            if (code == 0) {
                NSArray *tempArray = result[@"careObjList"];
                
                for (NSDictionary *objectDict in tempArray) {
                    LXCareModel *careModel = [LXCareModel modelWithDictionary:objectDict];
                    careModel.checkTime=[careModel.checkTime  substringWithRange:NSMakeRange(0, careModel.checkTime.length-2)];
                    [self.dataSource addObject:careModel];
                }
                
                [self.tableView reloadData];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
            }
        }];

    }
}


#pragma mark - Set up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(LXCareTableViewOriginX, LXCareTableViewOriginY, LXCareTableViewWidth,LXCareTableViewHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    if(self.isOrder){
        self.tableView.rowHeight = 50;
    }else{
        self.tableView.rowHeight = LXCareTableViewRowHeight;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isOrder){
        static NSString* indent = @"indent";
        UITableViewCell *cell_1 = [tableView dequeueReusableCellWithIdentifier:indent];
        
        if (!cell_1) {
            cell_1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indent];
            cell_1.selectionStyle = UITableViewCellSeparatorStyleNone;
            [self addCustomeLineWithArray:[self.dataSource copy] indexPath:indexPath width:LXCareTableViewWidth height:50 color:LXCellBorderColor cell:cell_1];
            UILabel *nameL = [[UILabel alloc]init];
            nameL.font =[UIFont systemFontOfSize:15.f];
            nameL.tag = 100;
            [cell_1.contentView addSubview:nameL];
            
            UIImageView *iamgeV =[[UIImageView alloc]init];
            iamgeV.contentMode =UIViewContentModeScaleAspectFit;
            iamgeV.tag = 101;
            
            [cell_1.contentView addSubview:iamgeV];
        }
        UILabel *nameL =[cell_1.contentView viewWithTag:100];
        UIImageView *iamgeV =[cell_1.contentView viewWithTag:101];
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell_1);
            make.leading.equalTo(cell_1).offset(15);
        }];
        
        [iamgeV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell_1);
            make.trailing.equalTo(cell_1.contentView).offset(-15);
            make.width.offset(20);
            make.height.offset(20);
        }];
        LXCareModel *careModel = self.dataSource[indexPath.row];
        if([careModel.careObjId isEqualToString:self.careID_0]){
            iamgeV.image =[UIImage imageNamed:@"Home_cell_selected"];
        }else{
            iamgeV.image =[UIImage imageNamed:@""];
        }
        nameL.text = careModel.careObjName;
       
        
        return cell_1;
 
    }else{
        LXCareVCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:LXCareVCTableCellID];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LXCareVCTableCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            [self addCustomeLineWithArray:[self.dataSource copy] indexPath:indexPath width:LXCareTableViewWidth height:LXCareTableViewRowHeight color:LXCellBorderColor cell:cell];
        }
        
        LXCareModel *careModel = self.dataSource[indexPath.row];
        
        cell.nameL.text = careModel.careObjName;
        cell.expireTimeL.text = careModel.checkTime;
        cell.stateL.text = careModel.checkStateName;
        
        [self configureCellWithTableViewCell:cell value:careModel.checkStateName];
        
        return cell;
 
    }
    return nil;
}


#pragma mark - Configure Cell

- (void)configureCellWithTableViewCell:(LXCareVCTableCell *)cell value:(NSString *)value {
    UIColor *tempColor = nil;
    
    if ([value isEqualToString:@"审核中"]) {
        tempColor = LXColorHex(0x4c4c4c);
    }
    else if ([value isEqualToString:@"已通过"]) {
         tempColor = LXMainColor;
    }
    else if ([value isEqualToString:@"未认证"]) {
         tempColor = [UIColor redColor];
    }
    else if ([value isEqualToString:@"未通过"]) {
         tempColor = LXColorHex(0x4c4c4c);
        
        cell.nameConstrait.constant = 0;
        cell.expireTimeL.hidden = YES;
    }
//    else if ([value isEqualToString:@"重新申请"]) {
//        tempColor = LXColorHex(0x4c4c4c);
//    }
    
    [cell.stateL setTextColor:tempColor];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LXCareModel *careModel = self.dataSource[indexPath.row];
    
    if (self.selectBlock) {
        self.selectBlock(careModel.careObjId, careModel.careObjName);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if ([careModel.checkStateId isEqualToString:@"3"]||[careModel.checkStateId isEqualToString:@"6"]||[careModel.checkStateId isEqualToString:@"8"]) {
            LXCareDetailViewController *acVC = [LXCareDetailViewController new];
            LXCareModel *careModel= self.dataSource[indexPath.row];
            acVC.checkStateId = careModel.checkStateId;
            acVC.careId = careModel.careObjId;
            acVC.title = careModel.careObjName;
            
            acVC.isPass = NO;
            acVC.reloadBlock = ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self getServiceData];
                });
            };
            [self.navigationController pushViewController:acVC animated:YES];
        }
        else {
            LXCareDetailViewController *cdVC = [LXCareDetailViewController new];
            cdVC.careId = careModel.careObjId;
            cdVC.title = careModel.careObjName;
            cdVC.isPass = YES;
            LXCareModel *careModel= self.dataSource[indexPath.row];
            cdVC.checkStateId = careModel.checkStateId;
            cdVC.reloadBlock = ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self getServiceData];
                });
            };
            [self.navigationController pushViewController:cdVC animated:YES];
        }
    }
}


#pragma mark - Action

- (void)addBtnClick {
    [self moreOperation];
}


#pragma mark - Getter

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_addBtn setFrame:CGRectMake(0, 0, 40, 30)];
        [_addBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}



@end
