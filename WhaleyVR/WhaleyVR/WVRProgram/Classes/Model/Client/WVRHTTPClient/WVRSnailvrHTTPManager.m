//
//  WVRSnailvrHTTPManager.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/15.
//  Copyright © 2016年 Snailvr. All rights reserved.

// vrapi.snailvr.com
// 王菲演唱会接口 / 微鲸VR公共服务接口

#import "WVRSnailvrHTTPManager.h"
#import "WVRHTTPClient.h"

@implementation WVRSnailvrHTTPManager

//GET请求
+ (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block {
    
    NSString *finalUrl = URLStr;
    if (![URLStr hasPrefix:@"http"]) {
        finalUrl = [NSString stringWithFormat:@"%@%@", self.baseUrl, URLStr];
    }
    
    [[WVRHTTPClient sharedClient] GET:finalUrl parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DDLogInfo(@"WVRSnailvrHTTPManager_GET %@", task.currentRequest.URL.absoluteString);
        block(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        DDLogInfo(@"WVRSnailvrHTTPManager_GET %@", task.currentRequest.URL.absoluteString);
        DDLogError(@"WVRSnailvrHTTPManager_GET %@", [error localizedDescription]);
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        DDLogError(@"WVRSnailvrHTTPManager_GET %ld", (long)res.statusCode);
        
        block(nil, error);
    }];
}

//POST 请求封装
+ (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block {
    
    NSString *finalUrl = URLStr;
    if (![URLStr hasPrefix:@"http"]) {
        finalUrl = [NSString stringWithFormat:@"%@%@", self.baseUrl, URLStr];
    }
    
    [[WVRHTTPClient sharedClient] POST:finalUrl parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DDLogInfo(@"WVRSnailvrHTTPManager_POST %@", task.currentRequest.URL.absoluteString);
        block(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        DDLogInfo(@"WVRSnailvrHTTPManager_POST %@", task.currentRequest.URL.absoluteString);
        DDLogError(@"WVRSnailvrHTTPManager_POST %@", [error localizedDescription]);
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        DDLogError(@"WVRSnailvrHTTPManager_POST %ld", (long)res.statusCode);
        
        block(nil, error);
    }];
}

+ (NSString *)baseUrl {
    
    return [WVRUserModel kSnailvrBaseURL];
}

@end
