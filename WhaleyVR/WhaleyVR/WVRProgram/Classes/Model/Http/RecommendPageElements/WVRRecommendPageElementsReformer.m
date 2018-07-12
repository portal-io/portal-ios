//
//  WVRRecommendPageReformer.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/16.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRRecommendPageElementsReformer.h"
#import "WVRHttpRecommendPaginationContentModel.h"
#import "WVRSectionModel.h"
#import "WVRLiveShowModel.h"

@interface WVRRecommendPageElementsReformer ()


@end
@implementation WVRRecommendPageElementsReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (WVRSectionModel*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpRecommendPaginationContentModel * model = [WVRHttpRecommendPaginationContentModel yy_modelWithDictionary:businessDictionary];
    
    return [self parserModel:model];
}

-(WVRSectionModel *)parserModel:(WVRHttpRecommendPaginationContentModel* )args
{
    WVRSectionModel * sectionModel = [[WVRSectionModel alloc] init];
    sectionModel.totalPages = [[args totalPages] integerValue];
    NSMutableArray * itemModels = [NSMutableArray array];
    for (WVRHttpRecommendElement* elementModel in [args content]) {
        WVRSectionModel * itemModel = [[WVRSectionModel alloc] init];
        itemModel.name = elementModel.name;
        itemModel.code = elementModel.code;
        itemModel.linkArrangeType = elementModel.linkArrangeType;
        itemModel.linkArrangeValue = elementModel.linkArrangeValue;
        itemModel.thubImageUrl = elementModel.picUrlNew;
        itemModel.subTitle = elementModel.subtitle;
        itemModel.itemCount = elementModel.detailCount;
        itemModel.programType = elementModel.programType;
        itemModel.videoType = elementModel.videoType;
        itemModel.duration = elementModel.programPlayTime;
        itemModel.playCount = elementModel.statQueryDto.playCount;
        if ([elementModel.linkArrangeType isEqualToString:LINKARRANGETYPE_MANUAL_ARRANGE]) {
            itemModel.detailCount = elementModel.detailCount;
        }else if ([elementModel.linkArrangeType isEqualToString:LINKARRANGETYPE_CONTENT_PACKAGE]) {
            itemModel.detailCount = elementModel.contentPackageDto.totalCount;
        }
        
        [itemModels addObject:itemModel];
    }
    sectionModel.itemModels = itemModels;
    return sectionModel;
//    if (isMore) {
//        if (!self.sectionModel.itemModels) {
//            self.sectionModel.itemModels = [NSMutableArray array];
//        }
//        [self.sectionModel.itemModels addObjectsFromArray:itemModels];
//    }else{
//        self.sectionModel.itemModels = itemModels;
//    }
    
}
@end

