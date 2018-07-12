//
//  WVRCurrencyBuyConfigListModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyBuyConfigListModel.h"

@implementation WVRCurrencyBuyConfigListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"list" : @"data"};
}


+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"list":WVRCurrencyBuyConfigItemModel.class};
}

@end

@implementation WVRCurrencyBuyConfigItemModel

@end


