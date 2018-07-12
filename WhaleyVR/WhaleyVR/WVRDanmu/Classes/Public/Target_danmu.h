//
//  Target_danmu.h
//  WVRDanmu
//
//  Created by Bruce on 2017/9/13.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_danmu : NSObject

/**
 节目是否已建立长连接

 @param params nil
 @return 节目是否已建立长连接
 */
- (BOOL)Action_nativeConnectIsActive:(NSDictionary *)params;

/**
 为节目建立长连接
 
 @param params @{ @"block":(void(^)(WVRWebSocketMsg *msg)), @"programId":NSString, @"programName":NSString }
 */
- (void)Action_nativeConnectForDanmu:(NSDictionary *)params;

/**
 发送弹幕消息

 @param params @{ @"successBlock":(void(^)(void)), @"msg":NSString }
 */
- (void)Action_nativeSendMessage:(NSDictionary *)params;

/**
 关闭为节目建立的长连接

 @param params @{ @"programId":NSString }
 */
- (void)Action_nativeCloseForDanmu:(NSDictionary *)params;

/**
 登录后申请弹幕服务端授权

 @param params nil
 */
- (void)Action_nativeAuthAfterLogin:(NSDictionary *)params;

/**
 为节目建立长连接
 
 @param params @{ @"receiveGiftMsgCallback":(void(^)(NSDictionary *msg))}
 */
- (void)Action_nativeSetReceiveGiftBlockParams:(NSDictionary *)params;

- (void)Action_nativeSetReceiveGiftDanmuBlockParams:(NSDictionary *)params;

@end
