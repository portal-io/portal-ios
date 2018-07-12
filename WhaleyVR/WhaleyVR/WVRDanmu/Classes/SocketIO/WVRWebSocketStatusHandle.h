//
//  WVRWebSocketStatusHandle.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRWebSocketConfig.h"
#import "WVRWebSocketStatusDelegate.h"

typedef NS_ENUM(NSInteger, WVRWebSocketStatus) {
    WVRWebSocketStatusDefault,
    WVRWebSocketStatusLogined,
    
};
@interface WVRWebSocketStatusHandle : NSObject<WVRWebSocketStatusDelegate>

@property (nonatomic, copy) void(^canConnectSocketBlock)(void);

-(void)prepareForConnect:(WVRWebSocketConfig*)config;

-(BOOL)canSendMsg;

@end
