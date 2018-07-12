//
//  WVRHTTPClient.h
//  WhaleyVR
//
//  Created by Snailvr on 16/8/4.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 通用json数据接口 无baseURL

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "WVRUserModel.h"

@interface WVRHTTPClient : AFHTTPSessionManager

// MARK: - 该网络请求工具类只作为JSON请求使用，其他类型数据请求需要另行封装

+ (instancetype)sharedClient;

- (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block;

- (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block;

- (void)cancelOperations;

+ (NSDictionary *)appendCommenParams:(NSDictionary *)param;

@end
