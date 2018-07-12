//
//  SQToastTool.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQToastTool : NSObject

/// 显示Toast到父视图靠上的部分
+ (void)showMessageTop:(UIView *)parentView withMessage:(NSString *)msg;

/// 显示Toast到父视图靠下的部分
+ (void)showMessage:(UIView *)parentView withMessage:(NSString *)msg;

/// 显示Toast到父视图居中的部分
+ (void)showMessageCenter:(UIView *)parentView withMessage:(NSString *)msg;

// for 宏定义
/// 显示Toast到主Window靠下的部分
+ (void)showMessageToWindow:(NSString *)msg;

/// 显示Toast到主Window居中的部分
+ (void)showMessageToWindowCenter:(NSString *)msg;

// 乐蜗后台 错误码提示
+ (void)showErrorMessageForSnailVRAPI:(int)code;

+ (void)showToastWithMsg:(NSString*)msg parenetView:(UIView *)parentView yScale:(CGFloat)yScale;

+(void)showToastWithMsg:(NSString *)msg inKeyWindowWithyScale:(CGFloat)yScale;
+(void)showToastWithMsg:(NSString*)msg parenetView:(UIView*)parentView yBottom:(CGFloat)yBottom;

@end
