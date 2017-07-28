//
//  LXOderDealView.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/14.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXOderDealView.h"

@interface LXOderDealView ()

@property (nonatomic, copy) dispatch_block_t didClick;

@property (nonatomic, strong) UILabel *totalPriceL;
@property (nonatomic, strong) UIButton *trailingB;

@end


@implementation LXOderDealView

- (instancetype)initWithTrailingClick:(dispatch_block_t)block {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.didClick = block;
        
        [self setUpSubViews];
    }
    return self;
}


#pragma mark - Set Up

- (void)setUpSubViews {
    LXWeakSelf(self);
    
    UIView *topView = [[UIView alloc] init];
    [topView setBackgroundColor:LXColorHex(0xD5D5D5)];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(weakself);
        make.right.mas_equalTo(weakself);
        make.left.mas_equalTo(weakself);
    }];
    
    self.totalPriceL = [[UILabel alloc] init];
    [self.totalPriceL setFont:[UIFont systemFontOfSize:15]];
    [self.totalPriceL setTextColor:LXMainColor];
    [self addSubview:self.totalPriceL];
    [self.totalPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself).mas_offset(10);
        make.center.mas_equalTo(weakself);
    }];
    
    self.trailingB = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.trailingB setBackgroundColor:LXMainColor];
    [self.trailingB.titleLabel setTextColor:[UIColor whiteColor]];
    [self.trailingB.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.trailingB setTitle:@"" forState:UIControlStateNormal];
    [self.trailingB addTarget:self action:@selector(trailingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.trailingB];
    [self.trailingB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakself).mas_offset(0);
        make.width.mas_equalTo(135);
        make.top.mas_equalTo(weakself);
        make.bottom.mas_equalTo(weakself);
    }];
}


#pragma mark - Action

- (void)trailingBtnClick {
    if (self.didClick) {
        self.didClick();
    }
}


#pragma mark - Setter

- (void)setLeadingString:(NSString *)leadingString {
    _leadingString = leadingString;
    
    [self.totalPriceL setText:leadingString];
}

- (void)setTrailingString:(NSString *)trailingString {
    _trailingString = trailingString;
    
    [self.trailingB setTitle:trailingString forState:UIControlStateNormal];
}


@end
