//
//  WVRApiHttpDanmu.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpGuestUserAuth.h"
#import "WVRNetworkingSnailvrService.h"
#import "NSDictionary+WVRNetworkingMethods.h"
#import "SQMD5Tool.h"
#import "WVRHttpGuestUserAuthReformer.h"
#import "WVRAPIHandle.h"

NSString * const kWVRHttpGuestUserAuth_device_id = @"device_id";

NSString * const kWVRHttpGuestUserAuth_model = @"model";
NSString * const kWVRHttpGuestUserAuth_timestamp = @"timestamp";


@interface WVRHttpGuestUserAuth() <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRHttpGuestUserAuth
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
    NSString * url = [NSString stringWithFormat:@"user/guest_auth?%@",[self getParamsStr:self.bodyParams]];
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
    id model = [self fetchDataWithReformer:[[WVRHttpGuestUserAuthReformer alloc] init]];
    self.successedBlock(model);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}


- (NSString *)getParamsStr:(NSDictionary *)paramsDic {
        NSMutableDictionary * curDic = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        time = round(time);
        curDic[kWVRHttpGuestUserAuth_timestamp] = [NSString stringWithFormat:@"%ld", (long)time];
    
    
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
