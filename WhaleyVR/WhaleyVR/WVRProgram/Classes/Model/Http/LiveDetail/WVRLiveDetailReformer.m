//
//  WVRLiveDetailReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveDetailReformer.h"
#import "WVRLiveItemModel.h"
#import "WVRHttpLiveDetailModel.h"

@implementation WVRLiveDetailReformer

#pragma - mark WVRAPIManagerDataReformer protocol

- (WVRLiveItemModel*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpLiveDetailModel * model = [WVRHttpLiveDetailModel yy_modelWithDictionary:businessDictionary];
    
    return [self parseLiveDetail:model];
}

- (WVRLiveItemModel *)parseLiveDetail:(WVRHttpLiveDetailModel *)item
{
    WVRLiveItemModel* iModel = [[WVRLiveItemModel alloc] init];
    
    iModel.code = item.code;
    iModel.linkArrangeValue = item.code;
    iModel.linkArrangeType = LINKARRANGETYPE_LIVE;
    iModel.name = item.displayName;
    iModel.intrDesc = item.descriptionStr;
    iModel.thubImageUrl = item.poster;
    iModel.shareImageUrl = item.poster.length>0 ?item.poster:item.pic;
    iModel.address = item.address;
    iModel.subTitle = item.subtitle;
    iModel.liveStatus = [item.liveStatus integerValue];
    iModel.beginTime = item.beginTime;
    iModel.endTime = item.endTime;
    iModel.guests = [self parseGuests:item.guests];
    iModel.liveMediaDtos = [self parseMediaDtos:item.liveMediaDtos];
    
    iModel.mediaDtos = item.liveMediaDtos;
    iModel.displayMode = item.displayMode;
    
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
    iModel.freeTime = item.freeTime;
    iModel.timeLeftSeconds = item.timeLeftSeconds;
    iModel.behavior = item.behavior;
    iModel.bgPic = item.bgPic;
    iModel.vipPic = item.vipPic;
    iModel.isGift = item.isGift;
    iModel.isTip = item.isTip;
    iModel.giftTemplate = item.giftTemplate;
    
    iModel.floatUrl1 = item.floatUrl1;
    iModel.floatUrl2 = item.floatUrl2;
    iModel.floatUrl3 = item.floatUrl3;
    
    iModel.floatPic1 = item.floatPic1;
    iModel.floatPic2 = item.floatPic2;
    iModel.floatPic3 = item.floatPic3;
    
    iModel.floatName1 = item.floatName1;
    iModel.floatName2 = item.floatName2;
    iModel.floatName3 = item.floatName3;
    
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

- (NSArray *)parseMediaDtos:(NSArray *)data {
    
    NSMutableArray * guests = [NSMutableArray array];
    for (WVRMediaDto *cur in data) {
        WVRLiveMediaModel * media = [WVRLiveMediaModel new];
//        media.code = cur.code;
        media.playUrl = cur.playUrl;
        media.resolution = cur.resolution;
        media.renderType = cur.renderType;
        media.cameraStand = cur.srcName ?: cur.source;
        media.definition = cur.curDefinition;
        
        [guests addObject:media];
    }
    return guests;
}

@end
