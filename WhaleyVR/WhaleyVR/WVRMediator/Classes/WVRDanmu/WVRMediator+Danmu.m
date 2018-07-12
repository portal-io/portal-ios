//
//  WVRMediator+Danmu.m
//  WVRMediator
//
//  Created by Bruce on 2017/9/13.
//  Copyright © 2017年 WhaleyVR. All rights reserved.
//

#import "WVRMediator+Danmu.h"

NSString * const kWVRMediatorTargetDanmu = @"danmu";

NSString * const kWVRMediatorActionNativeConnectIsActive = @"nativeConnectIsActive";

NSString * const kWVRMediatorActionNativeConnectForDanmu = @"nativeConnectForDanmu";

NSString * const kWVRMediatorActionNativeSendMessage = @"nativeSendMessage";

NSString * const kWVRMediatorActionNativeCloseForDanmu = @"nativeCloseForDanmu";

NSString * const kWVRMediatorActionNativeAuthAfterLogin = @"nativeAuthAfterLogin";

NSString * const kWVRMediatorActionNativeSetReceiveGiftBlockParams = @"nativeSetReceiveGiftBlockParams";
NSString * const kWVRMediatorActionNativeSetReceiveGiftDanmuBlockParams = @"nativeSetReceiveGiftDanmuBlockParams";

@implementation WVRMediator (Danmu)

// 注：WVRWebSocketClient是单例，所以shouldCacheTarget设置为YES

- (BOOL)WVRMediator_ConnectIsActive:(NSDictionary *)params {
    
    return [self performTarget:kWVRMediatorTargetDanmu
                        action:kWVRMediatorActionNativeConnectIsActive
                        params:params
             shouldCacheTarget:YES
            ];
}

- (void)WVRMediator_ConnectForDanmu:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetDanmu
                 action:kWVRMediatorActionNativeConnectForDanmu
                 params:params
      shouldCacheTarget:YES
     ];
}

- (void)WVRMediator_SendMessage:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetDanmu
                 action:kWVRMediatorActionNativeSendMessage
                 params:params
      shouldCacheTarget:YES
     ];
}

- (void)WVRMediator_CloseForDanmu:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetDanmu
                 action:kWVRMediatorActionNativeCloseForDanmu
                 params:params
      shouldCacheTarget:YES
     ];
}

- (void)WVRMediator_AuthAfterLogin:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetDanmu
                 action:kWVRMediatorActionNativeAuthAfterLogin
                 params:params
      shouldCacheTarget:YES
     ];
}


- (void)WVRMediator_SetReceiveGiftBlockParams:(NSDictionary *)params
{
    [self performTarget:kWVRMediatorTargetDanmu
                 action:kWVRMediatorActionNativeSetReceiveGiftBlockParams
                 params:params
      shouldCacheTarget:YES
     ];
}

- (void)WVRMediator_SetReceiveGiftDanmuBlockParams:(NSDictionary *)params
{
    [self performTarget:kWVRMediatorTargetDanmu
                 action:kWVRMediatorActionNativeSetReceiveGiftDanmuBlockParams
                 params:params
      shouldCacheTarget:YES
     ];
}
@end
