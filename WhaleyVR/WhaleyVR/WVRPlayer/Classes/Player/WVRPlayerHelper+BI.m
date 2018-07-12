//
//  WVRPlayerHelper+BI.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerHelper+BI.h"
#import <objc/runtime.h>
#import "WVRPlayer+BI.h"
#import "UIViewController+HUD.h"

@implementation WVRPlayerHelper (BI)

#pragma mark - setter getter

static NSString *biSidKey = @"biSidKey";

- (void)setBiSid:(NSString *)biSid {
    
    objc_setAssociatedObject(self, &biSidKey, biSid, OBJC_ASSOCIATION_COPY);
}

- (NSString *)biSid {
    
    return objc_getAssociatedObject(self, &biSidKey);
}

#pragma mark - BI

- (void)recordStartTime {
    
    self.biModel.startPlayTime = round([[NSDate date] timeIntervalSince1970] * 1000);
    
    self.biModel.pauseTime = 0;
    self.biModel.startBufferTime = 0;
    [self.biModel.tmpDurations removeAllObjects];    // 修复banner或直播最后统计的时长为0的问题
}

- (void)trackEventForStartPlay {
    
    [self recordStartTime];
    
    // 在banner模式下播放，则不记录埋点, 容器控制器存在才记录
    if (![self isBannerPlay] && self.containerController) {
        
        NSString *currentVCStr = [NSString stringWithFormat:@"%@", self.containerController];
        BOOL isLive = (self.ve.streamType == STREAM_VR_LIVE);
        
        BOOL isReplay = (!isLive && self.dataParam.position == 0);             // 重新播放和试看需要记录
        if (self.ve.detailModel.isDrama) {
            isReplay = isReplay && self.ve.biEntity.curIsFirstNode;
        }
        BOOL isStart = ![self.vrPlayer.biVC isEqualToString:currentVCStr];     // 从其他页面回来，不记录startplay事件
        
        if (isStart || isReplay) {
            
            DDLogInfo(@"trackEventForStartPlay, video = %@, currentVC = %@", self.ve.videoTitle, currentVCStr);
            self.vrPlayer.biVC = currentVCStr;
            self.vrPlayer.biSid = self.curPlaySid;
            
            [WVRPlayerBIModel trackEventForPlayWithAction:BIActionTypeStartplay startPlayDuration:(self.biModel.startPlayTime - self.biModel.startLoadTime) position:self.getCurrentPosition renderType:self.ve.renderTypeStr defi:self.ve.curDefinition screenType:self.curScreenType ve:self.ve errorCode:0];
        }
    }
}

static NSTimeInterval _lastEndPlayTime = 0;

- (void)trackEventForEndPlay {
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    // 规避iOS10及以下机型杀掉进程时调两次endplay的问题
    if ((now - _lastEndPlayTime) < 0.3) {
        return;
    }
    
    if (self.biModel.startPlayTime <= 0) {      // 没有开始时间，则不记录结束时间
        return;
    }
    
    // 在banner模式下播放，则不记录埋点
    if ([self isBannerPlay]) {
        return;
    }
    
    if ([self.curPlaySid isEqualToString:self.ve.sid] && [self.vrPlayer isPrepared]) {
        
        long time = [self calculateTimeForEndPlay:now];
        
        [WVRPlayerBIModel trackEventForPlayWithAction:BIActionTypeEndplay position:time renderType:self.ve.renderTypeStr defi:self.ve.curDefinition screenType:self.curScreenType ve:self.ve errorCode:self.errorCode];
        
    } else if (self.errorCode != 0) {
        
        long time = [self calculateTimeForEndPlay:now];
        
        [WVRPlayerBIModel trackEventForPlayWithAction:BIActionTypeEndplay position:time renderType:self.ve.renderTypeStr defi:self.ve.curDefinition screenType:self.curScreenType ve:self.ve errorCode:self.errorCode];
        
        self.errorCode = 0;
    }
}

- (long)calculateTimeForEndPlay:(NSTimeInterval)now {
    
    _lastEndPlayTime = now;
    
    self.biModel.endPlayTime = round([[NSDate date] timeIntervalSince1970] * 1000);
    long time = self.biModel.endPlayTime - self.biModel.startPlayTime;
    if (self.biModel.startPlayTime == 0) {
        
        DDLogError(@"error trackEventForEndPlay startPlayTime == 0");
        time = 0;
    }
    if (self.biModel.pauseTime != 0) {
        long tmp = self.biModel.endPlayTime - self.biModel.pauseTime;
        [self.biModel.tmpDurations addObject:@(tmp)];
    }
    if (self.biModel.startBufferTime != 0) {
        long tmp = self.biModel.endPlayTime - self.biModel.startBufferTime;
        [self.biModel.tmpDurations addObject:@(tmp)];
    }
    for (NSNumber *num in self.biModel.tmpDurations) {
        time = time - num.longValue;
    }
    if (time < 0) {
        DDLogError(@"error trackEventForEndPlay time < 0");
        time = 0;
    }
    
    DDLogInfo(@"trackEventForEndPlay time = %ld, video = %@, currentVC = %@", time, self.ve.videoTitle, self.containerController);
    
    [self.biModel.tmpDurations removeAllObjects];
    
    return time;
}

- (void)trackEventForPause {

    if (![self.vrPlayer isPrepared] || self.isOnDestroy || self.isPauseStatus) { return; }

    self.biModel.pauseTime = round([[NSDate date] timeIntervalSince1970] * 1000);
//    [WVRPlayerBIModel trackEventForPlayWithAction:BIActionTypePause position:self.getCurrentPosition renderType:self.ve.renderTypeStr defi:self.ve.curDefinition screenType:self.curScreenType ve:self.ve];
}

- (void)trackEventForContinue {

    if (![self.vrPlayer isPrepared] || self.isOnDestroy || self.isPauseStatus) { return; }
    
    if (self.biModel.pauseTime == 0) { return; }
    
    self.biModel.resumeTime = round([[NSDate date] timeIntervalSince1970] * 1000);
    long time = self.biModel.resumeTime - self.biModel.pauseTime;
    [self.biModel.tmpDurations addObject:@(time)];
    self.biModel.pauseTime = 0;

//    [WVRPlayerBIModel trackEventForPlayWithAction:BIActionTypeContinue position:time renderType:self.ve.renderTypeStr defi:self.ve.curDefinition screenType:self.curScreenType ve:self.ve];
}

- (void)trackEventForStartbuffer {

    if (![self.vrPlayer isPrepared] || self.isOnDestroy) { return; }
    
    self.biModel.startBufferTime = round([[NSDate date] timeIntervalSince1970] * 1000);
//    [WVRPlayerBIModel trackEventForPlayWithAction:BIActionTypeStartbuffer position:self.getCurrentPosition renderType:self.ve.renderTypeStr defi:self.ve.curDefinition screenType:self.curScreenType ve:self.ve];
}

- (void)trackEventForEndbuffer {

    if (![self.vrPlayer isPrepared] || self.isOnDestroy) { return; }

    if (self.biModel.startBufferTime == 0) { return; }
    
    self.biModel.endBufferTime = round([[NSDate date] timeIntervalSince1970] * 1000);
    long time = self.biModel.endBufferTime - self.biModel.startBufferTime;
    [self.biModel.tmpDurations addObject:@(time)];
    self.biModel.startBufferTime = 0;
    
//    [WVRPlayerBIModel trackEventForPlayWithAction:BIActionTypeEndbuffer position:time renderType:self.ve.renderTypeStr defi:self.ve.curDefinition screenType:self.curScreenType ve:self.ve];
}

//- (void)trackEventForLowbitrate {
//
//    if (![self.vrPlayer isPrepared] || self.isOnDestroy) { return; }
//
//    [WVRPlayerBIModel trackEventForPlayWithAction:BIActionTypeLowbitrate position:self.getCurrentPosition renderType:self.ve.renderTypeStr defi:self.ve.curDefinition screenType:self.curScreenType ve:self.ve];
//}

// BI预留
- (int)curScreenType {
    
    float maxLen = MAX(self.containerView.width, self.containerView.height);
    float len = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    if (maxLen >= len) {
        return 1;
    }
    return self.biModel.screenType;
}

- (BOOL)isBannerPlay {
    
    float screenMinWidth = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    float viewMaxLength = MAX(self.containerView.width, self.containerView.height);
    
    // 在banner模式下播放，则不记录埋点
    if (viewMaxLength < screenMinWidth) {
        return YES;
    }
    return NO;
}

@end
