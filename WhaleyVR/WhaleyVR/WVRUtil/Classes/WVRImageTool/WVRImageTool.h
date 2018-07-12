//
//  WVRImageTool.h
//  WhaleyVR
//
//  Created by qbshen on 2016/11/23.
//  Copyright © 2016年 Snailvr. All rights reserved.

// WVRProgram

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WVRImageTool : NSObject

+ (NSString *)parseImageUrl:(NSString *)originUrl scaleSize:(CGSize)size;
+ (NSString *)parseImageUrl:(NSString *)originUrl scale:(CGFloat)scale;
+ (NSString *)parseImageUrlFitScreen:(NSString *)originUrl;

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
