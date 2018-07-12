//
//  WVRModelUserInfoReformer.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRModelUserInfoReformer.h"
#import "WVRModelUserInfo.h"

@implementation WVRModelUserInfoReformer

#pragma mark - WVRAPIManagerDataReformer protocol

- (WVRModelUserInfo *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRModelUserInfo *businessModel = [WVRModelUserInfo yy_modelWithDictionary:businessDictionary];
    
    return businessModel;
}

@end
