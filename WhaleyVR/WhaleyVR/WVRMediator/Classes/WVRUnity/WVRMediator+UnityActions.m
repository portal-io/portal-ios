//
//  WVRMediator+UnityActions.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator+UnityActions.h"
#import "YYModel.h"

NSString * const kWVRMediatorTargetUnity = @"unity";

NSString * const kWVRMediatorActionNativeSendUnityToPlay = @"nativeSendUnityToPlay";

NSString * const kWVRMediatorActionNativeSendMsgToUnity = @"nativeSendMsgToUnity";

NSString * const kWVRMediatorActionNativeShowU3DView = @"nativeShowU3DView";

NSString * const kWVRMediatorActionNativeShowTabView = @"nativeShowTabView";

NSString * const kWVRMediatorActionNativeSetPlayerHelper = @"nativeSetPlayerHelper";

NSString * const kWVRMediatorActionNativeSetPlayerUIManager = @"nativeSetPlayerUIManager";

NSString * const kWVRMediatorActionNativeIsUnityEnvironment = @"nativeIsUnityEnvironment";


@implementation WVRMediator (UnityActions)

- (void)WVRMediator_sendUnityToPlay:(WVRUnityActionPlayModel *)params {
    
    [self performTarget:kWVRMediatorTargetUnity
                 action:kWVRMediatorActionNativeSendUnityToPlay
                 params:[params yy_modelToJSONObject]
      shouldCacheTarget:YES];
}

- (void)WVRMediator_sendMsgToUnity:(WVRUnityActionMessageModel *)params {
    
    [self performTarget:kWVRMediatorTargetUnity
                 action:kWVRMediatorActionNativeSendMsgToUnity
                 params:[params yy_modelToJSONObject]
      shouldCacheTarget:YES];
}

- (void)WVRMediator_showU3DView:(BOOL)needStartScene {
    
    [self performTarget:kWVRMediatorTargetUnity
                 action:kWVRMediatorActionNativeShowU3DView
                 params:@{ @"needStartScene": @(needStartScene) }
      shouldCacheTarget:YES];
}

- (void)WVRMediator_showTabView:(BOOL)toRoot {
    
    [self performTarget:kWVRMediatorTargetUnity
                 action:kWVRMediatorActionNativeShowTabView
                 params:@{ @"toRoot": @(toRoot) }
      shouldCacheTarget:YES];
}

- (void)WVRMediator_setPlayerHelper:(id)playerHelper {
    
    [self performTarget:kWVRMediatorTargetUnity
                 action:kWVRMediatorActionNativeSetPlayerHelper
                 params:@{ @"playerHelper": playerHelper }
      shouldCacheTarget:YES];
}

- (void)WVRMediator_setUIManager:(id)playerUIManager {
    
    [self performTarget:kWVRMediatorTargetUnity
                 action:kWVRMediatorActionNativeSetPlayerUIManager
                 params:@{ @"playerUIManager": playerUIManager }
      shouldCacheTarget:YES];
}

- (id)WVRMediator_isUnityEnvironment:(NSDictionary *)params {
    
    return [self performTarget:kWVRMediatorTargetUnity
                 action:kWVRMediatorActionNativeIsUnityEnvironment
                 params:@{ @"key": @"value" }
      shouldCacheTarget:YES];
}

@end


@implementation WVRUnityActionPlayPathModel

@end


@implementation WVRUnityActionPlayModel

@end


@implementation WVRUnityActionMessageModel

@end
