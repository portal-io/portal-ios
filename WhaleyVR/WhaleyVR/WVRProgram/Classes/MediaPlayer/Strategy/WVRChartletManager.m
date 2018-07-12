//
//  WVRChartletManager.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/21.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 协助控制器管理播放器的背景图和底图

#import "WVRChartletManager.h"
#import "WVRVideoEntity.h"
#import "WVRPlayerHelper.h"
#import "WVRItemModel.h"

@interface WVRChartletManager () {
    
    BOOL _isVipBackground;
}

@property (nonatomic, strong) UIImageView *bottomImgV;   // for player bottom image
@property (nonatomic, assign) float bottomViewScale;

@property (nonatomic, strong) UIImageView *footballBgImgV;   // for player bottom image

@property (nonatomic, assign) BOOL isCameraStandVIP;

@end


@implementation WVRChartletManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _bottomImgV = [[UIImageView alloc] init];
        _footballBgImgV = [[UIImageView alloc] init];
    }
    return self;
}

- (void)createPlayerBottomImageWithVideoEntity:(WVRVideoEntity *)ve player:(WVRPlayerHelper *)player detailModel:(WVRItemModel *)detailModel {
    
    // 同一视频源请求一次即可
    if ([player.lastSid isEqualToString:player.curPlaySid]) {
        if (_bottomImgV.image) {
            
            [player genBottomView:_bottomViewScale Image:_bottomImgV.image];
            
            return;
        }
    }
    
    [player genBottomView:1 Image:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)]];
    
    if ([detailModel.programType isEqualToString:PROGRAMTYPE_DRAMA]) {
        
        __block WVRBottomImageModel *model = [[WVRBottomImageModel alloc] init];
        model.scale = detailModel.radius;
        model.picUrl = detailModel.centerPic;
        
        self.bottomViewScale = model.scale;
        
        [self.bottomImgV wvr_setImageWithURL:[NSURL URLWithUTF8String:model.picUrl] placeholderImage:nil options:kNilOptions progress:nil completed:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
            
            [player genBottomView:model.scale Image:image];
        }];
        
    } else {
        
        kWeakSelf(self);
        [ve requestForPlayerBottomImage:^(WVRBottomImageModel *model) {
            
            weakself.bottomViewScale = model.scale;
            
            [weakself.bottomImgV wvr_setImageWithURL:[NSURL URLWithUTF8String:model.picUrl] placeholderImage:nil options:kNilOptions progress:nil completed:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
                
                [player genBottomView:model.scale Image:image];
            }];
        }];
    }
}

- (void)createPlayerFootballBackgroundImageWithVIP:(BOOL)isVIP ve:(WVRVideoEntity *)ve player:(WVRPlayerHelper *)player detailModel:(WVRItemModel *)detailModel {
    
    if (!ve.isFootball) {
        
        [player setBackImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)]];
        return;
    }
    
    // 同一视频源请求一次即可
    if ([player.lastSid isEqualToString:player.curPlaySid] && (_isVipBackground == isVIP)) {
        if (_footballBgImgV.image) {
            [player setBackImage:_footballBgImgV.image];
            
            return;
        }
    }
    
    _isVipBackground = isVIP;
    [player setBackImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)]];
    
    NSString *picUrl = nil;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if (isVIP) {
        
        if ([detailModel respondsToSelector:@selector(vipPic)]) {
            picUrl = [detailModel performSelector:@selector(vipPic)];
        }
    } else {
        
        if ([detailModel respondsToSelector:@selector(bgPic)]) {
            picUrl = [detailModel performSelector:@selector(bgPic)];
        }
    }
#pragma clang diagnostic pop
    
    if (picUrl.length < 1) { return; }
    
    [self.footballBgImgV wvr_setImageWithURL:[NSURL URLWithUTF8String:picUrl] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [player setBackImage:image];
    }];
}

@end
