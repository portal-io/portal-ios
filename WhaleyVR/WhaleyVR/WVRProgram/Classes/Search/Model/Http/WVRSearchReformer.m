//
//  WVRSearchReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSearchReformer.h"
#import "WVRHttpSearchModel.h"

@implementation WVRSearchReformer

#pragma - mark WVRAPIManagerDataReformer protocol

- (WVRHttpSearchModel *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpSearchModel *businessModel = [WVRHttpSearchModel yy_modelWithDictionary:businessDictionary];
    
    return businessModel;
}


@end
