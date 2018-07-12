//
//  WVRUIEngine.m
//  VRManager
//
//  Created by Snailvr on 16/7/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRUIEngine.h"
#import "WVRAppContextHeader.h"
#import "UIColor+Extend.h"

@implementation WVRUIEngine

+ (UIImage *)videoDetailNavImage {
    
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    
    //绘制渐变
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    
    CGFloat locations[] = {0.0, 0.99, 1.0};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 3);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, 64), 0);
    
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(colorSpace);
    
    //从Context中获取图像
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)bannerTitleImage {
    
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    
    //绘制渐变
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0};
    
    CGFloat locations[] = {0.0, 1.0};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, 30), 0);
    
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(colorSpace);
    
    //从Context中获取图像
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (NSAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:6.0];        // 调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [string length])];
    
    return attributedString;
}

// 详情页的描述
+ (NSAttributedString *)descStringWithString:(NSString *)string {
    
    if (string.length < 4) {    // 没有简介就不显示
        return nil;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedString addAttribute:NSForegroundColorAttributeName   //文字颜色
                             value:[UIColor blackColor]
                             range:NSMakeRange(0, 3)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName   //文字颜色
                             value:[UIColor colorWithHex:0x898989]
                             range:NSMakeRange(3, string.length - 3)];
    
    [attributedString addAttribute:NSFontAttributeName              //文字字体
                             value:[WVRAppModel fontFitForSize:13]
                             range:NSMakeRange(0, string.length)];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];  // 行间距
    paragraphStyle.lineSpacing = 6.0;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    
    return attributedString;
}


@end
