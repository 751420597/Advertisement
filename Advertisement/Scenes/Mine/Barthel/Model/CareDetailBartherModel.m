//
//  CareDetailBartherModel.m
//  Advertisement
//
//  Created by 翟凤禄 on 2017/7/11.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "CareDetailBartherModel.h"

@implementation CareDetailBartherModel
-(CareDetailBartherModel *)careDetailBartherModelWithDic:(NSDictionary *)dic{
    if(dic){
        self.bcId = [NSString stringWithFormat:@"%@",dic[@"bcId"]];
        self.evaItem = [NSString stringWithFormat:@"%@",dic[@"evaItem"]];
        
        NSArray *bgList1 =[NSArray arrayWithArray:dic[@"bgList"]];
        NSMutableArray *tempArr =[NSMutableArray array];
        for (NSDictionary *dic  in bgList1) {
            NSString *evaItemVal =[NSString stringWithFormat:@"%@",dic[@"evaItemVal"]];
            if(evaItemVal.length>0){
                [tempArr addObject:dic];
            }
        }
        self.bgList = (NSArray*)tempArr;
    }
    return self;
}

@end
