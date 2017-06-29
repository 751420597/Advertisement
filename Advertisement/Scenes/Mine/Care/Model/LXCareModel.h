//
//  LXCareModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/22.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "HHAPIManager.h"

@interface LXCareModel : HHAPIManager

@property (nonatomic, copy) NSString *careObjId;
@property (nonatomic, copy) NSString *careObjName;
@property (nonatomic, copy) NSString *checkStateId;
@property (nonatomic, copy) NSString *checkStateName;
@property (nonatomic, copy) NSString *checkTime;

@end
