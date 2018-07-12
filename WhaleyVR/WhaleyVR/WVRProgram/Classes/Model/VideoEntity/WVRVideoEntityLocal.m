//
//  WVRVideoEntityLocal.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRVideoEntityLocal.h"

@implementation WVRVideoEntityLocal

- (instancetype)init {
    self = [super init];
    if (self) {
        // MARK: - 目前只有全景视频支持下载
        self.streamType = STREAM_VR_LOCAL;
    }
    return self;
}

@end
