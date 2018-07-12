//
//  WVRInteractiveDramaModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/9.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧详情 Model

#import "WVRInteractiveDramaModel.h"

@implementation WVRDramaDetailDataReformer

- (id)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = data[@"data"];
    
    WVRInteractiveDramaModel *businessModel = [WVRInteractiveDramaModel yy_modelWithDictionary:businessDictionary];
    
    int i = 0;
    for (WVRDramaNodeModel *node in businessModel.nodes) {      // 先在这里把所需的图片先获取一遍
        
        // 做延时操作，防止同时开大量线程下载图片
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!node) { return; }
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:node.smallPic] options:kNilOptions progress:nil completed:nil];
        });
        
        i ++;
    }
    
    return businessModel;
}

@end


@interface WVRInteractiveDramaModel () {
    NSString *_definitionForPlayURL;
}

@end


@implementation WVRInteractiveDramaModel
@synthesize renderType = _renderType;

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"descriptionStr" : @"description", @"Id" : @"id" };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"mediaDtos" : [WVRMediaDto class], @"contentPackageQueryDtos" : [WVRContentPackageQueryDto class], @"nodes": [WVRDramaNodeModel class] };
}

- (int)isFollow {
    
    return self.contentProvider.isFollow;
}

- (long)fansCount {
    
    return self.contentProvider.fansCount;
}

- (NSString *)cpCode {
    
    return self.contentProvider.cpCode;
}

- (NSString *)headPic {
    
    return self.contentProvider.headPic;
}

- (NSString *)title {
    
    return self.displayName;
}

/// 这里name表示发布者的name
- (NSString *)name {
    
    return self.contentProvider.name;
}

- (NSString *)introduction {
    
    return self.descriptionStr;
}

- (NSString *)playCount {
    
    return [NSString stringWithFormat:@"%ld", self.stat.playCount];
}

- (NSString *)definitionForPlayURL {
    
    if (_definitionForPlayURL.length < 1) {
        [self playUrl];
    }
    return _definitionForPlayURL;
}

- (NSString *)playUrl {
    
    // 蘑菇源的链接优先
    NSString *tmpUrl = nil;
    NSArray<WVRMediaDto *> *mediaDtos = self.startNode.mediaDtos;
    
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

@end


@implementation WVRDramaContentPrivider

@end
