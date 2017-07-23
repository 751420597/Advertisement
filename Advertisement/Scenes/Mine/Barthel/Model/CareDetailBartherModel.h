//
//  CareDetailBartherModel.h
//  Advertisement
//
//  Created by 翟凤禄 on 2017/7/11.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CareDetailBartherModel : NSObject
@property(nonatomic,copy) NSString *bcId;;
@property(nonatomic,copy) NSString *evaItem;
@property(nonatomic,strong) NSArray *bgList;

-(CareDetailBartherModel *)careDetailBartherModelWithDic:(NSDictionary *)dic;
@end
