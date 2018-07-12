//
//  WVRVideoEntityLive.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// VR直播VideoEntity

#import "WVRVideoEntityLive.h"
//#import "WVRLiveDetailModel.h"
#import <SecurityFramework/Security.h>

@implementation WVRVideoEntityLive

- (instancetype)init {
    self = [super init];
    if (self) {
        self.streamType = STREAM_VR_LIVE;
    }
    return self;
}

#pragma mark - getter

- (NSString *)icon {
    
    return _icon ?: @"";
}

- (NSString *)curDefinition {
    
    return self.curUrlModel.definition;
}

- (NSString *)renderTypeStr {
    
    return self.curUrlModel.renderType;
}

#pragma mark - parserURL

- (void)parserPlayUrl:(complationBlock)complation {
    
    NSMutableDictionary<NSString *, NSDictionary<NSString *, WVRPlayUrlModel *> *> *dict = [NSMutableDictionary dictionary];
    
    for (WVRMediaDto *dto in self.mediaDtos) {
        
        NSURL *url = [[self class] playUrlForUrlStr:dto.playUrl isChargeable:self.isChargeable];
        if (!url) { continue; }
        if (!dto.resolution) { continue; }
        
        WVRPlayUrlModel *model = [[WVRPlayUrlModel alloc] init];
        model.url = url;
        model.renderType = dto.renderType;
        model.definition = dto.curDefinition;
        if (self.isFootball) {
            model.cameraStand = dto.source;
        } else {
            model.cameraStand = dto.srcName.length ? dto.srcName : kDefault_Camera_Stand;
        }
        
        NSMutableDictionary *linkDict = nil;
        if ([dict objectForKey:model.cameraStand]) {
            linkDict = (NSMutableDictionary *)[dict objectForKey:model.cameraStand];
        } else {
            linkDict = [NSMutableDictionary dictionary];
        }
        
        linkDict[dto.curDefinition] = model;
        
        if (linkDict.count == 1) {
            dict[model.cameraStand] = linkDict;
        }
    }
    
    self.parserdUrlModelDict = dict;
    
    if (complation) {
        complation();
    }
}

/**
 直播地址解析(裸流)
 
 @param urlStr 源链接地址
 @param isChargeable 是否需要付费
 @return 解析完成的URL对象
 */
+ (NSURL * _Nullable)playUrlForUrlStr:(NSString * _Nonnull)urlStr isChargeable:(BOOL)isChargeable {
    
    if (urlStr.length < 1) { return nil; }
    
    NSString *playUrl = urlStr;
    if (isChargeable) {
        
        Security *secu = [Security getInstance];
        playUrl = [secu Security_StandardDecrypt:playUrl withAlgid:secu.payAlgid];
    }
    
    if (([playUrl hasPrefix:@"rtmp://"] || [playUrl containsString:@".m3u8"]) && [playUrl containsString:@"&flag"]) {
        
        NSArray *tmpArr = [playUrl componentsSeparatedByString:@"&flag"];
        playUrl = [tmpArr firstObject];
    }
    
    NSURL *url = [NSURL URLWithUTF8String:playUrl];
    
    return url;
}

//- (NSURL *)tryNextDefinitionWhenPlayFaild {
//    
//    WVRPlayUrlModel *curModel = self.curUrlModel;
//    DDLogInfo(@"tryNextDefinitionWhenPlayFaild error link: %@", self.curUrlModel.url);
//    
//    NSMutableArray *arr = [NSMutableArray array];
//    for (WVRPlayUrlModel *model in self.parserdUrlModelDict) {
//        if (model != curModel) {
//            [arr addObject:model];
//        }
//    }
//    self.parserdUrlModelDict = arr;
//    
//    self.curUrlModel = [self playUrlModelForDefinition:[self checkNextDefinition]];
//    DDLogInfo(@"tryNextDefinitionWhenPlayFaild next link: %@", self.curUrlModel.url);
//    
//    return self.curUrlModel.url;
//}

@end
