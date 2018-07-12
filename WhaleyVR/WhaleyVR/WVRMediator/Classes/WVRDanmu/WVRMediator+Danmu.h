//
//  WVRMediator+Danmu.h
//  WVRMediator
//
//  Created by Bruce on 2017/9/13.
//  Copyright © 2017年 WhaleyVR. All rights reserved.
//

#import "WVRMediator.h"

@interface WVRMediator (Danmu)

/**
 节目是否已建立长连接
 
 @param params nil
 @return 节目是否已建立长连接
 */
- (BOOL)WVRMediator_ConnectIsActive:(NSDictionary *)params;

/**
 为节目建立长连接
 
 @param params @{ @"block":(void(^)(WVRWebSocketMsg *msg)), @"programId":NSString, @"programName":NSString }
 */
- (void)WVRMediator_ConnectForDanmu:(NSDictionary *)params;

/**
 发送弹幕消息
 
 @param params @{ @"successBlock":(void(^)(void)), @"msg":NSString }
 */
- (void)WVRMediator_SendMessage:(NSDictionary *)params;

/**
 关闭为节目建立的长连接
 
 @param params @{ @"programId":NSString }
 */
- (void)WVRMediator_CloseForDanmu:(NSDictionary *)params;

/**
 登录后申请弹幕服务端授权
 
 @param params nil
 */
- (void)WVRMediator_AuthAfterLogin:(NSDictionary *)params;

- (void)WVRMediator_SetReceiveGiftBlockParams:(NSDictionary *)params;

- (void)WVRMediator_SetReceiveGiftDanmuBlockParams:(NSDictionary *)params;

@end
