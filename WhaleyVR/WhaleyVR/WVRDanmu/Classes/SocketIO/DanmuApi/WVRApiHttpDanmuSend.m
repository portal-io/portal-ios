//
//  WVRApiHttpDanmu.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpDanmuSend.h"
#import "WVRNetworkingSnailvrService.h"
#import "NSDictionary+WVRNetworkingMethods.h"
#import "SQMD5Tool.h"
#import "WVRApiHttpDanmuSendReformer.h"
#import "WVRAPIHandle.h"

NSString * const kWVRAPIParamsDanmuSend_roomid = @"roomid";
NSString * const kWVRAPIParamsDanmuSend_message = @"message";

NSString * const kWVRAPIParamsDanmuSend_timestamp = @"timestamp";

@interface WVRApiHttpDanmuSend() <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpDanmuSend
#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager
- (NSString *)methodName
{
//    NSString * url = [NSString stringWithFormat:@"room/danmaku?%@",[self getParamsStr:self.bodyParams]];
    return @"room/danmaku";
}

- (NSString *)serviceType
{
    return NSStringFromClass([WVRNetworkingSnailvrService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypePostJSON;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSDictionary * dic = [self getParamsDic:params];
    return dic;
}

#pragma mark - WVRAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    id result = [self fetchDataWithReformer:[[WVRApiHttpDanmuSendReformer alloc] init]];
    self.successedBlock(result);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

- (NSDictionary *)getParamsDic:(NSDictionary *)paramsDic {
    NSMutableDictionary * curDic = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    curDic[kWVRAPIParamsDanmuSend_timestamp] = [NSString stringWithFormat:@"%ld", (long)time];
    
    
    NSDictionary *afterAppendParams = [WVRAPIHandle appendCommenParams:curDic];
    // 排列参数 生成sign
    NSArray* keys = [afterAppendParams allKeys];
    NSArray* newKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
    NSString * keyStr = @"";
    for (NSString * curKey in newKeys) {
        keyStr = [keyStr stringByAppendingString:curKey];
        keyStr = [keyStr stringByAppendingString:@"="];
        NSString * curValue = [afterAppendParams[curKey] stringByRemovingPercentEncoding];
        keyStr = [keyStr stringByAppendingString:curValue];
//        keyStr = [[keyStr stringByAppendingString:afterAppendParams[curKey]] stringByRemovingPercentEncoding];
        keyStr = [keyStr stringByAppendingString:@"&"];
    }
    keyStr = [keyStr substringToIndex:keyStr.length - 1];
    NSString *resultMD5Str = [SQMD5Tool encryptByMD5:keyStr md5Suffix:@"SHOW_SNAILVR_AUTHENTICATION"];

    NSMutableDictionary * resultDic = [NSMutableDictionary dictionaryWithDictionary:afterAppendParams];
    resultDic[@"sign"] = resultMD5Str;
//    NSString *params = @"";
//    for (NSString *curKey in newKeys) {
//        params = [params stringByAppendingString:curKey];
//        params = [params stringByAppendingString:@"="];
//        params = [params stringByAppendingString:afterAppendParams[curKey]];
//        params = [params stringByAppendingString:@"&"];
//    }
//    params = [params substringToIndex:params.length - 1];
//    NSString *finalParams = [NSString stringWithFormat:@"%@&sign=%@", params, resultMD5Str];
    
    return resultDic;
}


@end
