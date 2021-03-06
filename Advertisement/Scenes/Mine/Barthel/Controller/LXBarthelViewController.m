//
//  LXBarthelViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXBarthelViewController.h"

#import "LXBarthelVCTableViewCell.h"

#import "LXBarthelModel.h"
#import "LXBarthelViewModel.h"
#import "LXBarthelLevelModel.h"
#import "LXBarthelTotalModel.h"
#import "CareDetailBartherModel.h"
static NSString *const LXBarthelVCTableViewCellID = @"LXBarthelVCTableViewCellID";

@interface LXBarthelViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSIndexPath *index;
}
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIView *bigBGView;
@property (nonatomic, strong) UIView *samllBGView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSMutableArray *pickDataSource;

@property (nonatomic, strong) LXBarthelViewModel *viewModel;

@property (nonatomic, strong) LXBarthelLevelModel *myLevelModel;
@property (nonatomic, strong) LXBarthelModel *myModel;

@property (nonatomic, strong) NSMutableArray *totalDataSource;
@property (nonatomic, assign) NSInteger totalScore;
@property (nonatomic, strong) NSMutableArray *recordDataSource;
@property (nonatomic, strong) NSMutableArray *careDetailBartherLeavlArr;
@property (nonatomic, strong) NSMutableDictionary *recordDictionary;

@end


@implementation LXBarthelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Barthel指标评定";
    self.view.backgroundColor = LXVCBackgroundColor;
    
    self.recordDictionary = [NSMutableDictionary dictionary];
    if (_enbleEidts) {
        UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedSpaceBarButtonItem.width = -10;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
        barButtonItem.width = 10;
        self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    }
    
    if(self.cheackDic.allKeys.count>0){
        _isDetail = NO;
        self.recordDictionary =[NSMutableDictionary dictionaryWithDictionary:self.cheackDic] ;
    }
    //详情里过来的
    if(_isDetail){
        self.careDetailBartherLeavlArr = [NSMutableArray array];
        for (CareDetailBartherModel *model in (NSArray*)self.bartherLevelArr) {
            NSDictionary *dic =model.bgList[0];
            LXBarthelLevelModel *model2 = [LXBarthelLevelModel modelWithDictionary:dic];
            [self.recordDictionary setValue:model2 forKey:model.evaItem];
            [self.careDetailBartherLeavlArr addObject:model];
        }
    }
    
    self.recordDataSource = [NSMutableArray array];
    self.totalDataSource = [NSMutableArray array];
    
    [self setUpTable];
    
    [self getServiceData];
}


#pragma mark - Service

- (void)getServiceData {
    self.viewModel = [LXBarthelViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    [self.viewModel getBarthelListWithParameters:nil completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *tempArray = result[@"barthelConfigList"];
            for (NSDictionary *tempDict in tempArray) {
                LXBarthelModel *barthelModel = [LXBarthelModel modelWithDictionary:tempDict];
                [self.dataSource addObject:barthelModel];
            }
            
//            for (NSDictionary *tempDict in result[@"barthelRatingList"]) {
//                LXBarthelTotalModel *barthelModel = [LXBarthelTotalModel modelWithDictionary:tempDict];
//                [self.totalDataSource addObject:barthelModel];
//            }
            
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}

- (void)getBarthellevelDataWithString:(NSString *)idString {
    [self.pickDataSource removeAllObjects];
    
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中……"];
    
    NSDictionary *dictP = @{@"bcId":idString};
    
    [self.viewModel getBarthelLevelWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            NSArray *tempArray = result[@"barthelGradeList"];
            for (NSDictionary *tempDict in tempArray) {
                LXBarthelLevelModel *barthelModel = [LXBarthelLevelModel modelWithDictionary:tempDict];
                [self.pickDataSource addObject:barthelModel];
            }
            
            [self.view addSubview:self.bigBGView];
            [self.pickView  reloadAllComponents];
            [self.pickView  selectRow:0 inComponent:0 animated:YES];
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}


#pragma mark - Set up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - 10 - LXNavigaitonBarHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LXVCBackgroundColor;

    
    self.tableView.userInteractionEnabled = self.enbleEidts;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXBarthelVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXBarthelVCTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXBarthelVCTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self addCustomeLineWithArray:[self.dataSource copy] indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
    }
    

    LXBarthelModel *barthelModel = self.dataSource[indexPath.row];
    if(self.cheackDic.allKeys>0){
        
        [self.cheackDic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([self.cheackDic.allKeys[idx] isEqualToString:barthelModel.evaItem]){
                LXBarthelLevelModel *model = self.cheackDic.allValues[idx];
                barthelModel.value =model.barContent;
                *stop = YES;
            }
        }];
        
       
    }
    cell.barthelModel = barthelModel;
    
    //详情穿过来的
    if(_isDetail){
        CareDetailBartherModel *careBartherModel = self.careDetailBartherLeavlArr[indexPath.row];
        cell.careDetailBartherModel = careBartherModel;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LXBarthelModel *barthelModel = self.dataSource[indexPath.row];
    
    self.myModel = barthelModel;
    
    if (![self.recordDataSource containsObject:barthelModel]) {
        [self.recordDataSource addObject:barthelModel];
    }
    index = indexPath;
    [self getBarthellevelDataWithString:barthelModel.bcId];
}


#pragma mark - Action

- (void)addBtnClick {
    if (_recordDictionary.allKeys.count != [self.dataSource count]) {
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"请全部完成测评才能给出评测结果！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *call1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *call2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alterVC addAction:call1];
        [alterVC addAction:call2];
        
        [self presentViewController:alterVC animated:YES completion:^{
            
        }];
    }
    else {
        LXLog(@"%ld", (long)self.totalScore);
        
       
//        LXBarthelTotalModel *model = nil;
//        for (LXBarthelTotalModel *barthelModel in self.totalDataSource) {
//            if (self.totalScore > barthelModel.startScore.integerValue && self.totalScore < barthelModel.endScore.integerValue ) {
//                LXLog(@"%@", barthelModel.barLevel);
//                
//                model = barthelModel;
//            }
//        }
        for (int i = 0; i < _recordDictionary.allKeys.count; i++) {
            //逐个的获取键
            NSString * key = [_recordDictionary.allKeys objectAtIndex:i];
            
            //通过键，找到相对应的值
            LXBarthelLevelModel * valueModel = [_recordDictionary valueForKey:key];
            //或者
            // NSString * value = [dict objectForKey:key];
            self.totalScore += valueModel.dispOrder.intValue;
        }
        if(self.barthelBlock){
            self.barthelBlock(self.recordDictionary, self.totalScore);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelBtnClick {
    if ([self.recordDataSource containsObject:self.myModel]) {
        [self.recordDataSource removeObject:self.myModel];
    }
    
    self.myLevelModel = nil;
    
    [self.bigBGView removeFromSuperview];
}

- (void)confirmBtnClick {
    if (!self.myLevelModel) {
        self.myLevelModel = (LXBarthelLevelModel *)self.pickDataSource[0];
    }
    
    LXBarthelVCTableViewCell *cell =[self.tableView cellForRowAtIndexPath:index];
    cell.vuleLB.text = self.myLevelModel.barContent;
    LXBarthelModel *barthelModel = self.dataSource[index.row];
    barthelModel.value =self.myLevelModel.barContent;
    
    [self.recordDictionary setValue:self.myLevelModel forKey:self.myModel.evaItem];
    self.myLevelModel = nil;
    
    [self.bigBGView removeFromSuperview];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickDataSource count];
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *tempString = ((LXBarthelLevelModel *)self.pickDataSource[row]).barContent;
    
    NSAttributedString *component0String = [[NSAttributedString alloc] initWithString:tempString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f], NSForegroundColorAttributeName : LXMainColor}];
    
    return component0String;
}


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    LXBarthelLevelModel *tempModel = (LXBarthelLevelModel *)self.pickDataSource[row];
    self.myLevelModel = tempModel;
   
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

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:LXMainColor forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitleColor:LXMainColor forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, LXScreenWidth - 40, 216)];
        [_pickView setBackgroundColor:[UIColor whiteColor]];
        _pickView.dataSource = self;
        _pickView.delegate = self;
        _pickView.hidden = NO;
        _pickView.showsSelectionIndicator=YES;
    }
    return _pickView;
}

- (NSMutableArray *)pickDataSource {
    if (!_pickDataSource) {
        _pickDataSource = [NSMutableArray array];
    }
    return _pickDataSource;
}


- (UIView *)bigBGView {
    if (!_bigBGView) {
        _bigBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth, LXScreenHeight - LXNavigaitonBarHeight)];
        [_bigBGView setBackgroundColor:[UIColor lightGrayColor]];
        
        self.samllBGView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, LXScreenWidth - 40, 260)];
        [self.samllBGView setCenterY:_bigBGView.centerY];
        [_bigBGView addSubview:self.samllBGView];
        
        self.topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.samllBGView.width, 44)];
        [self.topBgView setBackgroundColor:LXColorHex(0xedeeef)];
        [self.cancelBtn setFrame:CGRectMake(0, 0, 80, 44)];
        [self.confirmBtn setFrame:CGRectMake(self.topBgView.width - 80, 0, 80, 44)];
        [self.topBgView addSubview:self.cancelBtn];
        [self.topBgView addSubview:self.confirmBtn];
        [self.samllBGView addSubview:self.topBgView];
        
        [self.samllBGView addSubview:self.pickView];
    }
    return _bigBGView;
}

@end
