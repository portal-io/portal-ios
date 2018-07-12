//
//  WVRCurrencyBuyConfigListReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyBuyConfigListReformer.h"
#import "WVRCurrencyBuyConfigListModel.h"

@implementation WVRCurrencyBuyConfigListReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (WVRCurrencyBuyConfigListModel*)reformData:(NSDictionary *)data {
    WVRCurrencyBuyConfigListModel * model = [WVRCurrencyBuyConfigListModel yy_modelWithDictionary:data];
    
    return model;
}
@end
