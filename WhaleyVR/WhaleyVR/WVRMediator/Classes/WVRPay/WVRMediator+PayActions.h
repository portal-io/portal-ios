//
//  WVRMediator+Account.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator.h"

@interface WVRMediator (PayActions)

- (UIViewController *)WVRMediator_MyTicketViewController;

/**
 pay for video
 
 @param params @{ @"itemModel":WVRItemModel, @"streamType":WVRStreamType , @"cmd":RACCommand }
 */
// 支付成功，支付失败（包括网络请求失败）
- (void)WVRMediator_PayForVideo:(NSDictionary *)params;

- (void)WVRMediator_PayForWCurrency:(NSDictionary *)params;
/**
 检测付费 视频/节目包 是否已支付
 
 @param params @{ @"cmd":RACCommand, @"failCmd":RACCommand, @"goodNo":goodNo, @"goodType":goodType]; }
 goodType 不知道的话置空
 */
// 已支付，未支付，请求失败
- (void)WVRMediator_CheckVideoIsPaied:(NSDictionary *)params;

/**
 检测付费 视频列表 是否已支付
 
 @param params @{ @"cmd":RACCommand, @"failCmd":RACCommand, @"items":NSArray<NSDictionary *>keys:goodNo,goodType }

 */
// 已支付，未支付，请求失败
- (void)WVRMediator_CheckVideosIsPaied:(NSDictionary *)params;

/**
 用户播放付费视频时上报设备
 
 @param params @{ @"cmd":RACCommand }
 */
// 上报，未考虑网络失败的情况（日后可做改进）
- (void)WVRMediator_PayReportDevice:(NSDictionary *)params;

/**
 付费视频播放时进行设备检测
 
 @param params @{ @"cmd":RACCommand }
 */
// 非异常状况，则不执行回调
- (void)WVRMediator_CheckDevice:(NSDictionary *)params;

/**
 内购丢单上报
 */
// 主动触发事件，无回调，不关心状态，注意异常情况打印日志
- (void)WVRMediator_ReportLostInAppPurchaseOrders;

@end
