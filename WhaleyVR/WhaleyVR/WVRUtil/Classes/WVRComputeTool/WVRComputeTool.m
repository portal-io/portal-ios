//
//  WVRComputeTool.m
//  VRManager
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 用于辅助计算的类

#import "WVRComputeTool.h"

@implementation WVRComputeTool

+ (NSString *)numberToString:(long)num {
    
    NSString *str = nil;
    if (num >= 1000000) {   // 大于一百万 取整
        
        if (num >= 100000000) {         // 亿
            if (num >= 1000000000) {        // 十亿
                str = [NSString stringWithFormat:@"%ld亿", (long )num/100000000];
            } else {
                long tmpNum = num/10000000;
                if (tmpNum % 10 == 0) {
                    str = [NSString stringWithFormat:@"%ld亿", tmpNum/10];
                } else {
                    str = [NSString stringWithFormat:@"%.1f亿", tmpNum/10.f];
                }
            }
        } else {
            str = [NSString stringWithFormat:@"%ld万", (long)num/10000];
        }
        
    } else if (num >= 10000) {      // 大于一万 精确到千位
        
        long tmpNum = num/1000;
        if (tmpNum % 10 == 0) {
            str = [NSString stringWithFormat:@"%ld万", (long)tmpNum/10];
        } else {
            str = [NSString stringWithFormat:@"%.1f万", tmpNum/10.f];
        }
    } else {
        str = [NSString stringWithFormat:@"%ld", (long)num];
    }
    
    return str;
}

+ (NSString *)timeLeftNow:(NSTimeInterval)time {
    
    // 将毫秒时间戳转化为秒
    if (time > 14900948920) { time = time / 1000; }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    long left = now - time;
    
    if (left < 60) {
        return @"刚刚";
    } else if (left < 3600) {
        return [NSString stringWithFormat:@"%ld分钟前", left / 60];
    } else if (left < 86400) {
        return [NSString stringWithFormat:@"%ld小时前", left / 3600];
    } else {
        return [NSString stringWithFormat:@"%ld天前", left / 86400];
    }
//    else if (left < 2592000) {
//        return [NSString stringWithFormat:@"%ld天前", left / 86400];
//    }
//    else if (left < 31536000) {
//        return [NSString stringWithFormat:@"%ld个月前", left / 2592000];
//    } else {
//        return [NSString stringWithFormat:@"%ld年前", left / 31536000];
//    }
    return @"";
}

// 秒为单位转换为分秒
+ (NSString *)numToTime:(long)num {
    
    long minute = num / 60;
    long second = num % 60;
    
    if (minute > 0) {
        if (second > 0) {
            return [NSString stringWithFormat:@"%ld分钟%ld秒", minute, second];
        } else {
            return [NSString stringWithFormat:@"%ld分钟", minute];
        }
    } else {
        return [NSString stringWithFormat:@"%ld秒", second];
    }
}

// 分为单位转换为元
+ (NSString *)numToPrice:(long)num {
    
    NSString *number = [WVRComputeTool numToPriceNumber:num];
    
    return [number stringByAppendingString:@"元"];
}

+ (NSString *)numToPriceNumber:(long)num {
    
    if (num % 100 == 0) {
        return [NSString stringWithFormat:@"%ld", num / 100];
    } else if (num % 10 == 0) {
        return [NSString stringWithFormat:@"%.1f", num / 100.f];
    } else {
        return [NSString stringWithFormat:@"%.2f", num / 100.f];
    }
}

+ (NSString *)durationToString:(long)duration {
    
    long min = duration / 60;
    long sec = duration % 60;
    
    NSString *str = [NSString stringWithFormat:@"%ld分%ld秒", min, sec];
    
    return str;
}

// 计算字符串的size
+ (CGSize)sizeOfString:(NSString *)string Size:(CGSize)size Font:(UIFont *)font {
    
    CGSize stringSize = [string boundingRectWithSize:size
                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:@{ NSFontAttributeName: font }
                                             context:nil].size;
    
    float width = ceilf(stringSize.width);
    float height = ceilf(stringSize.height);
    return CGSizeMake(width, height);
}

// 计算属性字符串的size
+ (CGSize)sizeOfString:(NSAttributedString *)attributedString Size:(CGSize)size {
    
    CGRect rect = [attributedString boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    float width = ceilf(rect.size.width);
    float height = ceilf(rect.size.height);
    return CGSizeMake(width, height);
}


@end
