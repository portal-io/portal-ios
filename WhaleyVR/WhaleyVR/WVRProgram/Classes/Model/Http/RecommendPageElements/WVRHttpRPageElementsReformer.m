//
//  WVRHttpRPageElementsByCodeReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpRPageElementsReformer.h"
#import "WVRSetViewModel.h"


@implementation WVRHttpRPageElementsReformer

- (id)reformData:(NSDictionary *)data {
    
    NSDictionary * httpDatas = data[@"data"][@"content"];
    WVRSectionModel * sectionModel = [[WVRSectionModel alloc] init];
    sectionModel.totalPages = [data[@"data"][@"totalPages"] integerValue];
    NSMutableArray * itemModels = [[NSMutableArray alloc] init];
    
    for (NSDictionary * cur in httpDatas) {
        WVRItemModel* itemModel = [[WVRItemModel alloc] init];
        itemModel.name = cur[@"name"];
        itemModel.code = cur[@"code"];
        itemModel.linkArrangeType = cur[@"linkArrangeType"];
        itemModel.linkArrangeValue = cur[@"linkArrangeValue"];
        itemModel.thubImageUrl = cur[@"newPicUrl"];
        itemModel.subTitle = cur[@"subtitle"];
        itemModel.intrDesc = cur[@"introduction"];
        itemModel.detailCount = cur[@"detailCount"];
        itemModel.programType = cur[@"programType"];
        itemModel.videoType = cur[@"videoType"];
        itemModel.duration = cur[@"programPlayTime"];
        itemModel.playCount = cur[@"statQueryDto"][@"playCount"];
        if (cur[@"contentPackageDto"]) {
            itemModel.detailCount = cur[@"contentPackageDto"][@"totalCount"];
        }
        
        [itemModels addObject:itemModel];
    }
    sectionModel.itemModels = itemModels;
    
    return sectionModel;
}

@end
