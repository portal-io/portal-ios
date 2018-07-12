//
//  WVRBaseModel.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBaseModel.h"

@implementation WVRBaseModel
@synthesize linkType_ = _linkType_;
@synthesize jumpType_ = _jumpType_;

- (NSString *)recommendAreaCode {
    
    return [_recommendAreaCodes firstObject];
}

- (WVRSectionModelType)parseSectionTypeWithHttpRecAreaType:(NSString *)areaType {
    
    WVRSectionModelType type = WVRSectionModelTypeDefault;
    if ([areaType isEqualToString:@"1"]) {
        type = WVRSectionModelTypeDefault;
    } else if ([areaType isEqualToString:@"2"]) {
        type = WVRSectionModelTypeBanner;
    } else if ([areaType isEqualToString:@"3"]) {
        type = WVRSectionModelTypeAD;
    } else if ([areaType isEqualToString:@"4"]) {
        type = WVRSectionModelTypeBrand;
    } else if ([areaType isEqualToString:@"5"]) {
        type = WVRSectionModelTypeHot;
    } else if ([areaType isEqualToString:@"6"]) {
        type = WVRSectionModelTypeTag;
    } else if ([areaType isEqualToString:@"7"]) {
        type = WVRSectionModelTypeShow;
    } else if ([areaType isEqualToString:@"8"]) {
        type = WVRSectionModelTypeTV;
    } else if([areaType isEqualToString:@"11"]) {
        type = WVRSectionModelTypeSinglePlay;
    }
    return type;
}

#pragma mark - getter

- (NSString *)subTitle {
    
    return _subTitle ?: @"";
}

- (WVRLinkType)linkType_ {
    
    if (!_linkType_) {
        
        NSString *type = self.linkArrangeType;
        
        if ([type isEqualToString:LINKARRANGETYPE_DRAMA_PROGRAM] || [self.programType isEqualToString:PROGRAMTYPE_DRAMA]) {     // 互动剧
            
            _linkType_ = WVRLinkTypeDarma;
        }
        else if ([type isEqualToString:LINKARRANGETYPE_INFORMATION]) {                // 资讯
            
            _linkType_ = WVRLinkTypeNews;
            
        } else if ([type isEqualToString:LINKARRANGETYPE_H5_INNER]) {            // H5内页
            
            _linkType_ = WVRLinkTypeH5;
            
        } else if ([type isEqualToString:LINKARRANGETYPE_H5_OUTER]) {            // H5外页
            
            _linkType_ = WVRLinkTypeH5Outer;
            
        } else if ([type isEqualToString:LINKARRANGETYPE_PROGRAM]) {            // 单个节目
            
            if ([self.videoType isEqualToString:VIDEO_TYPE_3D]) {               // 3D电影
                
                _linkType_ = WVRLinkType3DMovie;
                
            } else if ([self.videoType isEqualToString:VIDEO_TYPE_VR]) {        // VR全景
                
                _linkType_ = WVRLinkTypeVR;
            }
        } else if ([type isEqualToString:LINKARRANGETYPE_LIVE]) {               // 直播
            
            _linkType_ = WVRLinkTypeLive;
            
        } else if ([type isEqualToString:LINKARRANGETYPE_MANUAL_ARRANGE]) {      // 手动编排（专题）
            
            _linkType_ = WVRLinkTypeTopic;
        }
//        else if ([type isEqualToString:LINKARRANGETYPE_RECOMMENDPAGE]) {       // tab跳转
//            
//            _linkType_ = WVRLinkTypeHome;
//        }
        else if ([type isEqualToString:LINKARRANGETYPE_ARRANGE]) {               // 自动编排（二级列表，无站点树）
            
            _linkType_ = WVRLinkTypeList;
        } else if ([type isEqualToString:LINKARRANGETYPE_MORETVPROGRAM]) {       // 电视节目
            
            _linkType_ = WVRLinkTypeMoreTV;
        } else if ([type isEqualToString:LINKARRANGETYPE_MOREMOVIEPROGRAM]) {    // 电视猫电影
            
            _linkType_ = WVRLinkTypeMoreMovie;
        } else if ([type isEqualToString:LINKARRANGETYPE_PLAY]) {                // 直接播放
            
            _linkType_ = WVRLinkTypePlay;
        } else if ([type isEqualToString:LINKARRANGETYPE_RECOMMENDPAGE]) {              // 混排模式
            
            if ([self.recommendPageType isEqualToString:RECOMMENDPAGETYPE_MIX]) {
                _linkType_ = WVRLinkTypeMix;
            } else if ([self.recommendPageType isEqualToString:RECOMMENDPAGETYPE_PAGE]) {
                _linkType_ = WVRLinkTypePage;
            } else if ([self.recommendPageType isEqualToString:RECOMMENDPAGETYPE_TITLE]) {
                _linkType_ = WVRLinkTypeTitle;
            }
        } else {
            
            NSLog(@"linkType Error: 未识别的类型: %@", type);
            _linkType_ = 1;
        }
    }
    
    return _linkType_;
}

- (WVRPageJumpType)jumpType_ {
    
    if (!_jumpType_) {
        
        NSString *type = self.linkArrangeValue;
        
        if ([type isEqualToString:JUMP_TYPE_RECOMMEND]) {
            
            _jumpType_ = WVRPageJumpTypeRecommend;
            
        } else if ([type isEqualToString:JUMP_TYPE_CHANNEL_VR]) {
            
            _jumpType_ = WVRPageJumpTypeChannelVR;
            
        } else if ([type isEqualToString:JUMP_TYPE_CHANNEL_3D]) {
            
            _jumpType_ = WVRPageJumpTypeChannel3D;
            
        } else if ([type isEqualToString:JUMP_TYPE_LIVE]) {
            
            _jumpType_ = WVRPageJumpTypeLive;
            
        } else if ([type isEqualToString:JUMP_TYPE_LIVE_REVIEW]) {
            
            _jumpType_ = WVRPageJumpTypeLiveReview;
            
        } else {
            NSLog(@"Error: 未识别的跳转类型");
            _jumpType_ = 0;
        }
    }
    
    return _jumpType_;
}

- (WVRModelVideoType)videoType_ {
    
    if ([self.videoType isEqualToString:VIDEO_TYPE_3D]) {
        return WVRModelVideoType3D;
    } else if ([self.videoType isEqualToString:VIDEO_TYPE_VR]) {
        return WVRModelVideoTypeVR;
    } else if ([self.videoType isEqualToString:VIDEO_TYPE_MORETV_TV]) {
        return WVRModelVideoTypeMoreTVTV;
    } else if ([self.videoType isEqualToString:VIDEO_TYPE_MORETV_MOVIE]) {
        return WVRModelVideoTypeMoreTVMovie;
    }
    
    DebugLog(@"error can not parse videoType");
    return WVRModelVideoType3D;
}

@end

