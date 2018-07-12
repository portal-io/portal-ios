//
//  WVRCollectionStatusReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCollectionStatusReformer.h"
#import "WVRHttpCollectionModel.h"


@implementation WVRCollectionStatusReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (NSNumber*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpCollectionModel * model = [WVRHttpCollectionModel yy_modelWithDictionary:businessDictionary];
    if (model) {
        return @(YES);
    }
    return @(NO);
}

@end
