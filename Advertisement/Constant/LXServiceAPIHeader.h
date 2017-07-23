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
static NSString *const GetImage = @"http://112.74.38.196:8081/ihealthcare/common/image";
static NSString *const GetThumbImage = @"http://112.74.38.196:8081/ihealthcare/common/thumbimage/";

// 登录注册
static NSString *const LoginAPIGetVerify = @"/user/getverifyno.htm";
static NSString *const LoginAPICheckVerify = @"/user/checkverifyno.htm";
static NSString *const LoginAPILogIn = @"/user/login.htm";
static NSString *const LoginAPILogOut = @"/user/logout.htm";

// 主页
static NSString *const HomeAPI = @"HomeAPI";
static NSString *const HomeAPIServiceProject = @"/goods/queryServeItem.htm";
static NSString *const HomeAPIServiceDetail = @"/goods/queryServeItemInfo.htm";
static NSString *const HomeAPIReservation = @"/order/saveOrder.htm";
static NSString *const HomeAPIGetAddress = @"/address/queryMiDefAddress.htm";

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
static NSString *const speakOrder = @"/order/evaluateOrder.htm";
static NSString *const cancleOrder = @"/order/cancelOrder.htm";
static NSString *const deleteOrder = @"/order/delOrder.htm";
static NSString *const feedback = @"/feedback/saveFeedBack.htm";

// 我的
static NSString *const MineAPIUploadImage = @"/common/uploadimages.htm";
static NSString *const MineAPIMine = @"/user/queryUserByUserCode.htm";
static NSString *const MineAPIMineUpdate = @"/user/updataUser.htm";

static NSString *const MineAPICare = @"/careObj/queryCareObjForOrder.htm";
static NSString *const CareObjList = @"/careObj/queryCareObjListByUserId.htm";
static NSString *const MineAPICareAddProject = @"/careObj/saveCareObject.htm";
static NSString *const MineAPICareDetail = @"/careObj/queryCareObjInfo.htm";
static NSString *const MineAPIBarthelList = @"/barthel/queryBarthelConfig.htm";
static NSString *const MineAPIBarthelLevel = @"/barthel/queryBarthelGrade.htm";
static NSString *const MapApiGetWorker = @"/user/queryCwWorkerCount.htm";
static NSString *const upDataCareObj = @"/careObj/updateCareObject.htm";
static NSString *const careDetailBartheLevel = @"/barthel/queryBarthelUpdMi.htm";

//消息
static NSString *const MessageList = @"/msg/queryMsg.htm";
static NSString *const MessageRead = @"/msg/updMsgById.htm";
static NSString *const MessageDele = @"/msg/delMsgById.htm";
static NSString *const MessageDeleAll = @"/msg/empMsgById.htm";

//支付
static NSString *const AlipayApi= @"/alipay/doalipay.htm";
static NSString *const upDataOrder= @"/alipay/callback2.htm";


#endif /* LXServiceAPIHeader_h */
