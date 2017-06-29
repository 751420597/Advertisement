//
//  LXRootTableViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootViewController.h"

@interface LXRootTableViewController : LXRootViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL addCellLine;

- (void)setUpTableViewWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
              backgroundColor:(UIColor *)color;

- (void)addCustomeLineWithArray:(NSArray *)dataArray
                      indexPath:(NSIndexPath *)indexPath
                          width:(CGFloat)width
                         height:(CGFloat)height
                          color:(UIColor *)color
                           cell:(UITableViewCell *)cell;


@end
