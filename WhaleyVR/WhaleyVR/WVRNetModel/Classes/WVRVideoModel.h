//
//  WVRVideoModel.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger , WVRVideoDownloadStatus){
    WVRVideoDownloadStatusDefault = 0,
    WVRVideoDownloadStatusDowning,
    WVRVideoDownloadStatusPause,
    WVRVideoDownloadStatusDown,
    WVRVideoDownloadStatusDownFail,
    WVRVideoDownloadStatusPrepare,
};

@interface WVRVideoModel : NSObject

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, assign) long createTime;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *intrDesc;
@property (nonatomic, copy) NSString *videoType;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *definition;

@property (nonatomic, copy) NSString *renderTypeStr;

@property (nonatomic, assign) NSInteger renderType;
@property (nonatomic, assign) NSInteger streamType;
//@property (nonatomic, assign) FrameOritation oritation;
/**
 down video
 */
@property (nonatomic, assign) BOOL isDownload;
@property (nonatomic, assign) BOOL downloadOver;
@property (nonatomic, assign) WVRVideoDownloadStatus downStatus;
@property (nonatomic, copy) NSString *thubImage;

@property (nonatomic, copy) NSString * scaleThubImage;
@property (nonatomic, copy) NSString *pathToFile;
@property (nonatomic, copy) NSString * fileName;
@property (nonatomic, copy) NSString *downLink;
@property (nonatomic, assign) CGFloat downProgress;

@property (nonatomic, assign) NSInteger duration;//详情中是秒
@property (nonatomic, assign) CGFloat totalSize;
@property (nonatomic, copy) NSString *curSize;

/**
 local video
 */
@property (nonatomic, strong) UIImage *localThubImage;
@property (nonatomic, copy) NSString *localUrl;

- (BOOL)save;
- (void)deleteWithItemId:(NSString *)itemId;

+ (WVRVideoModel *)loadFromDBWithId:(NSString *)itemId;
+ (NSArray *)searchAllFromDBWithDownFlag:(BOOL)downFlag;


@end
