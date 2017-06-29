//
//  LXHomeSearchView.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/5.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXHomeSearchView.h"

@interface LXHomeSearchView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *label;

@end

@implementation LXHomeSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:LXColorHex(0xFDFDFD)];
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"Home_search"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn setFrame:CGRectMake(10, 0, 16, 16)];
    [self addSubview:self.btn];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.btn.frame), self.frame.size.width-16, 16)];
    [self addSubview:self.btn];
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
    PrivateLetterTap.delegate= self;
    [self addGestureRecognizer:PrivateLetterTap];
}
#pragma mark ---点击触发的方法，完成跳转
- (void)tapAvatarView: (UITapGestureRecognizer *)gesture
{
    if(self.block){
        self.block();
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.btn setCenterY:self.frame.size.height / 2];
}

- (void)didMoveToSuperview {
    
}

#pragma mark - Action

- (void)btnClick:(id)sender {
    
}



@end
