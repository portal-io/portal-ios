//
//  WVRSnailvrHTTPManager.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/15.
//  Copyright © 2016年 Snailvr. All rights reserved.

// vrapi.snailvr.com
// 王菲演唱会接口 / 微鲸VR公共服务接口

#import <Foundation/Foundation.h>
#import "WVRAPIConst.h"

@interface WVRSnailvrHTTPManager : NSObject

+ (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block;

+ (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block;

@end
