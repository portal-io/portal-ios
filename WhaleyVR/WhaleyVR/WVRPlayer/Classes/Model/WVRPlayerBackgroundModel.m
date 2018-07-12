//
//  WVRPlayerBackgroundModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/17.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 存储播放器中背景图和底图的信息

#import "WVRPlayerBackgroundModel.h"
#import "UIImage+Extend.h"

@implementation WVRPlayerBackgroundModel
@synthesize clearImage = _tmpClearImage;

- (UIImage *)clearImage {
    if (!_tmpClearImage) {
        _tmpClearImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
    }
    return _tmpClearImage;
}

@end
