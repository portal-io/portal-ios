//
//  WVRBIManager.h
//  WhaleyVR
//
//  Created by Bruce on 2017/7/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WVRBIModel.h"
@class WVRPayModel, WVRVideoEntity;

// startplay, endplay, pause, continue, startbuffer, endbuffer, lowbitrate
typedef NS_ENUM(NSInteger, BIActionType) {
    
    BIActionTypeStartplay,
    BIActionTypeEndplay,
    BIActionTypePause,          // discarded
    BIActionTypeContinue,       // discarded
    BIActionTypeStartbuffer,    // discarded
    BIActionTypeEndbuffer,      // discarded
    BIActionTypeLowbitrate,     // discarded
};


typedef NS_ENUM(NSInteger, BITopicActionType) {
    
    BITopicActionTypeBrowse,            // discarded
    BITopicActionTypeListPlay,
    BITopicActionTypeItemPlay,
//    BITopicActionTypeShare,
};


typedef NS_ENUM(NSInteger, BIDetailActionType) {
    
    BIDetailActionTypeBrowseVR,                 // discarded
    BIDetailActionTypeCollectionVR,
    BIDetailActionTypeDownloadVR,
    BIDetailActionTypeBrowseLivePrevue,         // discarded
    BIDetailActionTypeBrowseLivePlay,           // discarded
    BIDetailActionTypeReserveLive,
    BIDetailActionTypeCollectionDrama,
//    BIDetailActionTypeShare,
};


typedef NS_ENUM(NSInteger, BIPayActionType) {
    
//    BIPayActionTypeBrowse,
    BIPayActionTypeSelect,
    BIPayActionTypeSuccess,
};

@interface WVRBIManager : NSObject

/**
 将BIModel的数据序列化为json存储至SQLite

 @param model WVRBIModel
 */
//+ (void)saveModelToLocal:(WVRBIModel *)model;

/**
 上传BI日志，两个节点：应用启动，日志累计够25条
 */
+ (void)uploadBIEvents;

@end
