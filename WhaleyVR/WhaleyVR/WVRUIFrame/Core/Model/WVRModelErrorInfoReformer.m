//
//  WVRModelErrorInfoReformer.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRModelErrorInfoReformer.h"
#import "WVRModelErrorInfo.h"

@implementation WVRModelErrorInfoReformer

- (WVRModelErrorInfo *)reformData:(NSDictionary *)data {
    WVRModelErrorInfo *errorInfo = [[WVRModelErrorInfo alloc] init];
    errorInfo.code = data[@"code"];
    errorInfo.msg = data[@"msg"];
    return errorInfo;
}

@end
