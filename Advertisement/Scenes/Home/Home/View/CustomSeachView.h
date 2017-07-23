//
//  CustomSeachView.h
//  CRM
//
//  Created by 翟凤禄 on 2017/3/17.
//  Copyright © 2017年 xinpingTech. All rights reserved.
//

/*----------------------------自定义搜索框--------------------------*/
#import <UIKit/UIKit.h>
typedef void (^ScreanActionBlock)();//筛选 block
@interface CustomSeachView : UISearchBar
@property(nonatomic)CGRect searchTextFrame;//输入框边缘
@property (nonatomic,strong)UIButton *screenButton;// 筛选;
@property(nonatomic,copy)ScreanActionBlock screenBlock;
@end
