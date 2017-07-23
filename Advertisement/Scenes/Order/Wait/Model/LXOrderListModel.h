//
//  LXOrderListModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/21.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXOrderListModel : NSObject

// 订单状态—0:待接单 1:已接单 2:已完成 3:已取消
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *ordId;
@property (nonatomic, copy) NSString *tmUserName;
@property (nonatomic, copy) NSString *crtTime;
@property (nonatomic, copy) NSString *ordStatId;
@property (nonatomic, copy) NSString *ordAmt;
@property (nonatomic, copy) NSString *tmUserCode;
@property (nonatomic, copy) NSString *serveTime;
@end
