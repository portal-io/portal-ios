//
//  WVRItemModel.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBaseModel.h"
#import "WVRMediaDto.h"
#import "WVRContentPackageQueryDto.h"
#import "WVRDetailModel.h"
@class WVRMediaModel;

typedef NS_ENUM(NSInteger, WVRPayType) {
    
    WVRPayTypeExcode = 1,               // 微鲸兑换码购买
    WVRPayTypeThirdPart,                // 第三方支付
};

@interface WVRItemModel : WVRBaseModel

@property (nonatomic, weak) id backDelegate;

@property (nonatomic, assign) BOOL shouldPresent;

@property (nonatomic) NSString * shareImageUrl; // 分享使用

/// 获取详情类型相关信息，最好只在详情页使用（适用于类型匹配及埋点）
@property (nonatomic, strong, readonly) WVRDetailModel *detailModel;

#pragma mark - 网络数据映射字段

@property (nonatomic, assign) WVRPayType payType;
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) long freeTime;
@property (nonatomic, copy) NSString *centerPic;

@property (nonatomic, assign) long disableTimeDate;
@property (nonatomic, copy) NSString *disableTime;

@property (nonatomic) NSString * unitConut;
@property (nonatomic) NSString * logoImageUrl;
@property (nonatomic) NSString * playUrl;
@property (nonatomic) NSString * duration;

@property (nonatomic) NSString * infUrl;
@property (nonatomic) NSString * infTitle;

@property (nonatomic) NSString * type;

@property (nonatomic) NSString * playCount;

@property (nonatomic, strong) NSString* detailCount;

@property (nonatomic) NSString * relatedCode;
@property (nonatomic) NSString * renderType;

@property (nonatomic) NSString * tags;
@property (nonatomic) NSString * actors;
@property (nonatomic) NSString * area;
@property (nonatomic) NSString * year;
@property (nonatomic) NSString * director;

@property (nonatomic, strong) NSArray <WVRMediaModel*>* palyMediaModels;

@property (nonatomic, assign) float score;

// 直播
@property (nonatomic, assign) WVRLiveStatus liveStatus;
@property (nonatomic, assign) WVRLiveDisplayMode displayMode;

// 付费
/// 商品价格 getter已重写
@property (nonatomic, assign) long price;
@property (nonatomic, assign) int isChargeable;

@property (nonatomic, strong) WVRCouponDto *couponDto;
@property (nonatomic, strong) NSArray<WVRContentPackageQueryDto *> *contentPackageQueryDtos;

// item在section里的唯一标识
@property (nonatomic, assign) long itemId;
@property (nonatomic, strong) NSString *behavior;
@property (nonatomic, strong) NSString *bgPic;
@property (nonatomic, strong) NSString *contentType;

/// live的字段名称已经做映射 liveMediaDtos
@property (nonatomic, strong) NSArray<WVRMediaDto *> *mediaDtos;

#pragma mark - 自定义属性

@property (nonatomic) BOOL haveCharged;

@property (nonatomic) NSString* arrangeShowFlag;
@property (nonatomic) NSArray<WVRItemModel *>* arrangeElements;

@property (nonatomic) NSArray<NSDictionary<NSString *, NSString *> *>* playerUrls;

@property (nonatomic) NSString * STPlayerUrl;
@property (nonatomic) NSString * SDPlayerUrl;
@property (nonatomic) NSString * HDPlayerUrl;

/// 节目包中视频 nil表示节目包或所有节目已付费 @1 表示该节目已付费 @0表示该节目未付费
@property (nonatomic, strong) NSNumber *packageItemCharged;

#pragma mark - external func

//- (BOOL)isFree;

#pragma mark - getter

- (NSString *)sid;
- (NSString *)title;
- (NSString *)address;
- (long)totalTime;

/// self.contentPackageQueryDtos.firstObject
- (WVRContentPackageQueryDto *)contentPackageQueryDto;
- (NSString *)definitionForPlayURL;

/// 只在请求详情返回的数据中有效
- (BOOL)isFootball;

/// 该节目对应的购买只支持合集
- (BOOL)isProgramSet;

@end
