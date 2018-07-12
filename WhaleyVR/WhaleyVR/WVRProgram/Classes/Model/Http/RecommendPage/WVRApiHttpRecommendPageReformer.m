//
//  WVRApiHttpRecommendPageReformer.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRApiHttpRecommendPageReformer.h"
#import "WVRHttpRecommendPageDetailModel.h"

@implementation WVRApiHttpRecommendPageReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (WVRHttpRecommendPageDetailModel*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpRecommendPageDetailModel * model = [WVRHttpRecommendPageDetailModel yy_modelWithDictionary:businessDictionary];
    return model;
}
@end
