//
//  WVRRecommendItemModel.h
//  WhaleyVR
//
//  Created by Snailvr on 16/9/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRItemModel.h"
#import "WVRWhaleyHTTPManager.h"
@class WVRStatQueryDto;

// 推荐位显示频率(0:活动期间仅显示一次; 1:活动期间每日仅显示一次; 2:活动期间每次启动都显示)
typedef NS_ENUM(NSInteger, WVRLaunchRecommendShowRate) {
    
    WVRLaunchRecommendShowRateOnce = 0,         // 活动期间仅显示一次
    WVRLaunchRecommendShowRateDaily = 1,        // 活动期间每日仅显示一次
    WVRLaunchRecommendShowRateEvery = 2,        // 每次启动都显示
};

@interface WVRRecommendItemModel : WVRItemModel

@property (nonatomic, assign) WVRRecommndAreaType recommendAreaType;

@property (nonatomic, assign) NSInteger             programPlayTime;
@property (nonatomic, copy) NSString              * videoUrl;
@property (nonatomic, copy) NSString              * picUrl_;            // 映射字段
@property (nonatomic, strong) WVRStatQueryDto     * statQueryDto;

@property (nonatomic, assign) WVRLaunchRecommendShowRate showRate;  // 推荐位展示频率

@end


@interface WVRStatQueryDto :NSObject

@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger playSeconds;
@property (nonatomic, copy) NSString *programType;
@property (nonatomic, copy) NSString *videoType;
@property (nonatomic, copy) NSString *srcCode;
@property (nonatomic, copy) NSString *srcDisplayName;

+ (void)requestWithCode:(NSString *)code block:(void(^)(WVRStatQueryDto * responseObj, NSError *error))block;

@end

