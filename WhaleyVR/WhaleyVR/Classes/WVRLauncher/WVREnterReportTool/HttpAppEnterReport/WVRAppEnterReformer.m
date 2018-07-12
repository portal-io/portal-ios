//
//  WVRAppEnterReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAppEnterReformer.h"

@implementation WVRAppEnterReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (NSString*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    NSString * time = businessDictionary[@"time"];
    
    return time;
}
@end
