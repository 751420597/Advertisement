//
//  PayViewController.m
//  Advertisement
//
//  Created by 翟凤禄 on 2017/7/6.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "PayViewController.h"
#import "PayCell.h"
#import "OrderViewModel.h"
#import "LXZhiFuBaoPayModel.h"
#import "LXPayCallUp.h"
#import "LXOrderViewController.h"
@interface PayViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *secondView;
    UIImageView *selectImgV;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor orangeColor]];
    self.title = @"支付订单";
    [self.view setBackgroundColor:LXColorHex(0xf5f5f5)];
    
    UIView *firstView =[[UIView alloc]initWithFrame:CGRectMake(15, 10, LXScreenWidth-30, 50)];
    firstView.backgroundColor = [UIColor whiteColor];
    firstView.layer.cornerRadius = 3;
    firstView.layer.borderColor = LXCellBorderColor.CGColor;
    firstView.layer.borderWidth = 0.5;
    [self.view addSubview:firstView];
    
    UILabel *accountLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, CGRectGetWidth(firstView.frame)-30, CGRectGetHeight(firstView.frame))];
    accountLB.textColor = LXMainColor;
    
    accountLB.font = [UIFont systemFontOfSize:16.f];
    NSString *sting =[NSString stringWithFormat:@"总计：¥ %@",self.money];
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:sting];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(5, self.money.length)];
    accountLB.attributedText =attributedText;
    
    [firstView addSubview:accountLB];
    
    secondView =[UIButton buttonWithType:UIButtonTypeCustom];
       secondView.frame=CGRectMake(15, 10+CGRectGetMaxY(firstView.frame), LXScreenWidth-30, 50);
    secondView.backgroundColor = [UIColor whiteColor];
    secondView.layer.cornerRadius = 3;
    secondView.layer.borderColor = LXCellBorderColor.CGColor;
    secondView.layer.borderWidth = 0.5;
    secondView.selected = NO;
    [secondView addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondView];
    
    UIImageView *weChatImgV=[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 20, 20)];
    weChatImgV.layer.cornerRadius = 3;
    weChatImgV.centerY = 25;
    weChatImgV.contentMode = UIViewContentModeScaleAspectFit;
    weChatImgV.image = [UIImage imageNamed:@"aliPay"];
    [secondView addSubview:weChatImgV];
    
    
    UILabel *weChatLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(weChatImgV.frame)+10, 0, 120, 50)];
    weChatLB.text = @"支付宝支付";
    weChatLB.font = [UIFont systemFontOfSize:14.f];
    [secondView addSubview:weChatLB];
    
    selectImgV=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(secondView.frame)-30, 0, 16, 15)];
    selectImgV.layer.cornerRadius = 3;
    selectImgV.centerY = 25;
    selectImgV.contentMode = UIViewContentModeScaleAspectFit;
    selectImgV.image = [UIImage imageNamed:@"select_no"];
    
    [secondView addSubview:selectImgV];

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(15, CGRectGetMaxY(secondView.frame)+10, LXScreenWidth-30, 50);
    [button setBackgroundImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)select{
    secondView.selected = !secondView.isSelected;
    if(secondView.isSelected){
        selectImgV.image = [UIImage imageNamed:@"select_yes"];
    }else{
        selectImgV.image = [UIImage imageNamed:@"select_no"];
    }
}
-(void)payMoney{
    if(secondView.isSelected){
    OrderViewModel *orderViewModel = [[OrderViewModel alloc]init];
        NSDictionary *dic =@{@"body":@"测试",@"subject":@"订单支付",@"out_trade_no":self.orderId,@"total_amount":@"0.01"};
        [orderViewModel getOrderWithParameters:dic completionHandler:^(NSError *error, id result) {
            int code = [result[@"code"] intValue];
            if(code==0){

                LXZhiFuBaoPayModel *payModel = [LXZhiFuBaoPayModel modelWithDictionary:result];

                [LXPayCallUp  gotoZhiFuBaoPayWithModel:payModel successBlock:^(NSDictionary *result) {
                    [SVProgressHUD showInfoWithStatus:@"支付成功!"];
                    [orderViewModel upDataOrderWithParameters:@{@"orderNo":self.orderId,@"orderPrice":@"0.01"} completionHandler:^(NSError *error, id result) {
                        int code = [result[@"code"] intValue];
                        if(code==0){
                            for (UIViewController *vc in self.navigationController.viewControllers) {
                                if([vc isKindOfClass:[LXOrderViewController class]]){
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"payOK" object:nil];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self.navigationController popToViewController:vc animated:YES];
                                    });
                                    
                                }
                            }
                            
                        }
                    }];

                } failureBlock:^(NSDictionary *error) {

                }];
            }else{
                [SVProgressHUD showErrorWithStatus:@"哎呀,出错了!"];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
