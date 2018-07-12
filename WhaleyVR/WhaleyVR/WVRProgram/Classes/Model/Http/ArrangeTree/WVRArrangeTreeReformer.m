//
//  WVRArrangeTreeReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRArrangeTreeReformer.h"
#import "WVRSectionModel.h"
#import "WVRHttpArrangeElementModel.h"

@implementation WVRArrangeTreeReformer

#pragma mark - WVRAPIManagerDataReformer protocol

- (WVRSectionModel*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpArrangeEleFByCModel * model = [WVRHttpArrangeEleFByCModel yy_modelWithDictionary:businessDictionary];
    
    return [self parserModel:model];
}

- (WVRSectionModel *)parserModel:(WVRHttpArrangeEleFByCModel *)args {
   
    WVRSectionModel * sectionModel = [[WVRSectionModel alloc] init];
    NSMutableArray * itemModels = [NSMutableArray array];
    NSArray * recommendAreas = [args arrangeTreeElements];
    sectionModel.name = args.name;
    sectionModel.isActivity = [args.bizType isEqualToString:@"ACTIVITY"];
    sectionModel.linkArrangeValue = args.code;
    sectionModel.thubImageUrl = args.bigImageUrl;
    sectionModel.intrDesc = args.introduction;
    
    for (WVRHttpArrangeElementModel* element in recommendAreas) {
        WVRItemModel * model = [WVRItemModel new];
        
        model.code = element.code;
        model.name = element.itemName;
        model.thubImageUrl = element.picUrl;
        model.subTitle = element.subtitle;
        model.linkArrangeType = element.linkType;
        model.linkArrangeValue = element.linkId;
        if (model.code.length == 0) {   //手动编排列表没有code，用linkId表示唯一性
            model.code = model.linkArrangeValue;
        }
        model.playUrl = element.videoUrl;
        model.duration = element.duration;
        model.videoType = element.videoType;
        model.programType = element.programType;
        model.isChargeable = element.isChargeable;
        model.price = element.price;
        model.renderType = element.renderType;
        model.playCount = element.statQueryDto.playCount;
        model.detailCount = element.detailCount;
        model.intrDesc = element.introduction;
        [itemModels addObject:model];
    }
    sectionModel.itemModels = itemModels;
    sectionModel.itemCount = [NSString stringWithFormat:@"%d", (int)itemModels.count];
    
    return sectionModel;
}

@end
