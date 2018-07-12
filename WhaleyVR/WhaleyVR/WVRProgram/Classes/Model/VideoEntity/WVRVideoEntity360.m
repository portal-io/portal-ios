//
//  WVRVideoEntity360.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 普通全景视频VideoEntity

#import "WVRVideoEntity360.h"

@implementation WVRVideoEntity360

- (instancetype)init {
    self = [super init];
    if (self) {
        self.streamType = STREAM_VR_VOD;
    }
    return self;
}

@end
