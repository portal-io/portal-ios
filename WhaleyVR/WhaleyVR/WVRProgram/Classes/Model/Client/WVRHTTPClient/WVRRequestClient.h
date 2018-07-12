//
//  WVRRequestClient.h
//  WhaleyVR
//
//  Created by Snailvr on 16/9/23.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 普通网络请求类 为了解决播放次数上传接口问题

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WVRUserModel.h"

@interface WVRRequestClient : NSObject

+ (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block;

+ (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block;

/// 表单提交
+ (void)POSTFormData:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block;

@end
