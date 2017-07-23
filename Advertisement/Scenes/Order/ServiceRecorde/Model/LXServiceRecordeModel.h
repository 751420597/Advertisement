//
//  LXServiceRecordeModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXServiceRecordeModel : NSObject

@property (nonatomic, copy) NSString *cwUserId;  //护工用户ID
@property (nonatomic, copy) NSString *cwoId;     //护工订单id
@property (nonatomic, copy) NSString *ordStateId; //ordStateId
@property (nonatomic, copy) NSString *imgId;      //
@property (nonatomic, copy) NSString *isDone;  //1完成 2未完成
@property (nonatomic, copy) NSString *subOrdTime; //订单提交时间
@property (nonatomic, copy) NSString *takOrdTime; //接单时间
@property (nonatomic, copy) NSString *startTime;//开始服务时间
@property (nonatomic,strong)NSArray *serviceRecordList;
@property (nonatomic, copy) NSString * haveData;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic ,strong) NSArray *cwEvList;//评价

@end
