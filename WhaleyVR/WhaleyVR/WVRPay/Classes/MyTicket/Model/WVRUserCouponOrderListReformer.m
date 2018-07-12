//
//  WVRUserCouponOrderListReformer.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUserCouponOrderListReformer.h"
#import "WVRUserTicketListModel.h"

@implementation WVRUserCouponOrderListReformer

#pragma mark - WVRAPIManagerDataReformer protocol

- (WVRUserTicketListModel *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRUserTicketListModel *model = [WVRUserTicketListModel yy_modelWithDictionary:businessDictionary];
    
    return model;
}

@end
