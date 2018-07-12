//
//  WVRAddressModel.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRAddressModel.h"
#import "WVRHttpAddressModel.h"

@implementation WVRAddressModel

-(instancetype)initWithHttpModel:(WVRHttpAddressModel*)httpModel
{
    self = [super init];
    if (self) {
        self.username = httpModel.name;
        self.mobile = httpModel.mobile;
        self.province = httpModel.province;
        self.city = httpModel.city;
        self.county = httpModel.county;
        self.address = httpModel.address;
    }
    return self;
}

-(instancetype)copyNewModel
{
    WVRAddressModel * cur = [WVRAddressModel new];
    cur.mobile = self.mobile;
    cur.username = self.username;
    cur.province = self.province;
    cur.city = self.city;
    cur.county = self.county;
    cur.address = self.address;
    return cur;
}

@end
