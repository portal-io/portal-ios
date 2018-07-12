//
//  WVRMyOrderListReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyOrderListReformer.h"
#import "WVRMyOrderItemModel.h"

@implementation WVRMyOrderListReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (WVRMyOrderListModel *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRMyOrderListModel *model = [WVRMyOrderListModel yy_modelWithDictionary:businessDictionary];
    return model;
}

@end
