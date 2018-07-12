//
//  WVRLotteryModel.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/13.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLotteryModel.h"
#import "WVRWhaleyHTTPManager.h"
#import "SQMD5Tool.h"
#import "WVRAPIHandle.h"

@implementation WVRLotteryModel

+ (void)requestLotterySwitchForSid:(NSString *)sid block:(APIResponseBlock)block {
    
    NSAssert(nil != sid, @"sid can't be nil");
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = sid;
    
    NSString *service = [NSString stringWithFormat:@"%@live/getLiveConfigByCode", kAPI_SERVICE];
    [WVRWhaleyHTTPManager GETService:service withParams:dict completionBlock:^(id responseObj, NSError *error) {
        
        // error 则不回调
        if ([responseObj[@"code"] intValue] == 200) {
            block(responseObj[@"data"], nil);
        }
    }];
}

static NSDate *kAuthTime = nil;

// 用户登录授权
+ (void)requestForAuthLottery:(APIResponseBlock)block {
    
    if (kAuthTime) {
        NSTimeInterval time = [kAuthTime timeIntervalSinceNow];
        time = abs((int)time);
        if (time < 300) {           // 上次认证在5分钟内 不再做认证
            
            if (block) {
                block(@{ @"status":@(1) }, nil);
            }
            return;
        }
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"accesstoken"] = [WVRUserModel sharedInstance].sessionId;
    dict[@"device_id"] = [WVRUserModel sharedInstance].deviceId;
    dict[@"timestamp"] = [NSString stringWithFormat:@"%ld", (long)time];
    NSDictionary *params = [WVRAPIHandle appendCommenParams:dict];
    
    NSString *finalParams = [self getParamStr:params];
    NSString *url = [NSString stringWithFormat:@"user/auth?%@", finalParams];
    
    [WVRSnailvrHTTPManager GETService:url withParams:nil completionBlock:^(id responseObj, NSError *error) {
        if (error) {
            if (block) {
                block(nil, error);
            }
        } else {
            
            if ([responseObj[@"status"] intValue] == 1) {
                kAuthTime = [NSDate date];
            }
            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            
            //存储归档后的cookie
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject: cookiesData forKey:@"cookie"];
            
            [self deleteCookie];
            [self setCoookie];
            
            if (block) {
                block(responseObj, nil);
            }
        }
    }];
}

// 用户进行抽奖
+ (void)requestForLotteryWithSid:(NSString *)sid block:(APIResponseBlock)block {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sortid"] = sid;
    dict[@"whaleyuid"] = [WVRUserModel sharedInstance].accountId;
    dict[@"timestamp"] = [NSString stringWithFormat:@"%ld", (long)time];
    dict[@"action"] = @"baoxiang";
    NSDictionary *params = [WVRAPIHandle appendCommenParams:dict];
    
    NSString *finalParams = [self getParamStr:params];
    NSString *url = [NSString stringWithFormat:@"lottery/start?%@", finalParams];
    
    [WVRSnailvrHTTPManager GETService:url withParams:nil completionBlock:^(id responseObj, NSError *error) {
        
        if (error) {
            block(nil, error);
        } else {
            block(responseObj, nil);
        }
    }];
}

// 获取时间间隔或时间段
+ (void)requestForBoxCountdownForSid:(NSString *)sid block:(APIResponseBlock)block {
    
    NSAssert(nil != sid, @"sid can't be nil");
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString stringWithFormat:@"%ld", (long)time];
    dict[@"sortid"] = sid;
    dict[@"action"] = @"baoxiang";
    NSDictionary *params = [WVRAPIHandle appendCommenParams:dict];
    
    NSString *finalParams = [self getParamStr:params];
    NSString *url = [NSString stringWithFormat:@"lottery/time?%@", finalParams];
    
    [WVRSnailvrHTTPManager GETService:url withParams:nil completionBlock:^(id responseObj, NSError *error) {
        
        if (error) {
            block(nil, error);
        } else {
            block(responseObj, nil);
        }
    }];
}

// 我的中奖列表
+ (void)requestForLotteryList:(APIResponseBlock)block {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString stringWithFormat:@"%ld", (long)time];
    dict[@"whaleyuid"] = [WVRUserModel sharedInstance].accountId;
    NSDictionary *params = [WVRAPIHandle appendCommenParams:dict];
    
    NSString *finalParams = [self getParamStr:params];
    NSString *url = [NSString stringWithFormat:@"user/myprize?%@", finalParams];
    
    [WVRSnailvrHTTPManager GETService:url withParams:nil completionBlock:^(id responseObj, NSError *error) {
        
        if (error) {
            block(nil, error);
        } else {
            block(responseObj, nil);
        }
    }];
}

// 查询我的收货地址信息
+ (void)requestForGoodsAddress:(APIResponseBlock)block {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString stringWithFormat:@"%ld", (long)time];
    dict[@"whaleyuid"] = [WVRUserModel sharedInstance].accountId;
    NSDictionary *params = [WVRAPIHandle appendCommenParams:dict];
    
    NSString *finalParams = [self getParamStr:params];
    NSString *url = [NSString stringWithFormat:@"user/address?%@", finalParams];
    
    [WVRSnailvrHTTPManager GETService:url withParams:nil completionBlock:^(id responseObj, NSError *error) {
        
        if (error) {
            block(nil, error);
        } else {
            block(responseObj, nil);
        }
    }];
}

// 修改我的收货地址信息
+ (void)requestForChageGoodsAddressWithName:(NSString *)name mobile:(NSString *)mobile province:(NSString *)province city:(NSString *)city county:(NSString *)county address:(NSString *)address block:(APIResponseBlock)block {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString stringWithFormat:@"%ld", (long)time];
    dict[@"whaleyuid"] = [WVRUserModel sharedInstance].accountId;
    NSDictionary *params = [WVRAPIHandle appendCommenParams:dict];
    
    NSString *finalParams = [self getParamStr:params];
    NSString *url = [NSString stringWithFormat:@"user/address?%@", finalParams];
    
    [WVRSnailvrHTTPManager GETService:url withParams:nil completionBlock:^(id responseObj, NSError *error) {
        
        if (error) {
            block(nil, error);
        } else {
            block(responseObj, nil);
        }
    }];
}

#pragma mark - 私有方法

+ (NSString *)getParamStr:(NSDictionary *)dict {
    
    // 排列参数 生成sign
    NSArray* keys = [dict allKeys];
    NSArray* newKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
    NSString * keyStr = @"";
    for (NSString * curKey in newKeys) {
        keyStr = [keyStr stringByAppendingString:curKey];
        keyStr = [keyStr stringByAppendingString:@"="];
        NSString * curValue = [dict[curKey] stringByRemovingPercentEncoding];
        keyStr = [keyStr stringByAppendingString:curValue];
//        keyStr = [[keyStr stringByAppendingString:dict[curKey]] stringByRemovingPercentEncoding];
        keyStr = [keyStr stringByAppendingString:@"&"];
    }
    keyStr = [keyStr substringToIndex:keyStr.length - 1];
    NSString *resultMD5Str = [SQMD5Tool encryptByMD5:keyStr];
    
    NSString * params = @"";
    for (NSString * curKey in newKeys) {
        params = [params stringByAppendingString:curKey];
        params = [params stringByAppendingString:@"="];
        params = [params stringByAppendingString:dict[curKey]];
        params = [params stringByAppendingString:@"&"];
    }
    params = [params substringToIndex:params.length - 1];
    NSString *finalParams = [NSString stringWithFormat:@"%@&sign=%@", params, resultMD5Str];
    
    return finalParams;
}

#pragma mark 删除cookie

+ (void)deleteCookie {
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    //删除cookie
    for (NSHTTPCookie *tempCookie in cookies) {
        
        [cookieStorage deleteCookie:tempCookie];
    }
}

#pragma mark - 再取出保存的cookie重新设置cookie

+ (void)setCoookie {
    
    //取出保存的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"cookie"]];
    
    if (cookies) {
        
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }
}

@end
