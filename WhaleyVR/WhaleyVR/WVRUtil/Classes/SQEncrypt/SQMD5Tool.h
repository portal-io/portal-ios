//
//  SQMD5Tool.h
//  youthGo
//
//  Created by qbshen on 16/5/23.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQMD5Tool : NSObject

/// 默认MD5后缀为 WHALEYVR_SNAILVR_AUTHENTICATION
+ (NSString *)encryptByMD5:(NSString *)str;

/**
 MD5加盐签名 md5Suffix为key 32位小写

 @param str 要加签名的string
 @param md5Suffix 盐（salt，key）
 @return sign string
 */
+ (NSString *)encryptByMD5:(NSString *)str md5Suffix:(NSString *)md5Suffix;

// 只签名参数值，key忽略
+ (NSString *)encryptByMD5ForValuesWithParams:(NSDictionary *)params md5Suffix:(NSString *)md5Suffix;

/// md5 16位加密 （大写）
+ (NSString *)md5:(NSString *)str;

@end
