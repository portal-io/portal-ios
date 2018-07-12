//
//  WVRWebRequest.h
//  JockeyJS
//
//  Created by Wang Tiger on 16/10/21.
//  Copyright © 2016年 Corkboardme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRWebRequestModel.h"
#import "WVRUserModel.h"


@interface WVRWebRequest : NSObject

@property (nonatomic, assign) BOOL shouldCache;
@property (nonatomic, copy  ) NSString *callbackId;
@property (nonatomic, strong) WVRWebRequestModel *requestModel;


+ (void)executeRequest:(NSString *)func URL:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(void(^)(NSString *responseObj, NSError *error))block;

+ (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(void(^)(NSString *responseObj, NSError *error))block;

+ (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(void(^)(NSString *responseObj, NSError *error))block;

@end
