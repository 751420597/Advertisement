//
//  LXSuggestViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/19.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXSuggestViewController.h"

@interface LXSuggestViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UIButton *addBtn;

@end


@implementation LXSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"投诉建议";
    self.view.backgroundColor = LXVCBackgroundColor;
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpaceBarButtonItem.width = -10;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
    barButtonItem.width = 10;
    self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    
    [self.textView lx_setViewCornerRadius:3 borderColor:LXCellBorderColor borderWidth:1];
}


#pragma mark - Action

- (void)btnClick {
    
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
        [_addBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
