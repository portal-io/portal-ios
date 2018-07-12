//
//  WVRPlayerUIEvent.m
//  WVRPlayerUI
//
//  Created by Bruce on 2017/9/19.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRPlayerUIEvent.h"

@implementation WVRPlayerUIEvent

/// 常规初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        _receivers = PlayerUIEventReceiverComponent;
    }
    return self;
}

/// 初始化附带事件名
- (instancetype _Nonnull )initWithName:(NSString *_Nonnull)name {
    
    self = [super init];
    if (self) {
        _name = name;
        _receivers = PlayerUIEventReceiverComponent;
    }
    return self;
}

/// 初始化附带事件名、参数
- (instancetype _Nonnull )initWithName:(NSString *_Nonnull)name params:(NSDictionary *_Nullable)params {
    
    self = [super init];
    if (self) {
        _name = name;
        _params = params;
        _receivers = PlayerUIEventReceiverComponent;
    }
    return self;
}

/// 组件中调用 初始化附带事件名、参数、事件接收者
- (instancetype _Nonnull )initWithName:(NSString *_Nonnull)name params:(NSDictionary *_Nullable)params receivers:(PlayerUIEventReceiver)receivers {
    
    self = [super init];
    if (self) {
        _name = name;
        _params = params;
        _receivers = receivers;
    }
    return self;
}

@end
