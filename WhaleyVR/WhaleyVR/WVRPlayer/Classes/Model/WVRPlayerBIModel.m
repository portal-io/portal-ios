//
//  WVRPlayerBIModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerBIModel.h"
#import "WVRVideoParamEntity.h"
#import "WVRAppModel.h"
#import "WVRUIConst.h"

@implementation WVRPlayerBIModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _tmpDurations = [NSMutableArray array];
    }
    return self;
}

// startplay, endplay, pause, continue, startbuffer, endbuffer, lowbitrate
+ (void)trackEventForPlayWithAction:(BIActionType)action position:(long)position renderType:(NSString *)renderType defi:(NSString *)defi screenType:(int)screenType ve:(WVRVideoParamEntity *)ve {
    
    [self trackEventForPlayWithAction:action position:position renderType:renderType defi:defi screenType:screenType ve:ve errorCode:0];
}

+ (void)trackEventForPlayWithAction:(BIActionType)action position:(long)position renderType:(NSString *)renderType defi:(NSString *)defi screenType:(int)screenType ve:(WVRVideoParamEntity *)ve errorCode:(int)errorCode {
    
    [self trackEventForPlayWithAction:action startPlayDuration:0 position:position renderType:renderType defi:defi screenType:screenType ve:ve errorCode:errorCode];
}

+ (void)trackEventForPlayWithAction:(BIActionType)action startPlayDuration:(long)startPlayDuration position:(long)position renderType:(NSString *)renderType defi:(NSString *)defi screenType:(int)screenType ve:(WVRVideoParamEntity *)ve errorCode:(int)errorCode {
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = @"play";
    model.logInfo.eventId = @"play";
    model.logInfo.nextPageId = @"play";
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    currentPageProp[@"videoSid"] = ve.sid;
    currentPageProp[@"videoName"] = ve.videoTitle;
    currentPageProp[@"videoType"] = [self videoTypeForVideoEntity:ve];
    currentPageProp[@"videoTags"] = ve.biEntity.videoTag;
    currentPageProp[@"screenType"] = [NSString stringWithFormat:@"%d", screenType];
    if (ve.streamType == STREAM_VR_LOCAL) {
        currentPageProp[@"curBitType"] = @"local";
    } else {
        currentPageProp[@"curBitType"] = [self defiToBitType:defi];
    }
    currentPageProp[@"videoFormat"] = [WVRPlayerBIModel streamTypeToVideoFormat:ve.streamType];
    currentPageProp[@"contentType"] = ve.biEntity.contentType;
    currentPageProp[@"isChargeable"] = [NSString stringWithFormat:@"%d", ve.isChargeable];
    
    WVRAppModel *appModel = [WVRAppModel sharedInstance];
    
    switch (action) {
            case BIActionTypeStartplay: {
                
                eventProp[@"actionType"] = @"startplay";
                
                // 视频起播加载时间
                eventProp[@"startPlayDuration"] = [NSString stringWithFormat:@"%ld", startPlayDuration];
                eventProp[@"position"] = [NSString stringWithFormat:@"%ld", position];
            }
            break;
            
            case BIActionTypeStartbuffer: {
                
                eventProp[@"actionType"] = @"startbuffer";
                
                appModel.tmpDownSize = appModel.curDownSize;
                eventProp[@"position"] = [NSString stringWithFormat:@"%ld", position];
                
            }
            break;
            
            case BIActionTypeEndbuffer: {
                
                eventProp[@"actionType"] = @"endbuffer";
                
                eventProp[@"duration"] = [NSString stringWithFormat:@"%ld", position];
                eventProp[@"bufferData"] = [NSString stringWithFormat:@"%ld", ((appModel.curDownSize - appModel.tmpDownSize) / 1024)];
            }
            break;
            
            case BIActionTypeEndplay: {
                
                eventProp[@"actionType"] = @"endplay";
                
                eventProp[@"duration"] = [NSString stringWithFormat:@"%ld", position];
                
//                if (errorCode != 0) {
//                    NSString *err = (!ve.biEntity.isPlayError) ? @"startplayerror" : @"playerror";
//                    eventProp[@"exitType"] = [NSString stringWithFormat:@"%@ %d", err, errorCode];
//                } else {
                eventProp[@"exitType"] = @"selfend";
//                }
                model.logInfo.nextPageId = @"detail";
                
                if (ve.detailModel.isDrama) {
                    eventProp[@"totalTime"] = [NSString stringWithFormat:@"%ld", ve.biEntity.totalTime * 1000];
                }
            }
            break;
            
            case BIActionTypeLowbitrate: {
                
                eventProp[@"actionType"] = @"lowbitrate";
                
                eventProp[@"position"] = [NSString stringWithFormat:@"%ld", position];
                eventProp[@"bitrate"] = [NSString stringWithFormat:@"%.1f", ve.biEntity.bitrate];
            }
            break;
            
            case BIActionTypeContinue: {
                
                eventProp[@"actionType"] = @"continue";
                eventProp[@"duration"] = [NSString stringWithFormat:@"%ld", position];
            }
            break;
            
            case BIActionTypePause: {
                
                eventProp[@"actionType"] = @"pause";
                eventProp[@"position"] = [NSString stringWithFormat:@"%ld", position];
            }
            break;
            
        default:
            break;
    }
    
    if (ve.streamType == STREAM_VR_VOD) {
        
        if ([defi isEqualToString:kDefinition_SDA] || [defi isEqualToString:kDefinition_SDB]) {
            
            eventProp[@"playMode"] = RENDER_TYPE_360_2D_OCTAHEDRAL;
        } else {
            
            eventProp[@"playMode"] = renderType;
        }
    } else if (ve.streamType == STREAM_VR_LOCAL) {
        
        eventProp[@"playMode"] = RENDER_TYPE_360_2D;
    }
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    [model saveToSQLite];
}

+ (NSString *)streamTypeToVideoFormat:(WVRStreamType)streamType {
    
    switch (streamType) {
        case STREAM_VR_VOD:
        case STREAM_VR_LIVE:
            return @"vr";
        case STREAM_2D_TV:
            return @"2d";
        case STREAM_3D_WASU:
            return @"3d";
        case STREAM_VR_LOCAL:
            return @"";
        default:
            return @"";
    }
}

// {HD、SD、4K、local}：HD-高清、SD：超清、local：本地视频
+ (NSString *)defiToBitType:(NSString *)defi {
    
    if ([defi isEqualToString:kDefinition_ST]) { return @"HD"; }
    if ([defi isEqualToString:kDefinition_HD]) { return @"4K"; }
    if ([defi isEqualToString:kDefinition_SDA]) { return kDefinition_SDA; }
    if ([defi isEqualToString:kDefinition_SDB]) { return kDefinition_SDB; }
    if ([defi isEqualToString:kDefinition_TDA]) { return kDefinition_TDA; }
    if ([defi isEqualToString:kDefinition_TDB]) { return kDefinition_TDB; }
    
    return defi;
}

+ (NSString *)videoTypeForVideoEntity:(WVRVideoParamEntity *)ve {
    
    WVRStreamType streamType = ve.streamType;
    
    switch (streamType) {
            case STREAM_VR_VOD:
            return @"VR";
            
            case STREAM_3D_WASU:
            return @"3D";
            
            case STREAM_VR_LIVE:
            return @"live";
            
            case STREAM_VR_LOCAL:
            return @"local_video";
            
            case STREAM_2D_TV: {
                BOOL isMoreMovie = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
                if ([ve respondsToSelector:@selector(isMoreMovie)]) {
                    isMoreMovie = [ve performSelector:@selector(isMoreMovie)];
                }
#pragma clang diagnostic pop
                if (isMoreMovie) {
                    return @"moretv_movie";
                } else {
                    return @"moretv_tv";
                }
            }
            
        default:
            break;
    }
    return @"VR"; // moretv_tv、moretv_movie、local_video、3D、VR、live
}

@end
