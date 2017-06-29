//
//  LXHomeTitleView.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/16.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXHomeTitleView.h"

@interface LXHomeTitleView ()

@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *image;
@property (nonatomic, copy) dispatch_block_t block;

@end


@implementation LXHomeTitleView

- (instancetype)initWithClickBlock:(dispatch_block_t)block {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.block = block;
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    LXWeakSelf(self);
    
    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleBtn setTitle:@"北京市" forState:UIControlStateNormal];
    [self.titleBtn addTarget:self action:@selector(viewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.titleBtn];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakself.mas_centerX);
        make.centerY.mas_equalTo(weakself.centerY).mas_offset(0);
    }];
    
    self.image = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.image setBackgroundImage:[UIImage imageNamed:@"Home_up_arrow"] forState:UIControlStateNormal];
    [self.image addTarget:self action:@selector(viewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakself.centerY);
        make.leading.mas_equalTo(weakself.titleBtn.mas_trailing).mas_equalTo(5);
    }];
}

- (void)viewClick {
    if (self.block) {
        self.block();
    }
}

@end
