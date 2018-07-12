//
//  Target_program.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_gift : NSObject

- (UIViewController *)Action_nativeFetchMyTicketViewController:(NSDictionary *)params;

/**
 pay for video

 @param params @{ @"itemModel":WVRItemModel, @"streamType":WVRStreamType , @"cmd":RACCommand }
 */
- (void)Action_nativePayForVideo:(NSDictionary *)params;

/**
 付费视频播放过程中检测设备

 @param params @{ @"cmd":RACCommand }
 */
- (void)Action_nativeCheckDevice:(NSDictionary *)params;

/**
 用户播放付费视频时上报设备

 @param params @{ @"cmd":RACCommand }
 */
- (void)Action_nativePayReportDevice:(NSDictionary *)params;

/**
 检测付费 视频/节目包 是否已支付
 
 @param params @{ @"cmd":RACCommand, @"failCmd":RACCommand, @"goodNo":goodNo, @"goodType":goodType]; }
 */
// 已支付，未支付，请求失败
- (void)Action_nativeCheckIsPaied:(NSDictionary *)params;

/**
 检测付费 视频列表 是否已支付
 
 @param params @{ @"cmd":RACCommand, @"failCmd":RACCommand, @"items":NSArray<NSDictionary *>keys:goodNo,goodType }
 */
// 已支付，未支付，请求失败
- (void)Action_nativeCheckVideosIsPaied:(NSDictionary *)params;

/**
 内购丢单上报

 @param params nil
 */
- (void)Action_nativeReportLostInAppPurchaseOrders:(NSDictionary *)params;

@end
