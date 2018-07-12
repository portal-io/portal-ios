//
//  WVRPlayerTool.m
//  WhaleyVR
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRPlayerTool.h"

#import "WVRPlayerVCLive.h"
#import "WVRPlayerVCLocal.h"
#import "WVRPlayerVC360.h"
#import "WVRPlayerVCWasu.h"

#import "WVRTrackEventMapping.h"
#import "WVRMediator+AccountActions.h"
#import "WVRNavigationController.h"

//#import "WasuPlayUtil.h"
#import "WVRItemModel.h"

#import "WVRUserModel.h"
#import "WVRWhaleyHTTPManager.h"

#import "WVRGlobalUtil.h"
#import <SecurityFramework/Security.h>
#import <CommonCrypto/CommonDigest.h>

#import "WVRApiHttpHistoryRecord.h"
#import "WVRModelErrorInfo.h"
#import "WVRHistoryModel.h"

#import "WVRVideoEntityLocal.h"
#import "WVRVideoEntityWasuMovie.h"
#import "WVRVideoEntity360.h"
#import "WVRVideoEntityLive.h"
#import "UIViewController+HUD.h"
#import "WVRUploadViewCountHandle.h"

@implementation WVRPlayerTool

#pragma mark - init

+ (void)showPlayerControllerWith:(WVRPlayerToolModel *)tModel {
    
    [self startWithModel:tModel];
}


+ (void)showPlayerControllerWithTitle:(NSString *)title
                            videoType:(WVRVideoStreamType)type
                           detailType:(WVRVideoDetailType)detailType
                                  sid:(NSString *)sid
                               webURL:(NSString *)webURL
                              playURL:(NSString *)playURL
                                 icon:(NSString *)iconURL
                                  tag:(NSString *)videoTag
                         resourceCode:(NSString *)resourceCode
                            totalTime:(NSInteger)duration
                           Controller:(UINavigationController *)nav {

  WVRPlayerToolModel *tModel = [[WVRPlayerToolModel alloc] initWithTitle:title
                                      videoType:type
                                     detailType:detailType
                                            sid:sid
                                         webURL:webURL
                                        playURL:playURL
                                           icon:iconURL
                                            tag:videoTag
                                   resourceCode:resourceCode
                                      totalTime:duration
                                      playCount:0
                                     Controller:nav];
    [self startWithModel:tModel];
}

//+ (void)showPlayerControllerWithTitle:(NSString *)title
//                            videoType:(WVRVideoStreamType)type
//                           detailType:(WVRVideoDetailType)detailType
//                                  sid:(NSString *)sid
//                               webURL:(NSString *)webURL
//                              playURL:(NSString *)playURL
//                                 icon:(NSString *)iconURL
//                                  tag:(NSString *)videoTag
//                         resourceCode:(NSString *)resourceCode
//                            totalTime:(NSInteger)duration
//                            oritation:(FrameOritation)localVideoOritaion
//                           Controller:(UINavigationController *)nav {
//    
//    WVRPlayerToolModel *tModel = [[WVRPlayerToolModel alloc] initWithTitle:title
//                                                                 videoType:type
//                                                                detailType:detailType
//                                                                       sid:sid
//                                                                    webURL:webURL
//                                                                   playURL:playURL
//                                                                      icon:iconURL
//                                                                       tag:videoTag
//                                                              resourceCode:resourceCode
//                                                                 totalTime:duration
//                                                                 playCount:0
//                                                                Controller:nav];
//    tModel.oritaion = localVideoOritaion;
//    [self startWithModel:tModel];
//}

+ (void)showPlayerVCWithModel:(WVRItemModel *)itemModel items:(NSArray *)items {
    
    WVRVideoDetailType detailType = WVRVideoDetailTypeVR;
    if ([itemModel.programType isEqualToString:PROGRAMTYPE_RECORDED]) {
        if ([itemModel.videoType isEqualToString:VIDEO_TYPE_VR]) {
            detailType = WVRVideoDetailTypeVR;
        } else if ([itemModel.videoType isEqualToString:VIDEO_TYPE_3D]) {
            detailType = WVRVideoDetailType3DMovie;
        }
    } else if ([itemModel.programType isEqualToString:PROGRAMTYPE_LIVE]) {
        detailType = WVRVideoDetailTypeLive;
    } else if ([itemModel.programType isEqualToString:PROGRAMTYPE_MORETV_TV]) {
        detailType = WVRVideoDetailTypeMoreTV;
    } else if ([itemModel.programType isEqualToString:PROGRAMTYPE_MORETV_MOVIE]) {
        detailType = WVRVideoDetailTypeMoreMovie;
    }
    
    WVRPlayerToolModel *tModel = [[WVRPlayerToolModel alloc] initWithTitle:itemModel.title
                                                                 videoType:WVRVideoStreamTypeNormal
                                                                detailType:detailType
                                                                       sid:itemModel.sid
                                                                    webURL:nil
                                                                   playURL:itemModel.playUrl
                                                                      icon:itemModel.thubImageUrl
                                                                       tag:@""
                                                              resourceCode:@""
                                                                 totalTime:itemModel.duration.longLongValue
                                                                 playCount:0
                                                                Controller:[UIViewController getCurrentVC].navigationController];
//    tModel.detailItemModels = items;
    tModel.code = itemModel.code;
    tModel.isChargeable = itemModel.isChargeable;
    tModel.price = itemModel.price;
    tModel.renderType = itemModel.renderType;
    
    [self startWithModel:tModel];
}

#pragma mark - start

+ (void)startWithModel:(WVRPlayerToolModel *)tModel {
    
    [self showPlayerCtrl:tModel];
}

#pragma mark - deal

+ (void)showReachabilityMessage:(WVRPlayerToolModel *)tModel {
    
    [UIAlertController alertTitle:kAlertTitle mesasge:kReachAlert preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *alert) {
        
        [self showPlayerCtrl:tModel];
        
    } cancleHandler:nil viewController:tModel.nav];
}

// 播放并异步上传播放次数，记录播放记录
+ (void)showPlayerCtrl:(WVRPlayerToolModel *)tModel {
    
    if (tModel.playURL.length < 1) { DDLogError(@"提醒：playURL为空"); }
    
    if (tModel.type == WVRVideoStreamTypeNormal) {
        
        [self uploadPlayCount:tModel.sid type:tModel.detailType title:tModel.title];
        
    } else if (tModel.type == WVRVideoStreamTypeCache || tModel.type == WVRVideoStreamTypeLocal) {
        
        WVRVideoEntityLocal *ve = [[WVRVideoEntityLocal alloc] init];
        
        [self convertModel:tModel toModel:ve];
        
        ve.streamType = STREAM_VR_LOCAL;
        ve.renderType = MODE_RECTANGLE;         // beta
        ve.needParserURL = tModel.playURL;
//        ve.oritaion = tModel.oritaion;
        
        [self sendToPlay:tModel.nav withEntrty:ve];
        
        return;
    }
    
    // MARK: - 全屏播放器暂时不支持3D电影
    if (tModel.detailType == WVRVideoDetailType3DMovie) {
        
        NSString *path = [[self class] wasuMovieRealPlayUrlWithUrl:tModel.playURL];
        
        if (nil == path) { path = @""; }
        
        WVRVideoEntityWasuMovie *ve = [[WVRVideoEntityWasuMovie alloc] init];
        [self convertModel:tModel toModel:ve];
        
        ve.needParserURL = path;
        ve.price = tModel.price;
        [self sendToPlay:tModel.nav withEntrty:ve];
        
    } else {    // 普通全景、直播
        
        WVRVideoEntity *ve = [[WVRVideoEntity360 alloc] init];
        if (tModel.detailType == WVRVideoDetailTypeLive) {
            ve = [[WVRVideoEntityLive alloc] init];
            ((WVRVideoEntityLive *)ve).icon = tModel.iconURL;
        }
        
        [self convertModel:tModel toModel:ve];
        
        ve.needParserURL = tModel.playURL;
        ve.price = tModel.price;
        
        [self sendToPlay:tModel.nav withEntrty:ve];
    }
}

// 记录播放历史 db

+ (void)recordPlayHistory:(WVRHistoryModel *)historyModel {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[history_record_uid] = [WVRUserModel sharedInstance].accountId;
    params[history_record_device_id] = [WVRUserModel sharedInstance].deviceId;
    params[history_record_playTime] = historyModel.playTime;
    params[history_record_playStatus] = historyModel.playStatus;
    params[history_record_programCode] = historyModel.programCode;
    params[history_record_programType] = historyModel.programType;
    params[history_record_dataSource] = @"app";
    params[history_record_totalPlayTime] = historyModel.totalPlayTime;
    
    NSDictionary * curParams = params;
    if (curParams[history_record_playTime] || curParams[history_record_playStatus] || curParams[history_record_programCode] || curParams[history_record_programType] || curParams[history_record_totalPlayTime]) {
        
    } else {
        return;
    }
    WVRApiHttpHistoryRecord *api = [[WVRApiHttpHistoryRecord alloc] init];
    api.bodyParams = params;
    api.successedBlock = ^( id data) {

        [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_HISTORY_REFRESH object:nil];
    };
    api.failedBlock = ^(WVRModelErrorInfo *error) {
        
    };
    [api loadData];
}

+ (NSString *)wasuMovieRealPlayUrlWithUrl:(NSString *)playUrl {
    
//    NSArray *tmpArray= [playUrl componentsSeparatedByString:@"&flag"];
//    NSString *path = [tmpArray firstObject];
    NSString *url = @"";
    
//    @try {
//        url = [WasuPlayUtil getRealPlayUrl:@"1" AssetId:@"7087328" PlayUrl:path isDownload:NO];
//
//    } @catch (NSException *exception) {
//
//        DDLogError(@"华数电影链接解析失败： %@", exception.reason);
//
//        return nil;
//    }
    
    return url;
}

// 上传播放记录 request

+ (void)uploadPlayCount:(NSString *)sid type:(NSInteger)type title:(NSString *)title {
    
    if (nil == sid) {
        NSLog(@"严重错误，没有接收到sid");
        return;
    }
    
    NSString *programType = (type == WVRVideoDetailTypeLive) ? @"live": @"recorded";
    
    [WVRUploadViewCountHandle uploadViewInfoWithCode:sid programType:programType videoType:[self contentType:type] type:@"play" sec:nil title:nil];
}


+ (NSString *)contentType:(NSInteger)type {
    
    NSString *contentType = @"";
    
    if (type == WVRVideoDetailTypeVR) {                 // 全景
        
        contentType = VIDEO_TYPE_VR;
        
    } else if (type == WVRVideoDetailTypeLive)           // 直播
    {
        contentType = VIDEO_TYPE_LIVE;
        
    } else if (type == WVRVideoDetailType3DMovie)        // 3D、华数电影
    {
        contentType = VIDEO_TYPE_3D;
    }
    
    return contentType;
}

+ (void)convertModel:(WVRPlayerToolModel *)model toModel:(WVRVideoEntity *)ve {
    
    ve.videoTitle = model.title;
    ve.sid = model.sid;
//    ve.code = model.code;
    ve.biEntity.totalTime = model.duration;
    ve.biEntity.playCount = model.playCount;
    ve.isChargeable = model.isChargeable;
//    ve.detailItemModels = model.detailItemModels;
}


+ (void)sendToPlay:(UINavigationController *)vc withEntrty:(WVRVideoEntity *)ve {
    
    assert(vc != nil && ve != nil);
    
    [WVRTrackEventMapping recommendToPlayVideo:ve.sid];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        WVRPlayerVC *pVC = nil;
        
        if (ve.streamType == STREAM_VR_LIVE) {
            
            pVC = [[WVRPlayerVCLive alloc] init];
        } else if (ve.streamType == STREAM_VR_LOCAL) {
            
            pVC = [[WVRPlayerVCLocal alloc] init];
        } else if (ve.streamType == STREAM_VR_VOD) {
            
            pVC = [[WVRPlayerVC360 alloc] init];
        } else if (ve.streamType == STREAM_3D_WASU) {
            
            pVC = [[WVRPlayerVCWasu alloc] init];
        } else {
            SQToastInKeyWindow(@"暂未支持全屏播放的类型");
            return;
        }
        
        pVC.videoEntity = ve;
        
        if (ve.isChargeable == YES) {
            if (![[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:nil]) {   // 付费 统一检测登录
                return;
            }
        }
        if (ve.streamType == STREAM_VR_LIVE) {
            
            pVC.hidesBottomBarWhenPushed = YES;
            [vc pushViewController:pVC animated:YES];
            
        } else {
            
            WVRNavigationController *nav = [[WVRNavigationController alloc] initWithRootViewController:pVC];
            [vc presentViewController:nav animated:YES completion:nil];
        }
    });
}


@end


@implementation WVRPlayerToolModel

- (instancetype)initWithTitle:(NSString *)title
                    videoType:(WVRVideoStreamType)type
                   detailType:(WVRVideoDetailType)detailType
                          sid:(NSString *)sid
                       webURL:(NSString *)webURL
                      playURL:(NSString *)playURL
                         icon:(NSString *)iconURL
                          tag:(NSString *)videoTag
                 resourceCode:(NSString *)resourceCode
                    totalTime:(NSInteger)duration
                    playCount:(long)playCount
                   Controller:(UINavigationController *)nav {
    
    self = [super init];
    
    if (self) {
        
        self.title = title;
        self.type = type;
        self.detailType = detailType;
        self.sid = sid;
        self.webURL = webURL;
        self.playURL = playURL;
        self.iconURL = iconURL;
        self.videoTag = videoTag;
        self.resourceCode = resourceCode;
        self.duration = duration;
        self.playCount = playCount;
        self.nav = nav;
    }
    
    return self;
}

- (NSString *)videoTag {
    
    if (!_videoTag) { return @""; }
    
    return _videoTag;
}

- (NSString *)resourceCode {
    
    if (!_resourceCode) { return @""; }
    
    return _resourceCode;
}

@end
