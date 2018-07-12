
//
//  WVRRecommendPageTitleReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRecommendPageTitleReformer.h"
#import "WVRSectionModel.h"
#import "WVRLiveShowModel.h"
#import "WVRRecommendPageModel.h"
#import "WVRHttpRecommendPaginationContentModel.h"

@implementation WVRRecommendPageTitleReformer
#pragma - mark WVRAPIManagerDataReformer protocol

- (WVRRecommendPageModel *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpRecommendPageDetailModel * model = [WVRHttpRecommendPageDetailModel yy_modelWithDictionary:businessDictionary];
    
    return [self parserModel:model];
}

- (WVRRecommendPageModel *)parserModel:(WVRHttpRecommendPageDetailModel* )args {

    NSArray * recommendAreas = [args  recommendAreas];
    
    WVRRecommendPageModel * result = [[WVRRecommendPageModel alloc] init];
    result.sectionModels = [self parseHttpRecommendArea:[recommendAreas firstObject]];
    result.firstSectionModelName = [[recommendAreas firstObject] name];
    result.name = args.name;
    return result;
}

- (NSMutableDictionary *)parseHttpRecommendArea:(WVRHttpRecommendArea*)recommendArea {
    
    NSMutableDictionary * sectionModelDic = [NSMutableDictionary dictionary];
    NSArray * elements = [recommendArea recommendElements];
    for (WVRHttpRecommendElement* element in elements) {
        WVRSectionModel * sectionModel = [[WVRSectionModel alloc] init];
        sectionModel.recommendAreaCode = [element.recommendAreaCodes firstObject];
        
        sectionModel.name = element.name;
        sectionModel.subTitle = element.subtitle;
        sectionModel.linkArrangeValue = element.linkArrangeValue;
        sectionModel.linkArrangeType = element.linkArrangeType;
        sectionModel.videoType = element.videoType;
        sectionModel.type = sectionModel.type;
        sectionModel.thubImageUrl = element.picUrlNew;
        sectionModel.recommendPageType = element.recommendPageType;
        sectionModel.recommendAreaCodes = element.recommendAreaCodes;
        sectionModelDic[@([elements indexOfObject:element])] = sectionModel;
    }
    return sectionModelDic;
}

@end
