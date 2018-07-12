//
//  WVRUserRedeemCodeReformer.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUserRedeemCodeReformer.h"
#import "WVRUnExchangeCodeModel.h"

@implementation WVRUserRedeemCodeReformer

#pragma mark - WVRAPIManagerDataReformer protocol

- (WVRUnExchangeCodeModel *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRUnExchangeCodeModel *model = [WVRUnExchangeCodeModel yy_modelWithDictionary:businessDictionary];
    
    return model;
}

@end
