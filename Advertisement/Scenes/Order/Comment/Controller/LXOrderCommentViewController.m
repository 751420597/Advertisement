//
//  LXOrderCommentViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/14.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOrderCommentViewController.h"

#import "CWStarRateView.h"

#import "LXOrderCommentViewModel.h"

@interface LXOrderCommentViewController ()

@property (nonatomic, strong) UIButton *addBtn;

@property (weak, nonatomic) IBOutlet CWStarRateView *starView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *anonymityBtn;

@property (nonatomic, strong) LXOrderCommentViewModel *viewModel;

- (IBAction)anonymityBtnClick:(id)sender;

@end

@implementation LXOrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评价";
    [self.view setBackgroundColor:LXVCBackgroundColor];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpaceBarButtonItem.width = -10;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addBtn];
    self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    
    self.starView.scorePercent = 1;
    self.starView.allowIncompleteStar = YES;
    self.starView.hasAnimation = NO;
}


#pragma mark - Action

- (void)addBtnClick {
    self.viewModel = [LXOrderCommentViewModel new];
    
    LXWeakSelf(self);
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    
//    orderId	订单id	必填
//    userId	用户id	必填
//    userCode	用户登录名（用户手机号）	必填
//    starLevel	评价星级	必填
//    evaluateContent	评价内容	必填
//    isAnon	是否匿名-- 1 是， 0 否	必填

    
    NSDictionary *dictP = @{ 
                             @"userCode":@"",
                             @"starLevel":@"",
                             @"evaluateContent":@"",
                             @"isAnon":@""};
    
    [self.viewModel updateCommentWithParameters:dictP completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        if (code == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}

- (IBAction)anonymityBtnClick:(id)sender {
    UIButton *tempBtn = (UIButton *)sender;
    tempBtn.selected = !tempBtn.selected;
    
//    if (tempBtn.selected) {
//        [tempBtn setBackgroundImage:[UIImage imageNamed:@"Order_comment_selected"] forState:UIControlStateNormal];
//    }
//    else {
//        [tempBtn setBackgroundImage:[UIImage imageNamed:@"Order_comment_normal"] forState:UIControlStateNormal];
//    }
}


#pragma mark - Getter

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_addBtn setFrame:CGRectMake(0, 0, 40, 30)];
        [_addBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}


@end
