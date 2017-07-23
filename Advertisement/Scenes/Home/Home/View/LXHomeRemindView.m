//
//  LXHomeRemindView.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/6.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXHomeRemindView.h"

@interface LXHomeRemindView ()

@property (nonatomic, copy) dispatch_block_t viewBlock;
@property (nonatomic, copy) NSString *remindString;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation LXHomeRemindView

- (instancetype)initWithRemindString:(NSString *)string didClosedBlock:(dispatch_block_t)block {
    if (self = [super init]) {
        self.layer.cornerRadius = 5.f;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self setBackgroundColor:[UIColor whiteColor]];
//        [self setAlpha:0.1];
        
        self.remindString = string;
        self.viewBlock = block;
        
        [self setUpSubviews];
    }
    return self;
}


#pragma mark - Set up

- (void)setUpSubviews {
    self.label = [[UILabel alloc] init];
    [self.label setFont:[UIFont systemFontOfSize:LXRate(12)]];
    [self.label setText:self.remindString];
    [self.label setTextColor:LXColorHex(0x4c4c4c)];
    [self addSubview:self.label];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"Home_close"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn];
}


#pragma mark - Layout

- (void)didMoveToSuperview {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label setFrame:CGRectMake(LXRate(10), 0, self.width - LXRate(30), self.height)];
    [self.label setCenterY:self.height / 2];
    
    [self.btn setFrame:CGRectMake(self.width - LXRate(25), 0, 15, 15)];
    [self.btn setCenterY:self.height / 2];
}


#pragma mark - Action

- (void)btnClick:(id)sender {
    if (self.viewBlock) {
        self.viewBlock();
    }
}

@end
