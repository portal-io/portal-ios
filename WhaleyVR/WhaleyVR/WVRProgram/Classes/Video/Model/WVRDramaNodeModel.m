//
//  WVRDramaNodeModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/14.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧节点信息

#import "WVRDramaNodeModel.h"

@interface WVRDramaNodeModel () {
    
    NSString *_renderType;
    NSString *_definitionForPlayURL;
}

@end


@implementation WVRDramaNodeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"mediaDtos" : [WVRMediaDto class] };
}

#pragma mark - getter

- (NSString *)playUrl {
    
    // 蘑菇源的链接优先
    NSString *tmpUrl = nil;
    NSArray<WVRMediaDto *> *mediaDtos = self.mediaDtos;
    
    for (WVRMediaDto *model in mediaDtos) {
        if ([model.source isEqualToString:@"Public"] && model.playUrl.length > 0) {
            tmpUrl = model.playUrl;
            _renderType = model.renderType;
            _definitionForPlayURL = [model curDefinition];
            break;
        }
    }
    
    if (nil == tmpUrl) {
        for (WVRMediaDto *model in mediaDtos) {
            if ([model.source isEqualToString:@"vr"] && model.playUrl.length > 0) {
                tmpUrl = model.playUrl;
                _renderType = model.renderType;
                _definitionForPlayURL = [model curDefinition];
                break;
            }
        }
    }
    
    if (nil == tmpUrl) {
        tmpUrl = mediaDtos.firstObject.playUrl;
        _renderType = mediaDtos.firstObject.renderType;
        _definitionForPlayURL = [mediaDtos.firstObject curDefinition];
    }
    
    return tmpUrl;
}

- (NSString *)definitionForPlayURL {
    
    if (_definitionForPlayURL.length < 1) {
        [self playUrl];
    }
    return _definitionForPlayURL;
}

- (NSString *)renderTypeForPlayURL {
    
    if (_renderType.length < 1) {
        [self playUrl];
    }
    return _renderType;
}

@end
