//
//  WVRGlobalUtil.h
//  TvBuy
//
//  Created by qianhe on 14/6/25.
//  Copyright (c) 2014年 Beijing CHSY E-Business Co., Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import<CommonCrypto/CommonDigest.h> 

@interface WVRGlobalUtil : NSObject

#pragma mark 正则匹配手机号
+ (BOOL)validateMobileNumber:(NSString *)string;

#pragma mark 正则匹配邮政编码
+ (BOOL)validatePostCodeNumber:(NSString *)string;

#pragma mark 正则匹配——禁止输入中文且是6-16位之间非空格的任意字符
+ (BOOL)validatePassword:(NSString *)string;

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg;

+ (BOOL)isEmpty:(NSString*)str;

+ (NSString *)md5HexDigest:(NSString*)input;

+ (NSString *)getRandomNumber32;

+ (NSString *)getTimeStr;

+ (NSString *)getAppVersion;

+ (NSString *)urlencode:(NSString*)str;

@end
