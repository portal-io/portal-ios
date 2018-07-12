//
//  WVRProgramBIModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRProgramBIModel.h"
#import "WVRTrackEventMapping.h"

@implementation WVRProgramBIModel

static NSMutableDictionary *kProgramBIBrowseTimeDic = nil;

NSMutableDictionary * getProgramBIBrowseTimeDic() {
    
    if (kProgramBIBrowseTimeDic == nil) {
        kProgramBIBrowseTimeDic = [NSMutableDictionary dictionary];
    }
    
    return kProgramBIBrowseTimeDic;
}

//+ (void)trackEventForTopicWithAction:(BITopicActionType)action topicId:(NSString *)topicId topicName:(NSString *)topicName videoSid:(NSString *)videoSid videoName:(NSString *)videoName index:(NSInteger)index isChargeable:(BOOL)isChargeable isProgramSet:(BOOL)isProgramSet {
//
//    if (topicId.length < 1) {
//        DDLogError(@"error: trackEventForTopicWithAction topicId == nil");
//        return;
//    }
//
//    WVRBIModel *model = [[WVRBIModel alloc] init];
//
//    NSString *currentPageId = @"topic";
//    if (isChargeable) {
//        currentPageId = isProgramSet ? @"programSet" : @"programPackage";
//    }
//
//    model.logInfo.currentPageId = currentPageId;
//    model.logInfo.nextPageId = @"play";
//    model.logInfo.eventId = @"onClick_view";
//
//    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
//    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
//
//    currentPageProp[@"pageId"] = topicId;
//    currentPageProp[@"pageName"] = topicName;
//    currentPageProp[@"videoSid"] = videoSid;
//    currentPageProp[@"videoName"] = videoName;
//    currentPageProp[@"isChargeable"] = isChargeable ? @"1" : @"0";
//
//    switch (action) {
//            case BITopicActionTypeBrowse: {
//
//                model.logInfo.eventId = @"browse_view";
//                model.logInfo.nextPageId = model.logInfo.currentPageId;
//
//                NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
//                [getProgramBIBrowseTimeDic() setValue:@(timeInterval) forKey:topicId];
//            }
//            break;
//
//            case BITopicActionTypeItemPlay: {
//
//                eventProp[@"locationIndex"] = [NSString stringWithFormat:@"%d", (int)index];
//            }
//            break;
//
//            case BITopicActionTypeListPlay: {
//
//                eventProp[@"locationIndex"] = [NSString stringWithFormat:@"%d", (int)index];
//            }
//            break;
//
//        default:
//            break;
//    }
//
//    model.logInfo.eventProp = eventProp;
//    model.logInfo.currentPageProp = currentPageProp;
//
//    [model saveToSQLite];
//}

+ (void)trackEventForDetailWithAction:(BIDetailActionType)action sid:(NSString *)sid name:(NSString *)name {
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    
    model.logInfo.currentPageId = @"videoDetails";
    if (action == BIDetailActionTypeReserveLive || action == BIDetailActionTypeBrowseLivePrevue) {
        model.logInfo.currentPageId = @"livePrevue";
    } else if (action == BIDetailActionTypeBrowseLivePlay) {
        model.logInfo.currentPageId = @"liveDetails";
    } else if (action == BIDetailActionTypeCollectionDrama) {
        model.logInfo.currentPageId = @"dramaDetails";
    }
    
    model.logInfo.eventId = @"browse_view";
    model.logInfo.nextPageId = model.logInfo.currentPageId;
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    currentPageProp[@"videoSid"] = sid;
    currentPageProp[@"videoName"] = name;
    
    switch (action) {
            case BIDetailActionTypeBrowseVR: {
                
                NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
                [getProgramBIBrowseTimeDic() setValue:@(timeInterval) forKey:sid];
            }
            break;
            
            case BIDetailActionTypeDownloadVR: {
                
                model.logInfo.eventId = @"download_click";
            }
            break;
            
            case BIDetailActionTypeCollectionDrama:
            case BIDetailActionTypeCollectionVR: {
                
                model.logInfo.eventId = @"collection_click";
            }
            break;
            
        case BIDetailActionTypeBrowseLivePrevue:
        case BIDetailActionTypeBrowseLivePlay: {
            
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
            [getProgramBIBrowseTimeDic() setValue:@(timeInterval) forKey:sid];
        }
            break;
            
            case BIDetailActionTypeReserveLive: {
                
                model.logInfo.eventId = @"prevue_click";
            }
            break;
            
        default:
            break;
    }
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    [model saveToSQLite];
}

+ (void)recommendTabSelect:(kTabBarIndex)selectedIndex {
    
    switch (selectedIndex) {
        case kRecommendTabBarIndex:
            [WVRTrackEventMapping trackEvent:@"home" flag:@"recommendation"];
            break;
        case kLiveTabBarIndex:
            [WVRTrackEventMapping trackEvent:@"home" flag:@"live"];
            break;
//        case kLauncherTabBarIndex:
//            [WVRTrackEventMapping trackEvent:@"home" flag:@"launcher"];
//            break;
        case kFindTabBarIndex:
            [WVRTrackEventMapping trackEvent:@"home" flag:@"discovery"];
            break;
        case kAccountTabBarIndex:
            [WVRTrackEventMapping trackEvent:@"home" flag:@"me"];
            break;
            
        default:
            DDLogError(@"recommendTabSelect： 未预料的事件");
            break;
    }
}

/// 浏览页面
+ (void)trackEventForBrowsePage:(WVRProgramBIModel *)biModel {
    
    if (biModel.biPageId.length == 0) {
        DDLogError(@"error: trackEventForBrowsePage biModel.biPageId == nil");
        return;
    }
    
    DDLogInfo(@"trackEventForBrowsePage: pageId = %@, sid = %@", biModel.currentPageId, biModel.biPageId);
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = biModel.currentPageId;
    
    model.logInfo.eventId = @"browse_view";
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    if (biModel.isProgram) {
        
        currentPageProp[@"videoSid"] = biModel.biPageId;
        currentPageProp[@"videoName"] = biModel.biPageName;
        currentPageProp[@"videoFormat"] = biModel.videoFormat;
        currentPageProp[@"contentType"] = biModel.contentType;
    } else {
        
        currentPageProp[@"pageId"] = biModel.biPageId;
        currentPageProp[@"pageName"] = biModel.biPageName;
    }
    
    currentPageProp[@"isChargeable"] = [NSString stringWithFormat:@"%d", biModel.isChargeable];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    [getProgramBIBrowseTimeDic() setValue:@(timeInterval) forKey:biModel.biPageId];
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    model.logInfo.nextPageId = biModel.currentPageId;
    
    [model saveToSQLite];
}

static NSTimeInterval _lastBrowseEndTime = 0;

/// 浏览结束，记录时长
+ (void)trackEventForBrowseEnd:(WVRProgramBIModel *)biModel {
    
    if (biModel.biPageId.length == 0) {
        DDLogError(@"BIError: trackEventForBrowseEnd biModel.biPageId == nil");
        return;
    }
    
    if (![getProgramBIBrowseTimeDic() valueForKey:biModel.biPageId]) {
        return;
    }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    // 规避iOS10及以下机型杀掉进程时调两次BrowseEnd的问题
    if ((now - _lastBrowseEndTime) < 0.3) {
        return;
    }
    
    _lastBrowseEndTime = now;
    
    DDLogInfo(@"trackEventForBrowseEnd: pageId = %@, sid = %@", biModel.currentPageId, biModel.biPageId);
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = biModel.currentPageId;
    
    model.logInfo.eventId = @"browse_duration";
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    if (biModel.isProgram) {
        
        currentPageProp[@"videoSid"] = biModel.biPageId;
        currentPageProp[@"videoName"] = biModel.biPageName;
        currentPageProp[@"videoFormat"] = biModel.videoFormat;
        currentPageProp[@"contentType"] = biModel.contentType;
    } else {
        
        currentPageProp[@"pageId"] = biModel.biPageId;
        currentPageProp[@"pageName"] = biModel.biPageName;
    }
    
    currentPageProp[@"isChargeable"] = [NSString stringWithFormat:@"%d", biModel.isChargeable];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval browseTime = [[getProgramBIBrowseTimeDic() valueForKey:biModel.biPageId] doubleValue];
    long duration = round((timeInterval - browseTime) * 1000);   // 后端需要毫秒
    
    if (browseTime == 0) {
        DDLogError(@"BIError: browseTime == 0");
    }
    
    eventProp[@"actionType"] = @"endbrowse";
    eventProp[@"duration"] = [NSString stringWithFormat:@"%ld", duration];
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    [model saveToSQLite];
}

/// 记录节目-专题分享事件
+ (void)trackEventForShare:(WVRProgramBIModel *)biModel {
    
    if (biModel.biPageId.length == 0) {
        DDLogError(@"error: trackEventForShare biModel.biPageId == nil");
        return;
    }
    if (biModel.currentPageId.length == 0) {
        DDLogError(@"error: trackEventForShare biModel.currentPageId == nil");
        return;
    }
    
    DDLogInfo(@"trackEventForShare: pageId = %@, sid = %@", biModel.currentPageId, biModel.biPageId);
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = biModel.currentPageId;
    
    model.logInfo.eventId = @"share";
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    if (biModel.isProgram) {
        
        currentPageProp[@"videoSid"] = biModel.biPageId;
        currentPageProp[@"videoName"] = biModel.biPageName;
    } else {
        
        currentPageProp[@"pageId"] = biModel.biPageId;
        currentPageProp[@"pageName"] = biModel.biPageName;
    }
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    model.logInfo.nextPageId = biModel.currentPageId;
    
    [model saveToSQLite];
}

/// 访问路径相关（点击跳转的时候埋点）
+ (void)trackEventForJump:(WVRProgramBIModel *)biModel {
    
    if (biModel.biPageId.length == 0) {
        DDLogError(@"error: trackEventForJump biModel.biPageId == nil");
        return;
    }
    if (biModel.nextPageId.length == 0) {
        DDLogError(@"error: trackEventForJump biModel.nextPageId == nil");
        return;
    }
    
    DDLogInfo(@"trackEventForJump: sid = %@, name = %@", biModel.nextPageCode, biModel.nextPageName);
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = biModel.currentPageId;
    
    model.logInfo.eventId = @"onClick_view";
    model.logInfo.nextPageId = biModel.nextPageId;
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    currentPageProp[@"pageId"] = biModel.biPageId;
    currentPageProp[@"pageName"] = biModel.biPageName;
    
    eventProp[@"eventID"] = biModel.nextPageCode;
    eventProp[@"eventName"] = biModel.nextPageName;
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    [model saveToSQLite];
}

+ (void)trackEventForDramaSelect:(WVRProgramBIModel *)biModel {
    
    if (biModel.biPageId.length == 0) {
        DDLogError(@"error: trackEventForDramaSelect biModel.biPageId == nil");
        return;
    }
    
    DDLogInfo(@"trackEventForDramaSelect: pageId = %@, sid = %@", biModel.currentPageId, biModel.biPageId);
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = @"play";
    
    model.logInfo.eventId = @"dynamicSelected";
    model.logInfo.nextPageId = @"play";
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    currentPageProp[@"videoSid"] = biModel.biPageId;
    currentPageProp[@"videoName"] = biModel.biPageName;
    currentPageProp[@"currentDramaId"] = biModel.currentDramaId;
    currentPageProp[@"currentDramaTitle"] = biModel.currentDramaTitle;
    
    eventProp[@"dramaId"] = biModel.dramaId;
    eventProp[@"dramaTitle"] = biModel.dramaTitle;
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    [model saveToSQLite];
}

+ (void)trackEventForInteraction:(BIInteractionType)interactionType biModel:(WVRProgramBIModel *)biModel {
    
    if (biModel.biPageId.length == 0) {
        DDLogError(@"error: trackEventForDramaSelect biModel.biPageId == nil");
        return;
    }
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = @"liveDetails";
    
    DDLogInfo(@"trackEventForDramaSelect: pageId = %@, sid = %@", model.logInfo.currentPageId, biModel.biPageId);
    
    switch (interactionType) {
        case BIInteractionTypeGift:
            model.logInfo.eventId = @"gift";
            break;
            
        case BIInteractionTypeDanmu:
            model.logInfo.eventId = @"danmu";
            break;
    }
    model.logInfo.nextPageId = @"liveDetails";
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    currentPageProp[@"videoSid"] = biModel.biPageId;
    currentPageProp[@"videoName"] = biModel.biPageName;
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    [model saveToSQLite];
}

+ (void)trackEventForAD:(WVRProgramBIModel *)biModel {
    
    if (biModel.biPageId.length == 0) {
        DDLogError(@"error: trackEventForDramaSelect biModel.biPageId == nil");
        return;
    }
    
    DDLogInfo(@"trackEventForDramaSelect: pageId = ad, sid = %@", biModel.biPageId);
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = @"ad";
    
    model.logInfo.eventId = biModel.otherParams[@"eventId"];
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    currentPageProp[@"pageType"] = biModel.otherParams[@"pageType"];
    currentPageProp[@"showTpye"] = biModel.otherParams[@"showTpye"];
    
    eventProp[@"eventID"] = biModel.biPageId;
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    [model saveToSQLite];
}

@end
