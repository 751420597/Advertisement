//
//  LXMessageModel.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/23.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXMessageModel : NSObject
@property(nonatomic,copy)NSString *msgId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *readFlag;//0 未读1已读
@property(nonatomic,copy)NSString *readTime;
@end
