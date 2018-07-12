//
//  WVRItemModel.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRItemModel.h"

@implementation WVRItemModel
@synthesize detailModel = _detailModel;

+ (NSArray *)modelPropertyBlacklist {
    
    return @[ @"palyMediaModels", @"HDPlayerUrl", @"SDPlayerUrl", @"STPlayerUrl", @"playerUrls", @"arrangeElements", @"packageItemCharged", @"jumpParamsDic", ];
}

#pragma mark - external func

//- (BOOL)isFree {
//    
//    if (!self.isChargeable) {
//        return YES;
//    }
//    if (self.couponDto.price > 0 || [[self contentPackageQueryDto] price] > 0) {
//        return NO;
//    }
//    return YES;
//}

#pragma mark - getter

- (long)price {
    if ([self contentPackageQueryDto] && [[self contentPackageQueryDto] packageType] == WVRPackageTypeProgramSet) {      // 只能购买合集，不能单独购买节目
        return [[self contentPackageQueryDto] price];
    }
    
    return [self.couponDto price];
}

- (long)totalTime { return 0; }

- (NSString *)infUrl {
    
    if (_infUrl.length > 0) { return _infUrl; }
    
    return self.linkArrangeValue;       // 兼容H5内页和资讯
}

- (NSString *)infTitle {
    
    if (_infTitle.length > 0) { return _infTitle; }
    
    return self.name;       // 兼容H5内页和资讯
}

- (NSString *)sid {
    if (self.linkArrangeValue) {
        return self.linkArrangeValue;
    }
    if (self.code) {
        return self.code;
    }
    return nil;
}

- (NSString *)title {
    
    return self.name;
}

- (NSString *)address {
    
    return @"";
}

- (WVRContentPackageQueryDto *)contentPackageQueryDto {
    
    return self.contentPackageQueryDtos.firstObject;
}

- (NSString *)definitionForPlayURL {
    
    NSLog(@"You must override %s in a subclass", __func__);
    
    return @"";
}

- (BOOL)isFootball {
    
    NSLog(@"You must override %s in a subclass", __func__);
    
    return NO;
}

- (BOOL)isProgramSet {
    
    WVRContentPackageQueryDto *dto = [self.contentPackageQueryDtos firstObject];
    
    return [dto.type isEqualToString:@"0"];
}

- (WVRDetailModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [[WVRDetailModel alloc] initWithDetailTypeStr:[self detailTypeStr]];
    }
    return _detailModel;
}

// MARK: - pravite

- (NSString *)detailTypeStr {
    // 考虑到ItemModel在列表中的情况
    
    if (self.linkArrangeType) {
        if ([self.linkArrangeType isEqualToString:LINKARRANGETYPE_LIVE]) {
            
            if ([self.type isEqualToString:CONTENTTYPE_LIVE_FOOTBALL]) {
                return ProgramDetailTypeLiveFootball;
            }
            if ([self.contentType isEqualToString:CONTENTTYPE_LIVE_FOOTBALL]) {
                return ProgramDetailTypeLiveFootball;
            }
            return ProgramDetailTypeLive;
        }
        else if ([self.linkArrangeType isEqualToString:LINKARRANGETYPE_MORETVPROGRAM]) {
            return ProgramDetailTypeTVMore2DTV;
        }
        else if ([self.linkArrangeType isEqualToString:LINKARRANGETYPE_MOREMOVIEPROGRAM]) {
            return ProgramDetailTypeTVMore2DMovie;
        }
        else if ([self.linkArrangeType isEqualToString:LINKARRANGETYPE_PROGRAM]) {        // 节目
            
            // 目前节目只分为全景和华数电影、通过videoType字段区分，没有此字段则默认为全景视频
            if ([self.videoType isEqualToString:VIDEO_TYPE_3D]) {
                
                return ProgramDetailTypeWasu3DMovie;
            } else {
                
                if ([self.type isEqualToString:PROGRAMTYPE_FOOTBALL]) {
                    
                    return ProgramDetailTypeVRFootball;
                }
                if ([self.contentType isEqualToString:PROGRAMTYPE_FOOTBALL]) {
                    
                    return ProgramDetailTypeVRFootball;
                }
                return ProgramDetailTypeVR;
            }
            
        } else if ([self.linkArrangeType isEqualToString:LINKARRANGETYPE_DRAMA_PROGRAM]) {
            return ProgramDetailTypeDrama;
        }
    }
    // 详情数据类型匹配
    if ([self.programType isEqualToString:PROGRAMTYPE_LIVE]) {
        
        if ([self.type isEqualToString:CONTENTTYPE_LIVE_FOOTBALL]) {
            return ProgramDetailTypeLiveFootball;
        }
        if ([self.contentType isEqualToString:CONTENTTYPE_LIVE_FOOTBALL]) {
            return ProgramDetailTypeLiveFootball;
        }
        return ProgramDetailTypeLive;
    }
    else if ([self.programType isEqualToString:PROGRAMTYPE_RECORDED]) {
        
        self.linkArrangeType = LINKARRANGETYPE_PROGRAM;
        if ([self.videoType isEqualToString:VIDEO_TYPE_3D]) {
            
            return ProgramDetailTypeWasu3DMovie;
        } else if ([self.videoType isEqualToString:VIDEO_TYPE_MORETV_TV]) {
            
            return ProgramDetailTypeTVMore2DTV;
        }
        else if ([self.videoType isEqualToString:VIDEO_TYPE_MORETV_MOVIE]) {
            
            return ProgramDetailTypeTVMore2DMovie;
        }
        else {
            
            if ([self.type isEqualToString:PROGRAMTYPE_FOOTBALL]) {
                
                return ProgramDetailTypeVRFootball;
            }
            if ([self.contentType isEqualToString:PROGRAMTYPE_FOOTBALL]) {
                
                return ProgramDetailTypeVRFootball;
            }
            return ProgramDetailTypeVR;
        }
    }
    else if ([self.programType isEqualToString:PROGRAMTYPE_MORETV_TV]) {
        
        return ProgramDetailTypeTVMore2DTV;
    }
    else if ([self.programType isEqualToString:PROGRAMTYPE_MORETV_MOVIE]) {
        
        return ProgramDetailTypeTVMore2DMovie;
    }
    else if ([self.programType isEqualToString:@"moretv"]) {
        NSString * prefixStr = [self.linkArrangeValue substringWithRange:NSMakeRange(0, 2)];
        if ([prefixStr isEqualToString:@"mt"]) {
            return ProgramDetailTypeTVMore2DTV;
        } else {
            return ProgramDetailTypeTVMore2DMovie;
        }
    }
    else if ([self.programType isEqualToString:PROGRAMTYPE_DRAMA]) {
        
        return ProgramDetailTypeDrama;
    }
    
    DDLogError(@"error：类型解析失败，请检查是否请求了详情接口，或者后台数据填写有误，或者新增了类型前端未兼容");
    
    return @"";
}

@end
