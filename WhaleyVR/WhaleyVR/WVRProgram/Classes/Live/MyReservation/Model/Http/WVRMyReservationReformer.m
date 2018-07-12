//
//  WVRHttpAllChannelReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyReservationReformer.h"
#import "WVRHttpLiveDetailModel.h"
#import "WVRLiveItemModel.h"

@implementation WVRMyReservationReformer

#pragma - mark WVRAPIManagerDataReformer protocol
- (NSArray<WVRItemModel*> *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    
    NSArray<WVRHttpLiveDetailModel*>* elements = [NSArray yy_modelArrayWithClass:[WVRHttpLiveDetailModel class] json:businessDictionary];
//    WVRHttpRecommendPageDetailModel *businessModel = [WVRHttpRecommendPageDetailModel yy_modelWithDictionary:businessDictionary];
//    WVRHttpRecommendArea * area = [[businessModel recommendAreas] lastObject];
    NSMutableArray * itemModels = [NSMutableArray new];
    for (WVRHttpLiveDetailModel * cur in elements) {
        
//        NSMutableArray * array = [NSMutableArray new];
//        for (WVRItemModel * cur in responseModel) {
//            WVRLiveItemModel * liveItemModel = [WVRLiveItemModel new];
//            liveItemModel.name = cur.name;
//            liveItemModel.thubImageUrl = cur.poster;
//            liveItemModel.startDateFormat = cur.beginTime;
//            liveItemModel.linkArrangeType = LINKARRANGETYPE_LIVE;
//            liveItemModel.liveStatus = cur.liveStatus;
//            liveItemModel.code = cur.code;
//            liveItemModel.linkArrangeValue = liveItemModel.code;
//            liveItemModel.playUrl = [[cur.liveMediaDtos firstObject] playUrl];
//            liveItemModel.srcDisplayName = cur.stat.srcDisplayName;
//            liveItemModel.displayMode = [cur.displayMode integerValue];
//            liveItemModel.programType = cur.programType;
//            [array addObject:liveItemModel];
//        }
        WVRLiveItemModel * liveItemModel = [WVRLiveItemModel new];
        liveItemModel.name = cur.displayName;
        liveItemModel.thubImageUrl = cur.poster;
        liveItemModel.startDateFormat = cur.beginTime;
        liveItemModel.linkArrangeType = LINKARRANGETYPE_LIVE;
        liveItemModel.liveStatus = [cur.liveStatus integerValue];
        liveItemModel.code = cur.code;
        liveItemModel.linkArrangeValue = liveItemModel.code;
        liveItemModel.playUrl = [[cur.liveMediaDtos firstObject] playUrl];
        liveItemModel.srcDisplayName = cur.stat.srcDisplayName;
//        liveItemModel.displayMode = [cur.displayMode integerValue];
        liveItemModel.programType = cur.programType;
        
        [itemModels addObject:liveItemModel];
    }

    return itemModels;
}



@end
