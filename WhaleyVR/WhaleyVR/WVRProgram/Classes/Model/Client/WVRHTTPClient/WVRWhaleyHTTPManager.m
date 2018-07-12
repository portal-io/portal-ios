//
//  WVRWhaleyHTTPManager.m
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/16.
//  Copyright © 2016年 Snailvr. All rights reserved.

// NewVR vr-api.aginomoto.com
// 蓝鲸后台部分接口对接

#import "WVRWhaleyHTTPManager.h"
#import "WVRHTTPClient.h"
#import "WVRAPIHandle.h"

@implementation WVRWhaleyHTTPManager

// GET请求
+ (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block {
    
    NSString *finalUrl = URLStr;
    if (![URLStr hasPrefix:@"http"]) {
        finalUrl = [NSString stringWithFormat:@"%@%@", self.baseUrl, URLStr];
    }
    
    NSDictionary *dict = [WVRAPIHandle appendCommenParams:params];
    
    [[WVRHTTPClient sharedClient] GET:finalUrl parameters:dict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DDLogInfo(@"WVRWhaleyHTTPManager_GET %@", task.currentRequest.URL.absoluteString);
        block(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        DDLogInfo(@"WVRWhaleyHTTPManager_GET %@", task.currentRequest.URL.absoluteString);
        DDLogError(@"WVRWhaleyHTTPManager_GET %@", [error localizedDescription]);
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        DDLogError(@"WVRWhaleyHTTPManager_GET %ld", (long)res.statusCode);
        
        block(nil, error);
    }];
}

//POST 请求封装
+ (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block {
    
    NSString *finalUrl = URLStr;
    if (![URLStr hasPrefix:@"http"]) {
        finalUrl = [NSString stringWithFormat:@"%@%@", self.baseUrl, URLStr];
    }
    
    NSDictionary *dict = [WVRAPIHandle appendCommenParams:params];
    
    [[WVRHTTPClient sharedClient] POST:finalUrl parameters:dict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DDLogInfo(@"WVRWhaleyHTTPManager_POST %@", task.currentRequest.URL.absoluteString);
        block(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        DDLogInfo(@"WVRWhaleyHTTPManager_POST %@", task.currentRequest.URL.absoluteString);
        DDLogError(@"WVRWhaleyHTTPManager_POST %@", [error localizedDescription]);
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        DDLogError(@"WVRWhaleyHTTPManager_POST %ld", (long)res.statusCode);
        
        block(nil, error);
    }];
}

+ (NSString *)baseUrl {
    
    return [WVRUserModel kNewVRBaseURL];
}


@end
