//
//  WVRBaseModel.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "WVRNetConst.h"

//#import "WVRModelProtocol.h"

//typedef NS_ENUM(NSInteger, WVRCustomNextStepType){
//    WVRCustomNextStepTypeDefault,
//    WVRCustomNextStepTypeLauncher,
//};


typedef NS_ENUM(NSInteger, WVRLinkType) {
    
    WVRLinkTypeVR = 1,            // 360全景
    WVRLinkTypeLive,              // 直播
    WVRLinkTypeH5,                // H5内页
    WVRLinkType3DMovie,           // 3D电影
    WVRLinkTypeTopic,             // 专题
    WVRLinkTypeNews,              // 资讯
    WVRLinkTypeH5Outer,           // H5外页
    WVRLinkTypeHome,              // tab间跳转
    WVRLinkTypeList,              // 自动编排（二级列表，无站点树）
    WVRLinkTypeMoreTV,            // 电视节目
    WVRLinkTypeMoreMovie,         // 电视猫电影
    WVRLinkTypePlay,              // 直接播放
    WVRLinkTypeMix,               // 混排模式
    WVRLinkTypePage,              // 混排模式
    WVRLinkTypeTitle,             // 混排模式
    WVRLinkTypeDarma,             // 互动剧
};

typedef NS_ENUM (NSInteger, WVRSectionModelType) {
    
    WVRSectionModelTypeArrange = 0,
    WVRSectionModelTypeDefault = 1,
    WVRSectionModelTypeBanner = 2,
    WVRSectionModelTypeAD = 3,
    WVRSectionModelTypeBrand = 4,
    WVRSectionModelTypeHot = 5,
    WVRSectionModelTypeTag = 6,
    WVRSectionModelTypeShow = 7,
    WVRSectionModelTypeTV = 8,
    WVRSectionModelTypeSinglePlay = 11,
    
    WVRSectionModelTypeFootballBanner = 12,
    WVRSectionModelTypeFootballLive = 13,
    WVRSectionModelTypeFootballRecord = 14,
    
    
    WVRSectionModelTypeAllChannel = 100,
    WVRSectionModelTypeManualArrange = 101,
    
    WVRSectionModelTypeManualArrangeShare = 102,
    WVRSectionModelTypeLive = 103,
    
    WVRSectionModelTypeSubManualArrange = 104,
    
    WVRSectionModelTypeSet = 105,
    
    WVRSectionModelTypeLiveRecommendBanner = 200,
    WVRSectionModelTypeLiveRecommendHot = 201,
    WVRSectionModelTypeLiveRecommendDefault = 202,
    WVRSectionModelTypeLiveNotice = 203,
};

typedef NS_ENUM(NSInteger, WVRModelVideoType) {
    
    WVRModelVideoTypeDefault,
    WVRModelVideoType3D,
    WVRModelVideoTypeVR,
    WVRModelVideoTypeMoreTVTV,
    WVRModelVideoTypeMoreTVMovie,
};

typedef NS_ENUM(NSInteger, WVRPageJumpType) {
    
    WVRPageJumpTypeRecommend = 1,          // 推荐首页
    WVRPageJumpTypeChannelVR,              // 频道-全景视频
    WVRPageJumpTypeChannel3D,              // 频道-3D电影
    WVRPageJumpTypeLive,                   // 直播·预告
    WVRPageJumpTypeLiveReview,             // 直播回顾
};

@interface WVRBaseModel : NSObject // <WVRModelProtocol>

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * updateTime;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * intrDesc;

@property (nonatomic, copy) NSString * downloadUrl;
@property (nonatomic, copy) NSString * thubImageUrl;
@property (nonatomic, copy) NSString * scaleThubImage;
@property (nonatomic, copy) NSString * subTitle;
@property (nonatomic, copy) NSString * linkArrangeType;
@property (nonatomic, copy) NSString * videoType;
@property (nonatomic, copy) NSString * programType;
@property (nonatomic, copy) NSString * linkArrangeValue;   // 下一级请求code(编排值)

@property (nonatomic, copy) NSString * srcDisplayName;
//@property (nonatomic) WVRCustomNextStepType customProgramType;//客户端端自定义的跳转类型，与接口无关

@property (nonatomic, copy) NSString * recommendPageType;

@property (nonatomic, copy) NSString * isCollection;

@property (nonatomic, copy) NSString * recommendAreaCode;
@property (nonatomic, strong) NSArray * recommendAreaCodes;

/// 跳转类型
@property (nonatomic, readonly) WVRLinkType  linkType_;

/// 跳转类型，仅当style为WVRLinkTypeHome时有效
@property (nonatomic, readonly) WVRPageJumpType   jumpType_;

@property (nonatomic, readonly) WVRModelVideoType videoType_;

/// 页面跳转时携带一些特殊参数
@property (nonatomic, strong) NSDictionary *jumpParamsDic;

- (WVRSectionModelType)parseSectionTypeWithHttpRecAreaType:(NSString *)areaType;

@end


