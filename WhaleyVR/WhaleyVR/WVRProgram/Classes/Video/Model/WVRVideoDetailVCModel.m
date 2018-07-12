//
//  WVRVideoDetailVCModel.m
//  VRManager
//
//  Created by Snailvr on 16/6/24.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 全景视频/华数3D电影详情页Model

#import "WVRVideoDetailVCModel.h"

@implementation WVRVideoDetailDataReformer

- (id)reformData:(NSDictionary *)data {
    
    NSDictionary *businessDictionary = data[@"data"];
    WVRVideoDetailVCModel *businessModel = [WVRVideoDetailVCModel yy_modelWithDictionary:businessDictionary];
    
    return businessModel;
}

@end


@interface WVRVideoDetailVCModel () {
    NSString *_definitionForPlayURL;
}

@end


@implementation WVRVideoDetailVCModel
@synthesize renderType = _renderType;

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"descriptionStr" : @"description", @"Id" : @"id" };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"downloadDtos" : [WVRDownloadDto class], @"mediaDtos" : [WVRMediaDto class], @"contentPackageQueryDtos" : [WVRContentPackageQueryDto class] };
}

#pragma mark - getter 

- (NSString *)downloadUrl {
    
    return self.downloadDtos.firstObject.downloadUrl;
}

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

- (NSString *)renderType {
    
    if (_renderType.length < 1) {
        [self playUrl];
    }
    
    return _renderType;
}

- (NSInteger)viewCount {
    
    return self.stat.viewCount;
}

- (NSString *)playCount {
    
    return [NSString stringWithFormat:@"%ld", self.stat.playCount];
}

- (NSInteger)playSeconds {
    
    return self.stat.playSeconds;
}

- (NSString *)title {
    
    return self.displayName ?: @"";
}

- (NSString *)introduction {
    
    return self.descriptionStr;
}

- (NSArray *)tags_ {
    
    return [self.tags componentsSeparatedByString:@"-"];
}

- (NSString *)webURL {
    
    return nil;         // 此版本暂时没有H5活动视频页
}

- (NSString *)sid {
    
    return self.code;
}

- (NSArray *)playUrlArray {
    
    // 蘑菇源的链接置顶, 分享链接屏蔽
    NSMutableArray *arr = [NSMutableArray array];
    
    WVRMediaDto *tmpModel = nil;
    for (WVRMediaDto *model in self.mediaDtos) {
        if ([model.source isEqualToString:@"vr"] && model.playUrl.length > 0) {
            
            tmpModel = model;
            [arr addObject:model.playUrl];
            break;
        }
    }
    
    for (WVRMediaDto *model in self.mediaDtos) {
        if ([model.source isEqualToString:@"vr_share"]) {
            continue;
        }
        if (model != tmpModel && model.playUrl.length > 0) {
            [arr addObject:model.playUrl];
        }
    }
    
    return arr;
}

- (BOOL)isFootball {
    
    if ([self.type isEqualToString:@"football"]) {
        return YES;
    }
    if ([self.contentType isEqualToString:@"football"]) {
        return YES;
    }
    return NO;
}

@end


@implementation WVRDownloadDto

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"Id" : @"id" };
}

@end
