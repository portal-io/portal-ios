//
//  WVRApiHttpDanmu.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpRoomLogin.h"
#import "WVRNetworkingSnailvrService.h"
#import "NSDictionary+WVRNetworkingMethods.h"
#import "SQMD5Tool.h"
#import "WVRHttpRoomLoginReformer.h"
#import "WVRAPIHandle.h"

NSString * const kWVRHttpRoomLogin_type = @"type";
NSString * const kWVRHttpRoomLogin_sid = @"sid";
NSString * const kWVRHttpRoomLogin_title = @"title";

NSString * const kWVRHttpRoomLogin_timestamp = @"timestamp";

@interface WVRHttpRoomLogin() <WVRAPIManagerCallBackDelegate>

@end


@implementation WVRHttpRoomLogin

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager
- (NSString *)methodName
{
    NSString * url = [NSString stringWithFormat:@"room/comein?%@",[self getParamsStr:self.bodyParams]];
//    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
//    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;= ";
//    
////    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
////    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
//    NSCharacterSet * cSet = [[NSCharacterSet characterSetWithCharactersInString:@" @#$%^&+=\\|[]{}:;\"] invertedSet];//@"] invertedSet];
//    NSString * encodingString = [url stringByAddingPercentEncodingWithAllowedCharacters:cSet];
    return url;
}

- (NSString *)serviceType
{
    return NSStringFromClass([WVRNetworkingSnailvrService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypeGet;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    
    return [NSDictionary new];
}

#pragma mark - WVRAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    id model = [self fetchDataWithReformer:[[WVRHttpRoomLoginReformer alloc] init]];
    self.successedBlock(model);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}


- (NSString *)getParamsStr:(NSDictionary *)paramsDic {
    NSMutableDictionary * curDic = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    curDic[kWVRHttpRoomLogin_timestamp] = [NSString stringWithFormat:@"%ld", (long)time];
    curDic[kWVRHttpRoomLogin_type] = @"video";
    
    NSDictionary *afterAppendParams = [WVRAPIHandle appendCommenParams:curDic];
//    afterAppendParams = @{@"appver":@"3.1.2_debug",@"domain":@"minisite-c.snailvr.com",
//                          @"systemname":@"iOS",
//                          @"device_id":@"0b9353361cb6445b8fd5742196fc453d",
//                          @"systemver":@"10.2.1",@"appvercode":@"449",
//                          @"appname":@"WhaleyVR",
//                          @"accesstoken":@"a50bZrwZ9hDK4bBeJe3LEfBz3OW7Dwa%2FDtmtTYllbipBRO8bX1txY%2FhFVlHv243kZ4KiKa0BQJbrblHEd8WXrBl%2FQZZaMfXmoy2ceYAR0WCAB7llKdhT%2FA",
//                          @"timestamp":@"1501315493387",};
    // 排列参数 生成sign
    NSArray* keys = [afterAppendParams allKeys];
    NSArray* newKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
    NSString * keyStr = @"";
    for (NSString * curKey in newKeys) {
        keyStr = [keyStr stringByAppendingString:curKey];
        keyStr = [keyStr stringByAppendingString:@"="];
        NSString * curValue = [afterAppendParams[curKey] stringByRemovingPercentEncoding];
        keyStr = [keyStr stringByAppendingString:curValue];
        keyStr = [keyStr stringByAppendingString:@"&"];
    }
    keyStr = [keyStr substringToIndex:keyStr.length - 1];
    NSString *resultMD5Str = [SQMD5Tool encryptByMD5:keyStr md5Suffix:@"SHOW_SNAILVR_AUTHENTICATION"];
    
    NSString *params = @"";
    for (NSString *curKey in newKeys) {
        params = [params stringByAppendingString:curKey];
        params = [params stringByAppendingString:@"="];
        params = [params stringByAppendingString:afterAppendParams[curKey]];
        params = [params stringByAppendingString:@"&"];
    }
    params = [params substringToIndex:params.length - 1];
    NSString *finalParams = [NSString stringWithFormat:@"%@&sign=%@", params, resultMD5Str];
    
    return finalParams;
}

@end
