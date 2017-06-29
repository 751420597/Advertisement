//
//  LXHomeOrderView.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/6.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXHomeOrderView.h"

@interface LXHomeOrderView ()

@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) dispatch_block_t block;

@end


@implementation LXHomeOrderView

- (instancetype)initWithImageString:(NSString *)imageString block:(dispatch_block_t)block {
    if (self = [super init]) {
        //[self setBackgroundColor:[UIColor blackColor]];
        
        self.string = imageString;
        self.block = block;
        
        [self setUpSubViews];
    }
    return self;
}


#pragma mark - Layout

- (void)layoutSubviews {
    
}


#pragma mark - Set up

- (void)setUpSubViews {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:self.string] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    LXWeakSelf(self);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakself).with.insets(padding);
    }];
}


#pragma mark - Action

- (void)btnClick:(id)sender {
    if (self.block) {
        self.block();
    }
}

@end
