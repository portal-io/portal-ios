//
//  WVRLiveCarImageController.h
//  WhaleyVR
//
//  Created by Bruce on 2018/3/26.
//  Copyright © 2018年 Snailvr. All rights reserved.

// detailModel.type == @"live_car"，车展直播中

#import "WVRPlayerUIProtocol.h"

@interface WVRLiveCarImageController : NSObject <WVRPlayerUIProtocol>

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate;

@end
