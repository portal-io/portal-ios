//
//  WVRBIModel.h
//  WhaleyVR
//
//  Created by Snailvr on 2016/12/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@class WVRBIMetadataModel, WVRBILogInfoModel, WVRPayModel;


@interface WVRBIModel : NSObject

@property (nonatomic, strong) WVRBIMetadataModel *metadata;
@property (nonatomic, strong) WVRBILogInfoModel  *logInfo;

- (void)saveToSQLite;

@end


@interface WVRBIMetadataModel : NSObject

@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *apkVersion;
@property (nonatomic, copy) NSString *productModel;
@property (nonatomic, copy) NSString *romVersion;
@property (nonatomic, copy) NSString *buildDate;
@property (nonatomic, assign) NSString *isRandom;
@property (nonatomic, copy) NSString *promotionChannel;
@property (nonatomic, copy) NSString *systemName;
@property (nonatomic, copy) NSString *apkSeries;

@end


@interface WVRBILogInfoModel : NSObject

//@property (nonatomic, copy) NSString *networkStatus;
@property (nonatomic, copy) NSString *currentPageId;
@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *nextPageId;
@property (nonatomic, strong) NSDictionary *eventProp;
@property (nonatomic, strong) NSDictionary *currentPageProp;

@property (nonatomic, assign) long logId;
@property (nonatomic, assign) long happenTime;  // 单位是毫秒
@property (nonatomic, assign) int isTest;
@property (nonatomic, copy) NSString *logVersion;
//@property (nonatomic, assign) long duration;

@end







