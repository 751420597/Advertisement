//
//  LXServiceAPIHeader.h
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#ifndef LXServiceAPIHeader_h
#define LXServiceAPIHeader_h

// 图片
static NSString *const GetImage = @"http://112.74.38.196:8081/healthcare/common/image";
static NSString *const GetThumbImage = @"http://112.74.38.196:8081/healthcare/common/thumbimage/";

// 登录注册
static NSString *const LoginAPIGetVerify = @"/user/getverifyno.htm";
static NSString *const LoginAPICheckVerify = @"/user/checkverifyno.htm";
static NSString *const LoginAPILogIn = @"/user/login.htm";


// 主页
static NSString *const HomeAPI = @"HomeAPI";
static NSString *const HomeAPIServiceProject = @"/goods/queryServeItem.htm";
static NSString *const HomeAPIServiceDetail = @"/goods/queryServeItemInfo.htm";
static NSString *const HomeAPIReservation = @"/save/saveOrder.htm";


// 机构
static NSString *const OrganizationAPIList = @"/agency/queryagency.htm";
static NSString *const OrganizationAPIStaffs = @"/agency/queryCareWorkersByAgencyId.htm";
static NSString *const OrganizationAPIStaffInfo = @"/agency/queryCareWorkersInfoByCwId.htm";
static NSString *const OrganizationAPIAddStaff = @"/agency/queryCorInfoListForcareObj.htm";


// 订单
static NSString *const OrderAPIList = @"/order/queryUserOrder.htm";
static NSString *const OrderAPIRecorde = @"/order/queryServiceRecord.htm";
static NSString *const OrderAPIComment = @"/order/evaluateOrder.htm";
static NSString *const OrderAPIDetail = @"/order/queryOrderInfo.htm";
static NSString *const OrderAPIServiceProject = @"/order/queryOrderInfoCareObjList.htm";


// 我的
static NSString *const MineAPIUploadImage = @"/common/uploadimages.htm";
static NSString *const MineAPIMine = @"/user/queryUserByUserCode.htm";
static NSString *const MineAPIMineUpdate = @"/user/updataUser.htm";

static NSString *const MineAPICare = @"/careObj/queryCareObjListByUserId.htm";
static NSString *const MineAPICareAddProject = @"/careObj/saveCareObject.htm";
static NSString *const MineAPICareDetail = @"/careObj/queryCareObjInfo.htm";
static NSString *const MineAPIBarthelList = @"/barthel/queryBarthelConfig.htm";
static NSString *const MineAPIBarthelLevel = @"/barthel/queryBarthelGrade.htm";



//消息
static NSString *const MessageList = @"/msg/queryMsg.htm";
static NSString *const MessageRead = @"/msg/updMsgById.htm";
static NSString *const MessageDele = @"/msg/delMsgById.htm";
static NSString *const MessageDeleAll = @"/msg/empMsgById.htm";

#endif /* LXServiceAPIHeader_h */
