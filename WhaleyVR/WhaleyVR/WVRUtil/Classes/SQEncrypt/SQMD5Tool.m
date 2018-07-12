//
//  SQMD5Tool.m
//  youthGo
//
//  Created by qbshen on 16/5/23.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "SQMD5Tool.h"
#import <CommonCrypto/CommonDigest.h>

// 秀场  密钥就是  SHOW_SNAILVR_AUTHENTICATION
// APP的就是 WHALEYVR_SNAILVR_AUTHENTICATION

#define APP_MD5_SUFFIX (@"WHALEYVR_SNAILVR_AUTHENTICATION")

@implementation SQMD5Tool

// 默认MD5后缀为 WHALEYVR_SNAILVR_AUTHENTICATION
+ (NSString *)encryptByMD5:(NSString *)str
{
    return [self encryptByMD5:str md5Suffix:APP_MD5_SUFFIX];
}

+ (NSString *)encryptByMD5ForValuesWithParams:(NSDictionary *)params md5Suffix:(NSString *)md5Suffix
{
    // 排列参数 生成sign
    NSArray* keys = [params allKeys];
    NSArray* newKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
    NSString * keyStr = @"";
    for (NSString * curKey in newKeys) {
        NSString * curValue = [params[curKey] stringByRemovingPercentEncoding];
        keyStr = [keyStr stringByAppendingString:curValue];
        //        keyStr = [[keyStr stringByAppendingString:afterAppendParams[curKey]] stringByRemovingPercentEncoding];
    }
    NSString *resultMD5Str = [SQMD5Tool encryptByMD5:keyStr md5Suffix:md5Suffix];
    return resultMD5Str;
}

// MD5加盐签名 md5Suffix为key 32位小写
+ (NSString *)encryptByMD5:(NSString *)str md5Suffix:(NSString *)md5Suffix {
    
    NSString * srcStr = [str stringByAppendingString:md5Suffix];
    const char *cStr = [srcStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSString *hexStr = @"";
    for (int i = 0; i < 16; i ++)
    {
//        NSString *newHexStr = [NSString stringWithFormat:@"%x",(result[i]&0xff)|0x100]; // 16进制数
        NSString *newHexStr = [NSString stringWithFormat:@"%02x", (result[i])]; // 16进制数
        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
        }
    }
    return hexStr;
}

//+ (NSString *)encryptByMD5_v2:(NSString *)str
//{
//    CC_MD5_CTX md5;
//    
//    CC_MD5_Init(&md5);
//    
//    NSString * srcStr = [str stringByAppendingString:APP_MD5_SUFFIX];
//    NSData * strData = [srcStr dataUsingEncoding:NSUTF8StringEncoding];
//    Byte *bytes = (Byte *)[strData bytes];
//    CC_MD5_Update(&md5, bytes, (CC_LONG)[strData length]);
//    
//    NSString *hexStr = @"";
//    for (int i=0; i<[strData length]; i++)
//    {
//        NSString *newHexStr = [NSString stringWithFormat:@"%x",(bytes[i]&0xff)|0x100]; ///16进制数
//        if([newHexStr length]==1)
//            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
//        else
//            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
//    }
//    return hexStr;
//}

//+ (NSString *)md5:(NSString *)str {
//    
//    const char *cStr = [str UTF8String];
//    
//    unsigned char result[32];
//    
//    CC_MD5( cStr, @"_youthGo", result );
//    
//    return [NSString stringWithFormat:
//            @"xxxxxxxxxxxxxxxx",
//            
//            result[0],result[1],result[2],result[3],
//            
//            result[4],result[5],result[6],result[7],
//            
//            result[8],result[9],result[10],result[11],
//            
//            result[12],result[13],result[14],result[15],
//            
//            result[16], result[17],result[18], result[19],
//            
//            result[20], result[21],result[22], result[23],
//            
//            result[24], result[25],result[26], result[27],
//            
//            result[28], result[29],result[30], result[31]];
//}

/// md5 16位加密 （大写）

+ (NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            ];
}

@end
