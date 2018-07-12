//
//  WVRModelRecommendReformer.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRModelRecommendReformer.h"
#import "WVRModelRecommend.h"

@implementation WVRModelRecommendReformer

#pragma - mark WVRAPIManagerDataReformer protocol
- (WVRModelRecommend *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRModelRecommend *businessModel = [WVRModelRecommend yy_modelWithDictionary:businessDictionary];
    return businessModel;
}

@end
