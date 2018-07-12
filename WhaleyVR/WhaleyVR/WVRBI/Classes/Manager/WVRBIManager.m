//
//  WVRBIManager.m
//  WhaleyVR
//
//  Created by Bruce on 2017/7/19.
//  Copyright © 2017年 Snailvr. All rights reserved.

// BI模块，需要依赖（本地存储）

#import "WVRBIManager.h"
#import "WVRBIModel.h"
#import "WVRSQLiteManager.h"
#import <WVRAppConst.h>
#import <WVRAppModel.h>
#import <WVRUserModel.h>
#import <NSArray+Extend.h>
#import <NSString+Extend.h>
#import <NSDictionary+Extension.h>
#import <WVRAppDebugDefine.h>
#import <CommonCrypto/CommonDigest.h>

#define BI_MD5_KEY @"eOfNyUQr1mBSb3ijDYh3GqVSq5lJZVeKJX81Us8ZyQcFPpDWOOK6Uu5WinKgHNJv"

@implementation WVRBIManager

//+ (void)saveModelToLocal:(WVRBIModel *)model {
//    
//    [model saveToSQLite];
//}

+ (void)uploadBIEvents {
    
    BOOL isTest = NO;
#if (kAppEnvironmentTest == 1)
    // 测试环境下，BI开关可控，关掉则不上传BI日志
    if (![WVRUserModel sharedInstance].isBIOpen) {
        DDLogInfo(@"当前为测试App，BI开关未打开");
        return;
    }
    isTest = YES;
#endif
    
    [WVRBIManager uploadBIEventWithTest:isTest];
}

static BOOL wvr_BI_isUploadEvents = NO;

+ (void)uploadBIEventWithTest:(BOOL)isTest {
    
    DDLogInfo(@"BI_upload: is %@ test", isTest ? @"" : @"not");
    
    if (wvr_BI_isUploadEvents) { return; }
    
    wvr_BI_isUploadEvents = YES;
    
    NSArray *tmpArray = [[WVRSQLiteManager sharedManager] contentsInBIEvents];
    if (tmpArray.count < 1) {
        wvr_BI_isUploadEvents = NO;
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in tmpArray) {
        
        // 带一条条斜杠
        NSDictionary *dict = [str stringToDic];
        [array addObject:dict];
        
//        [array addObject:str];      // 带三条斜杠
    }
    
    NSString *logs = [array toJsonString];
    
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
    NSString *salt = BI_MD5_KEY;
    NSString *md5 = [self encryptByMD5:[NSString stringWithFormat:@"%@%@", logs, ts] md5Suffix:salt];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"logs"] = array; // fixbug，传到BI数据库的数据中不要带转译符
    dict[@"ts"] = ts;
    dict[@"md5"] = md5;
    dict[@"checkVersion"] = @"2";
    
    NSString *url = [WVRUserModel biBaseURLForTest:isTest];
    [[self class] POST:url withParams:dict completionBlock:^(id responseObj, NSError *error) {
        
        if (error) {
            DDLogError(@"BI_Error: %@", error.domain);
        } else {
            DDLogInfo(@"BI_Success: %@", responseObj);
            [[WVRSQLiteManager sharedManager] removeBIEventBelowId:0];
        }
        wvr_BI_isUploadEvents = NO;
    }];
}

// 上传BI专用请求
+ (void)POST:(NSString *)URLStr withParams:(id)params completionBlock:(APIResponseBlock)block {
    
    NSURL *url = [NSURL URLWithString:URLStr];
    
    DDLogInfo(@"\n-------切割线-------\nURLString = %@\n-------切割线-------\n", URLStr);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if ([URLStr isEqualToString:[WVRUserModel biBaseURLForTest:YES]]) {
        [request setValue:@"vrlog.aginomoto.com" forHTTPHeaderField:@"forwardhost"];
    }
    
    if ([params isKindOfClass:[NSDictionary class]]) {
        
        if (((NSDictionary *)params).count > 0) {
            
            NSString *json = [(NSDictionary *)params toJsonString]; //[ stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
            
            NSData *postData = [json dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:postData];
        }
    } else if ([params isMemberOfClass:[NSString class]]) {
        
        NSData *postData = [(NSString *)params dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
        
    } else if ([params isMemberOfClass:[NSData class]]) {
        
        [request setHTTPBody:params];
    } else {
        DDLogError(@"BI upload error: bad params");
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            block(nil, error);
        } else {
            //            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *tmp = [str componentsSeparatedByString:@","];
            NSString *code = [tmp firstObject];
            
            if ([code containsString:@"200"]) {
                block(@{ @"status code" : @"200" }, nil);
            } else {
                if (![code isMemberOfClass:[NSString class]]) { code = @""; }
                NSError *err = [NSError errorWithDomain:code code:500 userInfo:nil];
                block(nil, err);
            }
        }
    }];
    
    [sessionDataTask resume];
}

#pragma mark - private

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

@end

