//
//  WVRHttpAllChannelReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAllChannelReformer.h"
#import "WVRHttpRecommendPageDetailModel.h"
#import "WVRItemModel.h"

@implementation WVRAllChannelReformer

#pragma - mark WVRAPIManagerDataReformer protocol
- (NSArray<WVRItemModel*> *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpRecommendPageDetailModel *businessModel = [WVRHttpRecommendPageDetailModel yy_modelWithDictionary:businessDictionary];
    WVRHttpRecommendArea * area = [[businessModel recommendAreas] lastObject];
    NSMutableArray * itemModels = [NSMutableArray new];
    for (WVRHttpRecommendElement * element in [area recommendElements]) {
        WVRItemModel * itemModel = [WVRItemModel new];
        itemModel.name = element.name;
        itemModel.logoImageUrl = element.logoImageUrl;
        itemModel.linkArrangeType = element.linkArrangeType;
        itemModel.linkArrangeValue = element.linkArrangeValue;
        itemModel.infUrl = element.infUrl;
        itemModel.recommendPageType = element.recommendPageType;
        itemModel.recommendAreaCodes = element.recommendAreaCodes;
        itemModel.recommendAreaCode = [element.recommendAreaCodes firstObject];
        [itemModels addObject:itemModel];
    }

    return itemModels;
}



@end
