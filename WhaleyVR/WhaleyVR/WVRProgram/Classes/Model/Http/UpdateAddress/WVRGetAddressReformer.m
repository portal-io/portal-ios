//
//  WVRGetAddressReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGetAddressReformer.h"
#import "WVRHttpAddressModel.h"
#import "WVRAddressModel.h"

@implementation WVRGetAddressReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (WVRAddressModel*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = data[@"member_addressdata"];
    WVRHttpAddressModel * model = [WVRHttpAddressModel yy_modelWithDictionary:businessDictionary];
    
    return [[WVRAddressModel alloc] initWithHttpModel:model];
}
@end
