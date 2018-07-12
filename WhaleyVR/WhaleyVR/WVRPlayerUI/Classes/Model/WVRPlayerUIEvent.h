//
//  WVRPlayerUIEvent.h
//  WVRPlayerUI
//
//  Created by Bruce on 2017/9/19.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, PlayerUIEventReceiver) {
    
    PlayerUIEventReceiverComponent = 1 << 0,        // UI组件
    PlayerUIEventReceiverManager = 1 << 1,          // 组件管理器
    PlayerUIEventReceiverVC = 1 << 2,               // 视图控制器
};

@interface WVRPlayerUIEvent : NSObject

/**
 event name
 */
@property (nonatomic, copy, nonnull) NSString *name;

/**
 event params
 */
@property (nonatomic, strong, nullable) NSDictionary *params;

/**
 事件接收者 默认为 PlayerUIEventReceiverComponent
 */
@property (nonatomic, assign) PlayerUIEventReceiver receivers;

/// 初始化附带事件名
- (instancetype _Nonnull )initWithName:(NSString *_Nonnull)name;

/// 初始化附带事件名、参数
- (instancetype _Nonnull )initWithName:(NSString *_Nonnull)name params:(NSDictionary *_Nullable)params;

/// 组件中调用 初始化附带事件名、参数、事件接收者
- (instancetype _Nonnull )initWithName:(NSString *_Nonnull)name params:(NSDictionary *_Nullable)params receivers:(PlayerUIEventReceiver)receivers;

@end
