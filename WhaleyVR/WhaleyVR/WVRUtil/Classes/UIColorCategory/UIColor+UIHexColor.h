//
//  UIColor+UIHexColor.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIHexColor)
/***
 ** 将hex解析为颜色
 **/
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/***
 ** 实现颜色反解析
 **/
+ (NSString *)changeUIColorToRGB:(UIColor *)color;

/***
 ** 通过名称设置颜色
 **/
+ (UIColor *)colorNameToUIColor:(NSString *)name;

@end
