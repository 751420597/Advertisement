//
//  LXRootTableViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

static CGFloat customeLineWidth = 1.f;
static CGFloat customeLineLeftEdge = 10;

@interface LXRootTableViewController ()


@end


@implementation LXRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUpTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style backgroundColor:(UIColor *)color {
    _tableView = [[UITableView alloc] initWithFrame:frame style:style];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = color;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    
    if (_tableView.style == UITableViewStyleGrouped) {
         _tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    }
}

- (void)addCustomeLineWithArray:(NSArray *)dataArray
                      indexPath:(NSIndexPath *)indexPath
                          width:(CGFloat)width
                         height:(CGFloat)height
                          color:(UIColor *)color
                           cell:(UITableViewCell *)cell {
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, customeLineWidth)];
    [topLine setBackgroundColor:color];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:topLine];
    }
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, customeLineWidth, height)];
    [leftLine setBackgroundColor:color];
    [cell.contentView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(width - 1, 0, customeLineWidth, height)];
    [rightLine setBackgroundColor:color];
    [cell.contentView addSubview:rightLine];
    
    NSInteger myBottomLineWidth;
    NSInteger myBottomLineOriginX;
    if (indexPath.row == [dataArray count] - 1) {
        myBottomLineOriginX = 0;
        myBottomLineWidth = width - myBottomLineOriginX;
        
    }
    else {
        myBottomLineOriginX = customeLineLeftEdge;
        myBottomLineWidth = width - myBottomLineOriginX;
    }
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(myBottomLineOriginX, height - 1, myBottomLineWidth, customeLineWidth)];
    [bottomLine setBackgroundColor:color];
    [cell.contentView addSubview:bottomLine];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *method1 = [NSString stringWithFormat:@"重写%s", __FUNCTION__];
    NSAssert(NO, method1);
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *method1 = [NSString stringWithFormat:@"重写%s", __FUNCTION__];
    NSAssert(NO, method1);
    
    return [self.dataSource count];
}


#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
