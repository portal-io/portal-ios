//
//  WVRTVVideoDetailReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVVideoDetailReformer.h"
#import "WVRHttpProgramModel.h"
#import "WVRTVItemModel.h"

@implementation WVRTVVideoDetailReformer

#pragma - mark WVRAPIManagerDataReformer protocol

- (WVRTVItemModel*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpProgramModel * model = [WVRHttpProgramModel yy_modelWithDictionary:businessDictionary];
    if (!model) {
        return nil;
    }
    return [self parserModel:model];
}

- (WVRTVItemModel *)parserModel:(WVRHttpProgramModel *)args {
    
    WVRTVItemModel * itemModel = [WVRTVItemModel new];
    itemModel.code = args.code;
    itemModel.parentCode = args.parentCode;
    itemModel.name = args.displayName;
    itemModel.playCount = args.stat.playCount;
    itemModel.intrDesc = args.desc;
    itemModel.curEpisode = args.curEpisode;
    itemModel.thubImageUrl = args.smallPic;
    itemModel.actors = args.actors;
    itemModel.area = args.area;
    itemModel.year = args.year;
    itemModel.director = args.director;
    itemModel.duration = args.duration;
    itemModel.score = args.score;
    itemModel.type = args.type;
    
    if (itemModel.thubImageUrl.length <= 0) {
        itemModel.thubImageUrl = args.lunboPic;
    }
    
    itemModel.playUrlModels = [self parsePlayUrlModel:args.medias];
    itemModel.tags_ = [args.tags componentsSeparatedByString:@","];
    if (args.series) {
        [self parseSerise:args.series itemModel:itemModel];
    }
    return itemModel;
}

- (NSMutableArray *)parsePlayUrlModel:(NSArray<WVRHttpProgramMediasModel *> *)medias {
    
    NSMutableArray * playUrlModels = [NSMutableArray array];
    for (WVRHttpProgramMediasModel * model in medias) {
        WVRTVPlayUrlModel * tvPlayModel = [WVRTVPlayUrlModel new];
        tvPlayModel.playUrl = model.playUrl;
        tvPlayModel.source = model.source;
        tvPlayModel.threedType = model.threedType;
        
        [playUrlModels addObject:tvPlayModel];
    }
    return playUrlModels;
}

- (void)parseSerise:(NSArray<WVRHttpProgramModel *> *)series itemModel:(WVRTVItemModel *)itemModel {
    
    NSMutableArray* seriesModels = [NSMutableArray array];
    for (WVRHttpProgramModel* model in series) {
        WVRTVItemModel * itemModel = [WVRTVItemModel new];
        itemModel.code = model.code;
        itemModel.name = model.displayName;
        itemModel.playCount = model.stat.playCount;
        itemModel.curEpisode = model.curEpisode;
        itemModel.thubImageUrl = model.smallPic;
        itemModel.actors = model.actors;
        itemModel.area = model.area;
        itemModel.year = model.year;
        itemModel.director = model.director;
        itemModel.duration = model.duration;
        itemModel.score = model.score;
        itemModel.type = model.type;
        
        if (itemModel.thubImageUrl.length <= 0) {
            itemModel.thubImageUrl = model.lunboPic;
        }
        itemModel.playUrlModels = [self parsePlayUrlModel:model.medias];
        [seriesModels addObject:itemModel];
    }
    
    itemModel.tvSeries = seriesModels;
}

@end
