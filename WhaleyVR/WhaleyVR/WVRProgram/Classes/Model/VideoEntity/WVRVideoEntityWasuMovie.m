//
//  WVRVideoEntityWasuMovie.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 华数电影VideoEntity

#import "WVRVideoEntityWasuMovie.h"

@implementation WVRVideoEntityWasuMovie

- (instancetype)init {
    self = [super init];
    if (self) {
        self.streamType = STREAM_3D_WASU;
    }
    return self;
}

@end
