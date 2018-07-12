//
//  WVRComputeTool.h
//  VRManager
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 用于辅助计算的类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WVRComputeTool : NSObject

/// 把次数大于10000的情况转换为xx万
+ (NSString *)numberToString:(long)num;

/// 把时间转换为文字描述 未完成
+ (NSString *)timeLeftNow:(NSTimeInterval)time;

/// 秒为单位转换为分秒
+ (NSString *)numToTime:(long)num;

/// 分为单位转换为元
+ (NSString *)numToPrice:(long)num;

/// 分为单位转换为元，返回为数字（String类型）
+ (NSString *)numToPriceNumber:(long)num;

///duration转换为x分x秒
+ (NSString *)durationToString:(long)duration;

/// 计算字符串的size
+ (CGSize)sizeOfString:(NSString *)string Size:(CGSize)size Font:(UIFont *)font;

/// 计算属性字符串的size
+ (CGSize)sizeOfString:(NSAttributedString *)attributedString Size:(CGSize)size;

@end
