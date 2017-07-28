//
//  LXSuggestViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/19.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXSuggestViewController.h"
#import "LXWaitOrderViewModel.h"
@interface LXSuggestViewController ()<UITextViewDelegate>

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
    self.textView.delegate  = self;
    [self.textView lx_setViewCornerRadius:3 borderColor:LXCellBorderColor borderWidth:1];
}


#pragma mark - Action

- (void)btnClick {
    if([self.textView.text isEqualToString:@"请输入您的建议："]||self.textView.text.length==0){
        [SVProgressHUD showInfoWithStatus:@"请输入您的建议!"];
        return;
    }
    NSDictionary *dictP = @{@"content":_textView.text};
    LXWaitOrderViewModel *modelV = [[LXWaitOrderViewModel alloc]init];
    [modelV tousuWithParameters:dictP completionHandler:^(NSError *error, id result) {
        
        [SVProgressHUD dismiss];
        int code = [result[@"code"] intValue];
        
        if (code == 0) {
            [SVProgressHUD showInfoWithStatus:@"已提交"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
    

}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"请输入您的建议："]){
        textView.text=@"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length<=0){
        self.textView.text = @"请输入您的建议：";
    }
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
