//
//  WVRHttpLiveDetailModel.h
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRContentPackageQueryDto.h"
#import "WVRMediaDto.h"

@interface WVRHttpGuestModel : NSObject

@property (nonatomic, copy) NSString * guestName;
@property (nonatomic, copy) NSString * guestPic;

@end


@interface WVRHttpLiveStatModel : NSObject

@property (nonatomic, copy) NSString * srcCode;
@property (nonatomic, copy) NSString * srcDisplayName;
@property (nonatomic, copy) NSString * srcType;
@property (nonatomic, copy) NSString * viewCount;
@property (nonatomic, copy) NSString * playCount;
@property (nonatomic, copy) NSString * playSeconds;

@end


@interface WVRHttpLiveDetailModel : NSObject

@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * displayName;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * videoType;
@property (nonatomic, copy) NSString * programType;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * superscript;
@property (nonatomic, copy) NSString * poster;
@property (nonatomic, copy) NSString * pic;
@property (nonatomic, copy) NSString * descriptionStr;
@property (nonatomic, copy) NSString * liveStatus;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * beginTime;
@property (nonatomic, copy) NSString * endTime;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * publishTime;
@property (nonatomic, strong) NSArray<WVRHttpGuestModel *>* guests;
@property (nonatomic, strong) NSArray<WVRMediaDto *>* liveMediaDtos;
@property (nonatomic, strong) WVRHttpLiveStatModel * stat;

@property (nonatomic, strong) WVRCouponDto *couponDto;
@property (nonatomic, strong) NSArray<WVRContentPackageQueryDto *> *contentPackageQueryDtos;

@property (nonatomic, copy) NSString * playUrl;

@property (nonatomic, assign) BOOL liveOrdered;

@property (nonatomic, copy) NSString * hasOrder;

@property (nonatomic, assign) int isChargeable;
@property (nonatomic, assign) long price;
@property (nonatomic, copy) NSString *liveOrderCount;

@property (nonatomic, assign) long timeLeftSeconds;

@property (nonatomic, assign) long freeTime;
@property (nonatomic, assign) int isDanmu;
@property (nonatomic, assign) int isLottery;
@property (nonatomic, assign) int payType;
@property (nonatomic, assign) float radius;

@property (nonatomic, strong) NSString* bgPic;
@property (nonatomic, strong) NSString *vipPic;
@property (nonatomic, copy) NSString *behavior;

@property (nonatomic, assign) NSInteger displayMode;

@property (nonatomic, assign) BOOL isGift;
@property (nonatomic, assign) BOOL isTip;
@property (nonatomic, strong) NSString *giftTemplate;
@property (nonatomic, strong) NSString *memberTemplate;

/// 车展直播字段
@property (nonatomic, copy) NSString *floatName1;
@property (nonatomic, copy) NSString *floatName2;
@property (nonatomic, copy) NSString *floatName3;

@property (nonatomic, copy) NSString *floatPic1;
@property (nonatomic, copy) NSString *floatPic2;
@property (nonatomic, copy) NSString *floatPic3;

@property (nonatomic, copy) NSString *floatUrl1;
@property (nonatomic, copy) NSString *floatUrl2;
@property (nonatomic, copy) NSString *floatUrl3;

@end
