//
//  LXTimeRepeatViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXTimeRepeatViewController.h"

#import "LXTimeRepeatVCTableViewCell.h"

static NSString *const LXTimeRepeatVCTableViewCellID = @"LXTimeRepeatVCTableViewCellID";

@interface LXTimeRepeatViewController ()
{
    BOOL isSelect;
    NSIndexPath *index;
}
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, assign) NSInteger repeat;


@end


@implementation LXTimeRepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"重复次数";
    self.view.backgroundColor = LXVCBackgroundColor;
    
    self.repeat = self.repeatT;
    index = [NSIndexPath indexPathForRow:self.repeat inSection:0];
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpaceBarButtonItem.width = -10;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
    barButtonItem.width = 10;
    self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    
    [self setUpTable];
}


#pragma mark - Set Up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(0, 0, LXScreenWidth, LXScreenHeight - LXNavigaitonBarHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    [self.tableView setSeparatorColor:LXColorHex(0xf6f6f6)];
    [self.tableView setRowHeight:50];
    
    [self.dataSource addObject:@"不重复"];
    [self.dataSource addObject:@"一周"];
    [self.dataSource addObject:@"两周"];
    [self.dataSource addObject:@"三周"];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXTimeRepeatVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXTimeRepeatVCTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXTimeRepeatVCTableViewCell" owner:self options:nil] firstObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if(indexPath.row==self.repeat){
        isSelect = YES;
        [cell.indexB setBackgroundImage:[UIImage imageNamed:@"Order_repeat_selected"] forState:UIControlStateNormal];
    }else{
        isSelect = NO;
        [cell.indexB setBackgroundImage:[UIImage imageNamed:@"Order_repeat_normal"] forState:UIControlStateNormal];
        
    }
    cell.repeatL.text = self.dataSource[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempString = self.dataSource[indexPath.row];
    
    if ([tempString isEqualToString:@"一周"]) {
        self.repeat = 1;
    }
    else if ([tempString isEqualToString:@"两周"]) {
        self.repeat = 2;
    }
    else if ([tempString isEqualToString:@"三周"]) {
        self.repeat = 3;
    }
    else if ([tempString isEqualToString:@"不重复"]) {
        self.repeat = 0;
    }
    LXTimeRepeatVCTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     [cell.indexB setBackgroundImage:[UIImage imageNamed:@"Order_repeat_selected"] forState:UIControlStateNormal];
    
    if (indexPath !=index) {
        LXTimeRepeatVCTableViewCell *cell1 = [tableView cellForRowAtIndexPath:index];
        [cell1.indexB setBackgroundImage:[UIImage imageNamed:@"Order_repeat_normal"] forState:UIControlStateNormal];
    }
    
    index = indexPath;
}


#pragma mark - Action

- (void)confirmClick {
    LXWeakSelf(self);
    self.myblock(weakself.repeat);
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
        [_addBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}


@end
