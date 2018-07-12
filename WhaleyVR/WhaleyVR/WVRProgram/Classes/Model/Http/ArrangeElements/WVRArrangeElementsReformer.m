//
//  WVRArrangeElementsReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRArrangeElementsReformer.h"
#import "WVRHttpArrangeElementsPageModel.h"
#import "WVRSectionModel.h"

@implementation WVRArrangeElementsReformer

#pragma - mark WVRAPIManagerDataReformer protocol

- (WVRSectionModel*)reformData:(NSDictionary *)data {
    
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpArrangeElementsPageModel * model = [WVRHttpArrangeElementsPageModel yy_modelWithDictionary:businessDictionary];
    
    return [self parserModel:model];
}

- (WVRSectionModel *)parserModel:(WVRHttpArrangeElementsPageModel *)args {
    
    WVRSectionModel * sectionModel = [[WVRSectionModel alloc] init];
    sectionModel.totalPages = [[args totalPages] integerValue];
    NSMutableArray * itemModels = [NSMutableArray array];
    for (WVRHttpArrangeElementModel* elementModel in [args content]) {
        WVRItemModel * itemModel = [WVRItemModel new];
        itemModel.name = elementModel.itemName;
        itemModel.code = elementModel.code;
        itemModel.linkArrangeType = elementModel.linkArrangeType;
        itemModel.linkArrangeValue = elementModel.linkArrangeValue;
        itemModel.thubImageUrl = elementModel.picUrl;
        itemModel.subTitle = elementModel.subtitle;
        itemModel.isChargeable = elementModel.isChargeable;
        itemModel.videoType = elementModel.videoType;
        itemModel.programType = elementModel.programType;
        [itemModels addObject:itemModel];
    }
    
    sectionModel.itemModels = itemModels;
    
    return sectionModel;
}

@end
