//
//  WVRWebSocketPrepare.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRWebSocketStatusDelegate.h"

@class WVRWebSocketConfig;

@interface WVRWebSocketPrepare : NSObject

@property (nonatomic, weak) id<WVRWebSocketStatusDelegate> delegate;

-(void)defaultAuth:(WVRWebSocketConfig*)config;
@end
