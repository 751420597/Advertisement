//
//  CustomSeachView.m
//  CRM
//
//  Created by 翟凤禄 on 2017/3/17.
//  Copyright © 2017年 xinpingTech. All rights reserved.
//

#import "CustomSeachView.h"

@implementation CustomSeachView


-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIView* backView in [[self.subviews lastObject] subviews]) {
        
        if ([backView isKindOfClass:[UITextField class]]) {
            
            UITextField *textField = (UITextField*)backView;
            
            //textField.backgroundColor = kThemeColor;/*目的是为了更改搜索框中的内容背景颜色*/
            textField.frame = _searchTextFrame;
            textField.borderStyle = UITextBorderStyleNone;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = LXColorHex(0xcacaca);
            textField.layer.cornerRadius = 2;
            textField.layer.masksToBounds = YES;
        }
        if ([backView isKindOfClass:[UIImageView class]]) {
            UIImageView *imgView = (UIImageView *)backView;
            imgView.image = nil;/*目的是为了防止mySearchBar和下面button之间出现一条线，这条线是由于UISearchBarBackground这个ImageView的默认图片构成的，所以要把它设为nil*/
        }
        
    }
    if(_screenButton==nil){
        _screenButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _screenButton.frame = CGRectMake(CGRectGetMaxX(_searchTextFrame), CGRectGetMinY(_searchTextFrame), 50, CGRectGetHeight(_searchTextFrame));
        [_screenButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_screenButton setImage:[UIImage imageNamed:@"stocker_01"] forState:UIControlStateNormal];
        [_screenButton setTitleColor:LXColorHex(0x171717) forState:UIControlStateNormal];
        _screenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_screenButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -23, 0, 0)];
        [_screenButton addTarget:self action:@selector(tipAction) forControlEvents:UIControlEventTouchUpInside];
        [_screenButton setImageEdgeInsets:UIEdgeInsetsMake(10, CGRectGetMaxX(_screenButton.titleLabel.frame)+15,10, 0)];
        _screenButton.titleLabel.font =[UIFont systemFontOfSize:14.0];
        [self addSubview:_screenButton];
    }
   
}
-(void)tipAction{
    if(_screenBlock){
        self.screenBlock();
    }
}
-(void)setSearchTextFrame:(CGRect)searchTextFrame{

    _searchTextFrame = searchTextFrame;
    [self layoutIfNeeded];
}



@end
