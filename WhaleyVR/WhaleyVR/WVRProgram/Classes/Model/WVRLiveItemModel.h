//
//  WVRSQLiveItemModel.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRItemModel.h"
#import "WVRMediaDto.h"

@interface WVRLiveGuestModel : WVRBaseModel

@property (nonatomic, copy) NSString * guestName;
@property (nonatomic, copy) NSString * guestPic;

@end


@interface WVRLiveMediaModel : WVRBaseModel

/// getter 重写，返回的字母都为大写
@property (nonatomic, copy) NSString * resolution;
@property (nonatomic, copy) NSString * renderType;
@property (nonatomic, copy) NSString * playUrl;

/// 仅节目为足球时有效
@property (nonatomic, copy) NSString * cameraStand;
/// 清晰度
@property (nonatomic, copy) NSString * definition;
@end


@interface WVRLiveItemModel : WVRItemModel

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * beginTime;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSArray * guests;

/// 庆波解析过后的model list
@property (nonatomic, strong) NSArray<WVRLiveMediaModel *> * liveMediaDtos;

@property (nonatomic, copy) NSString* viewCount;
@property (nonatomic, copy) NSString* hasOrder;
@property (nonatomic, copy) NSString* liveOrderCount;

@property (nonatomic, assign) long timeLeftSeconds;

@property (nonatomic, assign) int isDanmu;
@property (nonatomic, assign) int isLottery;

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *vipPic;
@property (nonatomic, copy) NSString *giftTemplate;
@property (nonatomic, assign) BOOL isGift;
@property (nonatomic, assign) BOOL isTip;

@property (nonatomic, copy) NSString * startDateFormat;

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


@property (nonatomic, readonly) NSArray *guestPics;
@property (nonatomic, readonly) NSArray *guestNames;

@property (nonatomic, copy) void(^reserveBlock)(void(^successBlock)(void), void(^failBlock)(NSString* errStr), UIButton* btn);

- (instancetype)copyNewItemModel;
- (NSString *)parseMililiveOrderCount;

@end
