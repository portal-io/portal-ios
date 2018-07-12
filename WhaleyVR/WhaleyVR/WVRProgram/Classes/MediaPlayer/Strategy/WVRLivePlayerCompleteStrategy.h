//
//  WVRLivePlayerCompleteStrategy.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WVRLivePlayerStrategyConfig;

@interface WVRLivePlayerCompleteStrategy : NSObject

- (instancetype)initWithConfig:(WVRLivePlayerStrategyConfig *)config completeBlock:(void(^)(void))completeBlock restartBlock:(void(^)(void(^successRestartBlock)(void)))restartBlock overLimitBlock:(void(^)(void))overLimitBlock;

- (void)http_liveStatus;

- (void)resetStatus;

@end
