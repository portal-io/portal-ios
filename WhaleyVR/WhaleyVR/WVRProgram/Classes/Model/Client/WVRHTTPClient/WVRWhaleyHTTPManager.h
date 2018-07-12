//
//  WVRWhaleyHTTPManager.h
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/16.
//  Copyright © 2016年 Snailvr. All rights reserved.

// NewVR vr-api.aginomoto.com
// 蓝鲸后台部分接口对接

#import <Foundation/Foundation.h>
#import "WVRAPIConst.h"

@interface WVRWhaleyHTTPManager : NSObject

+ (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block;

+ (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block;

@end
