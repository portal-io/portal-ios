//
//  WVRGlobalUtil.m
//  TvBuy
//
//  Created by qianhe on 14/6/25.
//  Copyright (c) 2014年 Beijing CHSY E-Business Co., Ltd. All rights reserved.
//

#import "WVRGlobalUtil.h"
#import <UIKit/UIKit.h>

#define kShowHudDelayed 0.5

@implementation WVRGlobalUtil

#pragma mark - 正则匹配手机号

+ (BOOL)validateMobileNumber:(NSString *)string
{
    static NSString *tempStr = @"^((\\+86)?|\\(\\+86\\))0?1[34578]\\d{9}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc] initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    
    return numberofMatch > 0;
}

+ (BOOL)validatePostCodeNumber:(NSString *)string
{
    static NSString *tempStr = @"^[1-9]\\d{5}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc] initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    
    return numberofMatch > 0;
}

+ (BOOL)validatePassword:(NSString *)string
{
    static NSString *tempStr = @"^(?![_]+$)(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z_]{6,20}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc] initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    
    return numberofMatch > 0;
}

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg
{
//    if ([msg isEqualToString:@"接口调用失败，请联系技术人员"]) {
//    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (BOOL)isEmpty:(NSString*)str
{
    if ([str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if (str == nil || [str length] == 0) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)md5HexDigest:(NSString *)input {
    
    const char *cStr = [input UTF8String];      //转换成utf-8
    unsigned char result[16];                   //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (int)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

+ (NSString *)getRandomNumber32
{
    NSString *numberStr = [[NSString alloc] init];
    for (int i = 0; i < 32; i++)
    {
        NSString *number = [NSString stringWithFormat:@"%d", arc4random() % 10];
        numberStr = [numberStr stringByAppendingString:number];
    }
    return numberStr;
}

+ (NSString *)getTimeStr
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time =[dat timeIntervalSince1970]*1000;
    long timeLong;
    timeLong = (long)time;
    return [NSString stringWithFormat:@"%ld", timeLong];
}

+ (NSString *)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}

+ (NSString *)urlencode:(NSString*)str {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


@end
