//
//  WVRApiHttpReward.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpReward.h"
#import "WVRNetworkingVRAPIService.h"
#import "SQMD5Tool.h"

NSString * const kHttpParams_rewardList_whaleyuid = @"whaleyuid";

static NSString *kActionUrl = @"user/myprize";

@implementation WVRApiHttpReward
#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return [NSString stringWithFormat:@"%@?%@",kActionUrl,[self getParamsStr:self.bodyParams]];
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingVRAPIService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypeGet;
}

-(NSDictionary *)reformParams:(NSDictionary *)params
{
    self.bodyParams = params;
    return @{};
}

- (NSString *)getParamsStr:(NSDictionary *)paramsDic {
    
    NSMutableDictionary * curDic = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    curDic[@"timestamp"] = [NSString stringWithFormat:@"%ld", (long)time];
    
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
    NSString *resultMD5Str = [SQMD5Tool encryptByMD5:keyStr md5Suffix:@"WHALEYVR_SNAILVR_AUTHENTICATION"];
    
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
