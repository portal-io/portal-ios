//
//  WVRShowFieldModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/2/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRShowFieldModel.h"
#import "WVRSnailvrHTTPManager.h"
#import "SQMD5Tool.h"
#import "WVRAPIHandle.h"

@implementation WVRShowFieldModel

// 秀场  密钥就是  SHOW_SNAILVR_AUTHENTICATION
// APP的就是 WHALEYVR_SNAILVR_AUTHENTICATION

+ (void)requestForShowFieldBannerList:(APIResponseBlock)block {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString stringWithFormat:@"%ld", (long)time];
    dict[@"posid"] = @"1";
    dict[@"limit"] = @"10";
    
    NSDictionary *params = [WVRAPIHandle appendCommenParams:dict];
    
    NSString *finalParams = [self getParamStr:params];
    NSString *banner_base_url = @"";
    
    if ([WVRUserModel sharedInstance].isTest) {
        banner_base_url = @"http://showapi-test.snailvr.com/room/recommend";
    } else {
        banner_base_url = @"http://showapi.snailvr.com/room/recommend";
    }
    NSString *url = [NSString stringWithFormat:@"%@?%@", banner_base_url, finalParams];
    
    [WVRSnailvrHTTPManager GETService:url withParams:nil completionBlock:^(id responseObj, NSError *error) {
        
        if (!responseObj) {
            block(nil, error);
        } else {
            NSDictionary *dict = responseObj;
            NSArray *arr = dict[@"recommendrooms"];
            
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                WVRShowFieldRoomModel *model = [WVRShowFieldRoomModel yy_modelWithDictionary:dic];
                [list addObject:model];
            }
            
//            block(list, nil);
        }
    }];
}

+ (void)requestForShowFieldList:(APIResponseBlock)block {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = round(time);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString stringWithFormat:@"%ld", (long)time];
    
    NSDictionary *params = [WVRAPIHandle appendCommenParams:dict];
    
    NSString *finalParams = [self getParamStr:params];
    NSString *banner_base_url = @"";
    
    if ([WVRUserModel sharedInstance].isTest) {
        banner_base_url = @"http://showapi-test.snailvr.com/room/list";
    } else {
        banner_base_url = @"http://showapi.snailvr.com/room/list";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?%@", banner_base_url, finalParams];
    
    [WVRSnailvrHTTPManager GETService:url withParams:nil completionBlock:^(id responseObj, NSError *error) {
        
        if (!responseObj) {
            block(nil, error);
        } else {
            NSDictionary *dict = responseObj;
            NSArray *arr = dict[@"roomlistdata"];
            
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                WVRShowFieldRoomData *model = [WVRShowFieldRoomData yy_modelWithDictionary:dic];
                [list addObject:model];
            }
            
            block(list, nil);
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
    NSString *resultMD5Str = [SQMD5Tool encryptByMD5:keyStr md5Suffix:@"SHOW_SNAILVR_AUTHENTICATION"];
    
    NSString *params = @"";
    for (NSString *curKey in newKeys) {
        params = [params stringByAppendingString:curKey];
        params = [params stringByAppendingString:@"="];
        params = [params stringByAppendingString:dict[curKey]];
        params = [params stringByAppendingString:@"&"];
    }
    params = [params substringToIndex:params.length - 1];
    NSString *finalParams = [NSString stringWithFormat:@"%@&sign=%@", params, resultMD5Str];
    
    return finalParams;
}

@end
