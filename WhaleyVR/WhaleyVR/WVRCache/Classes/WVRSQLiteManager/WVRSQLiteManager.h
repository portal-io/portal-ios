//
//  LWSQLiteManager.h
//  LewoSVR
//
//  Created by iStig on 15/11/11.
//  Copyright © 2015年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue;

/// 开机广告
static NSString *const kBootAdTypeAd = @"Ad";
/// 海报
static NSString *const kBootAdTypePoster = @"Poster";
/// 悬浮层
static NSString *const kBootAdTypeLayer = @"Layer";

@interface WVRSQLiteManager : NSObject

@property (nonatomic, readonly, copy  ) NSString *databasePath;
@property (nonatomic, readonly, strong) FMDatabaseQueue *fmQueue;

@property (nonatomic, assign, readonly) long maxEventId;

+ (instancetype)sharedManager;


#pragma mark - 苹果内购订单防止漏单管理

- (BOOL)insertIAPOrder:(NSDictionary *)modelDict;

- (NSArray<NSDictionary *> *)ordersInIAPOrder;

- (void)removeIAPOrder:(NSString *)videoId;

- (void)removeAllIAPOrder;


#pragma mark - BI Event Track

- (BOOL)insertBIEvent:(NSString *)content;

/**
 SQLite中存储的BI数据
 
 @return 存储BI JSON数据的数组
 */
- (NSArray *)contentsInBIEvents;

/**
 上报成功，移除SQLite中的数据

 @param Id 默认传0即可，自动匹配获取contentsInBIEvents时的maxId
 */
- (void)removeBIEventBelowId:(long)Id;

- (void)removeAllBIEvents;

// MARK: - AdInfos

/// 以推荐位code为唯一标识
- (BOOL)saveADWithCode:(NSString *)code adType:(NSString *)adType;

/// 以推荐位code为唯一标识
- (NSTimeInterval)lastShowTimeForADCode:(NSString *)code adType:(NSString *)adType;

@end
