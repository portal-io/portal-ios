//
//  WVRImageTool.m
//  WhaleyVR
//
//  Created by qbshen on 2016/11/23.
//  Copyright © 2016年 Snailvr. All rights reserved.

// WVRProgram

#import "WVRImageTool.h"
#import <Accelerate/Accelerate.h>

@implementation WVRImageTool

+ (NSString *)parseImageUrl:(NSString *)originUrl scaleSize:(CGSize)size
{
    return originUrl;
//    if (![originUrl containsString:@"zoom"]) {
//        return originUrl;
//    }
//    NSArray* array = [originUrl componentsSeparatedByString:@"zoom"];
//    NSString * result = [array firstObject];
//    result = [result stringByAppendingFormat:@"zoom/%d/%d",(int)size.width*(int)[UIScreen mainScreen].scale,(int)size.height*(int)[UIScreen mainScreen].scale];
//    return result;
}

+ (NSString *)parseImageUrl:(NSString *)originUrl scale:(CGFloat)scale
{
    if (![originUrl containsString:@"zoom"]) {
        return originUrl;
    }
    NSArray* array = [originUrl componentsSeparatedByString:@"zoom"];
    NSString * result = [array firstObject];
    NSString * sizeStr = [array lastObject];
    NSArray * sizeArray = [sizeStr componentsSeparatedByString:@"/"];
    if (sizeArray.count<3) {
        return originUrl;
    }
    CGFloat width = [sizeArray[1] floatValue];
    CGFloat height = [[sizeArray lastObject] floatValue];
    result = [result stringByAppendingFormat:@"zoom/%d/%d", (int)(width/scale), (int)(height/scale)];
    
    return result;
}

#define SCREEN_WIDTH			CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT           CGRectGetHeight([[UIScreen mainScreen] bounds])

+ (NSString *)parseImageUrlFitScreen:(NSString *)originUrl
{
    if (![originUrl containsString:@"zoom"]) {
        return originUrl;
    }
    NSArray* array = [originUrl componentsSeparatedByString:@"zoom"];
    NSString * result = [array firstObject];
    NSString * sizeStr = [array lastObject];
    NSArray * sizeArray = [sizeStr componentsSeparatedByString:@"/"];
    if (sizeArray.count < 3) {
        return originUrl;
    }
    result = [result stringByAppendingFormat:@"zoom/%d/%d", (int)(SCREEN_WIDTH), (int)(SCREEN_HEIGHT)];
    
    return result;
}

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

@end
