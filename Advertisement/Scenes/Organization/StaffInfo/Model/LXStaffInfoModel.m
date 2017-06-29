//
//  LXStaffInfoModel.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/20.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXStaffInfoModel.h"

@implementation LXStaffInfoModel

- (void)setCwEvList:(NSArray *)cwEvList {
    NSArray *array = [NSArray modelArrayWithClass:[LXStaffCommentModel class] json:cwEvList];
    
    _cwEvList = array;
}

@end
