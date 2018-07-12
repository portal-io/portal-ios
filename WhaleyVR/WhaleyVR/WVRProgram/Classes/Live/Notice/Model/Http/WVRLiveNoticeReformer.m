//
//  WVRLiveNoticeReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveNoticeReformer.h"
#import "WVRLiveItemModel.h"
#import "WVRHttpLiveDetailModel.h"

@implementation WVRLiveNoticeReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (NSArray<WVRLiveItemModel*>*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    NSArray<WVRHttpLiveDetailModel *>* result = [NSArray yy_modelArrayWithClass:[WVRHttpLiveDetailModel class] json:businessDictionary];
    
    return [self parseData:result];
}

-(NSArray*)parseData:(NSArray*)httpDatas
{
    NSMutableArray * originArray = [[NSMutableArray alloc] init];
    for (WVRHttpLiveDetailModel* item in httpDatas) {
        
        [originArray addObject:[self parseLiveDetail:item]];
    }
    return originArray;
}

- (WVRLiveItemModel *)parseLiveDetail:(WVRHttpLiveDetailModel *)item
{
    WVRLiveItemModel* iModel = [[WVRLiveItemModel alloc] init];
    
    iModel.code = item.code;
    iModel.linkArrangeValue = item.code;
    iModel.linkArrangeType = LINKARRANGETYPE_LIVE;
    iModel.name = item.displayName;
    iModel.thubImageUrl = item.poster;
    iModel.address = item.address;
    iModel.subTitle = item.subtitle;
    iModel.liveStatus = [item.liveStatus integerValue];
    iModel.beginTime = item.beginTime;
    iModel.guests = [self parseGuests:item.guests];
    iModel.liveMediaDtos = [self parseMediaDtos:item.liveMediaDtos];
    
    iModel.mediaDtos = item.liveMediaDtos;
    
    iModel.viewCount = item.stat.viewCount;
    iModel.playCount = item.stat.playCount;
    iModel.type = item.type;
    iModel.videoType = item.videoType;
    iModel.programType = item.programType;
    iModel.isDanmu = item.isDanmu;
    iModel.isLottery = item.isLottery;
    iModel.payType = item.payType;
    iModel.radius = item.radius;
    
    iModel.couponDto = item.couponDto;
    iModel.contentPackageQueryDtos = item.contentPackageQueryDtos;
    
    if (item.liveOrdered) {
        iModel.hasOrder = [NSString stringWithFormat:@"%d", item.liveOrdered];
    } else {
        iModel.hasOrder = item.hasOrder;
    }
    iModel.isChargeable = item.isChargeable;
    iModel.price = item.price;
    iModel.liveOrderCount = item.liveOrderCount;
    iModel.timeLeftSeconds = item.timeLeftSeconds;
    iModel.behavior = item.behavior;
    
    return iModel;
}

- (NSArray *)parseGuests:(NSArray *)data {
    
    NSMutableArray * guests = [NSMutableArray array];
    for (WVRHttpGuestModel* cur in data) {
        WVRLiveGuestModel * guest = [WVRLiveGuestModel new];
        guest.guestName = cur.guestName;
        guest.guestPic = cur.guestPic;
        [guests addObject:guest];
    }
    return guests;
}

- (NSArray *)parseMediaDtos:(NSArray *)data
{
    NSMutableArray * guests = [NSMutableArray array];
    for (WVRMediaDto *cur in data) {
        WVRLiveMediaModel * media = [WVRLiveMediaModel new];
        //        media.code = cur.code;
        media.playUrl = cur.playUrl;
        media.resolution = cur.resolution;
        media.renderType = cur.renderType;
        media.cameraStand = cur.source;
        media.definition = cur.curDefinition;
        
        [guests addObject:media];
    }
    return guests;
}

@end
