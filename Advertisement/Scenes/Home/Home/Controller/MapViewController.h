//
//  MapViewController.h
//  OA
//
//  Created by xinping-2 on 16/9/19.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXRootViewController.h"
typedef void(^MapBlock)(CGFloat longatiude,CGFloat latitudu);

@interface MapViewController : LXRootViewController

@property (nonatomic, assign) int type; //如果是发起审批页面跳转过来的，搜索不限距离；处理审批页面限制搜索距离;-----处理审批页面点击地图查看全屏显示，且不做任何操作

@property (nonatomic, assign) CLLocationCoordinate2D coordinate2;//处理审批页面点击地图查看地点的经纬度

@property (nonatomic, copy) MapBlock mapBlock;
//保存按钮点击回调
-(void)saveMapData:(MapBlock)stringValue;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;//选择地点的经纬度

//签到成功
@property (nonatomic,copy)  void (^SignSuccessBlock)();

@property(nonatomic,copy)NSString *mapId;

@end
