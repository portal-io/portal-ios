//
//  WVRHistoryModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRItemModel.h"

extern NSString *const PROGRAMTYPE_PROGRAM;                 // 历史记录
extern NSString *const PROGRAMTYPE_MORETV;                  // 历史记录

extern NSString *const PROGRAMTYPE_MORETV_TYPE_MOVIE ;              // 历史记录
extern NSString *const PROGRAMTYPE_MORETV_TYPE_TV ;                 // 历史记录

typedef NS_ENUM(NSInteger, HistoryPlayStatus) {
    
    HistoryPlayStatusUnknow = 0,
    HistoryPlayStatusPlaying = 1,
    HistoryPlayStatusComplate = 2,
};

@interface WVRHistoryModel : WVRItemModel

@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * playTime;
@property (nonatomic, strong) NSString * playStatus;
@property (nonatomic, strong) NSString * programCode;
@property (nonatomic, strong) NSString * programName;
@property (nonatomic, strong) NSString * programStatus;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * reportTime;
@property (nonatomic, strong) NSString * parentCode;
@property (nonatomic, strong) NSString * parentDisplayName;
@property (nonatomic, strong) NSString * curEpisode;
@property (nonatomic, strong) NSString * totalEpisode;
@property (nonatomic, strong) NSString * totalPlayTime;

@property (nonatomic, strong) NSString * moreTVType;

@property (nonatomic, strong) NSString * formatDateStr;
@property (nonatomic, strong) NSString * formatDateKey;

@property (nonatomic, assign) BOOL needNot;

@end
