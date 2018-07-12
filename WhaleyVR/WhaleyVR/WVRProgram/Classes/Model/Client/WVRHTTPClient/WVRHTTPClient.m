//
//  WVRHTTPClient.m
//  WhaleyVR
//
//  Created by Snailvr on 16/8/4.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 通用json数据接口 无baseURL

#import "WVRHTTPClient.h"
#import "WVRAPIHandle.h"

@implementation WVRHTTPClient

// MARK: - 该网络请求工具类只作为JSON请求使用，其他类型数据请求需要另行封装

+ (instancetype)sharedClient {
    
    static WVRHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        _sharedClient = [[WVRHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        // 此处不用设置，AFN 默认设置就是这样
//        self.requestSerializer = [AFHTTPRequestSerializer serializer];
//        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.requestSerializer.timeoutInterval = 60;
        [self.requestSerializer setStringEncoding:NSUTF8StringEncoding];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"text/xml", nil];
        
        // 使用YYModel做数据装换的时候会自动过滤Null值，这里就不用处理
        ((AFJSONResponseSerializer *)self.responseSerializer).removesKeysWithNullValues = YES;
    }
    
    return self;
}

//GET请求
- (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block {
    
    [self.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [self GET:URLStr parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DDLogInfo(@"WVRHTTPClient_GET %@", task.currentRequest.URL.absoluteString);
        block(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        DDLogInfo(@"WVRHTTPClient_GET %@", task.currentRequest.URL.absoluteString);
        DDLogError(@"WVRHTTPClient_GET %@", [error localizedDescription]);
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        DDLogError(@"WVRHTTPClient_GET %ld", (long)res.statusCode);
        
        block(nil, error);
    }];
}

//POST 请求封装
- (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block {
    
    // 防止Java后台无法接收POST参数
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [self POST:URLStr parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DDLogInfo(@"WVRHTTPClient_POST %@", task.currentRequest.URL.absoluteString);
        block(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        DDLogInfo(@"WVRHTTPClient_POST %@", task.currentRequest.URL.absoluteString);
        DDLogError(@"WVRHTTPClient_POST %@", [error localizedDescription]);
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        DDLogError(@"WVRHTTPClient_POST %ld", (long)res.statusCode);
        
        block(nil, error);
    }];
}

- (void)cancelOperations {
    
    [self.operationQueue cancelAllOperations];
}

+ (NSDictionary *)appendCommenParams:(NSDictionary *)param {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param ?: @{}];
    
//    for (NSString *key in param.allKeys) {
//        dict[key] = param[key];
//    }
    
    return [dict copy];
}

@end
