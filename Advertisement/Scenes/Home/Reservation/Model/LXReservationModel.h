//
//  LXReservationModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LXReservationTimeModel.h"

@interface LXReservationModel : NSObject

@property (nonatomic, copy) NSString *servTypeId;
@property (nonatomic, copy) NSString *servTypeName;
@property (nonatomic, copy) NSString *contactUser;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *careObjName;
@property (nonatomic, copy) NSString *serveTime;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *otherContent;
@property (nonatomic, copy) NSString *chanOrderState;
@property (nonatomic, copy) NSString *ordPrice;
@property (nonatomic, copy) NSArray *orderItemList;
@property (nonatomic, copy) NSString *userTypeId;
@property (nonatomic, strong) LXReservationTimeModel *timeModel;

@end
