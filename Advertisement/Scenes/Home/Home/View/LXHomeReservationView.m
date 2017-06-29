//
//  LXHomeReservationView.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/6.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXHomeReservationView.h"

@interface LXHomeReservationView ()

@property (nonatomic, copy) dispatch_block_t clickBlock;

@end


@implementation LXHomeReservationView

- (instancetype)initWithClickBlock:(dispatch_block_t)block {
    if (self = [super init]) {
        //[self setBackgroundColor:[UIColor blackColor]];
    
        [self setUpSubViews];

        self.clickBlock = block;
    }
    return self;
}


#pragma mark - Set up

- (void)setUpSubViews {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"Home_reservation"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    LXWeakSelf(self);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakself).with.insets(padding);
    }];
}


#pragma mark - Aciton

- (void)btnClick:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
