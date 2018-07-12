//
//  WVRDetailModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/26.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 清晰快速的分辨当前视频具体类型

#import "WVRDetailModel.h"

@interface WVRDetailModel() {
    NSNumber *_tmpDetailType;
}

@end


@implementation WVRDetailModel

- (instancetype)initWithDetailTypeStr:(NSString *)detailTypeStr {
    self = [super init];
    if (self) {
        [self setDetailTypeStr:detailTypeStr];
    }
    return self;
}

- (void)setDetailTypeStr:(NSString *)detailTypeStr {
    
    _detailTypeStr = detailTypeStr;
}

// MARK: - getter

- (WVRDetailType)detailType {
    if (!_tmpDetailType) {
        if ([self.detailTypeStr isEqualToString:ProgramDetailTypeVR]) {
            _tmpDetailType = @(WVRDetailTypeVR);
        } else if ([self.detailTypeStr isEqualToString:ProgramDetailTypeVRFootball]) {
            _tmpDetailType = @(WVRDetailTypeVRFootball);
        } else if ([self.detailTypeStr isEqualToString:ProgramDetailTypeLive]) {
            _tmpDetailType = @(WVRDetailTypeLive);
        } else if ([self.detailTypeStr isEqualToString:ProgramDetailTypeLiveFootball]) {
            _tmpDetailType = @(WVRDetailTypeLiveFootball);
        } else if ([self.detailTypeStr isEqualToString:ProgramDetailTypeWasu3DMovie]) {
            _tmpDetailType = @(WVRDetailTypeWasu3DMovie);
        } else if ([self.detailTypeStr isEqualToString:ProgramDetailTypeTVMore2DTV]) {
            _tmpDetailType = @(WVRDetailTypeTVMore2DTV);
        } else if ([self.detailTypeStr isEqualToString:ProgramDetailTypeTVMore2DMovie]) {
            _tmpDetailType = @(WVRDetailTypeTVMore2DMovie);
        } else if ([self.detailTypeStr isEqualToString:ProgramDetailTypeDrama]) {
            _tmpDetailType = @(WVRDetailTypeDrama);
        }
    }
    return _tmpDetailType.integerValue;
}

- (BOOL)isVR {
    
    return (self.detailType == WVRDetailTypeVR) || (self.detailType == WVRDetailTypeVRFootball);
}

- (BOOL)isLive {
    
    return (self.detailType == WVRDetailTypeLive) || (self.detailType == WVRDetailTypeLiveFootball);
}

- (BOOL)isDrama {
    
    return (self.detailType == WVRDetailTypeDrama);
}

- (BOOL)isFootball {
    
    return (self.detailType == WVRDetailTypeVRFootball) || (self.detailType == WVRDetailTypeLiveFootball);
}

- (BOOL)isWasu {
    
    return (self.detailType == WVRDetailTypeWasu3DMovie);
}

- (BOOL)isTVMore {
    
    return (self.detailType == WVRDetailTypeTVMore2DMovie) || (self.detailType == WVRDetailTypeTVMore2DTV);
}

- (BOOL)is2D {
    
    return (self.detailType == WVRDetailTypeTVMore2DMovie) || (self.detailType == WVRDetailTypeTVMore2DTV);
}

@end
