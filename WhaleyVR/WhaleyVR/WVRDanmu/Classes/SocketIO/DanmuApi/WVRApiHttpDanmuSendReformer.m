//
//  WVRApiHttpDanmuSendReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpDanmuSendReformer.h"

@implementation WVRApiHttpDanmuSendReformer
- (id)reformData:(NSDictionary *)data {
    NSNumber * statusCodeNumber = data[@"status"];
    NSString * statusCode = [NSString stringWithFormat:@"%@",statusCodeNumber];
    
    return statusCode;
}
@end
