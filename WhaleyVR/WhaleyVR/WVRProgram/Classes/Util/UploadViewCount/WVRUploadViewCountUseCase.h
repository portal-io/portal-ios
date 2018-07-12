//
//  WVRUploadViewCountUseCase.h
//  WhaleyVR
//
//  Created by Bruce on 2017/9/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRUploadViewCountUseCase : WVRUseCase<WVRUseCaseProtocol>

/// srcCode   节目（直播,资讯）code   必填
@property(nonatomic, copy) NSString *srcCode;

/// programType 节目类型，支持 live（直播）, recorded（视频）, webpage（资讯） 必填
@property(nonatomic, copy) NSString *programType;

/// videoType 视频格式，支持 2d，3d，vr (资讯类型不必填）
@property (nonatomic, copy) NSString *videoType;

/// type：上报类型，支持 view（浏览），play（播放），timelong（时长） 必填
@property (nonatomic, copy) NSString *type;

/// sec：观看时长（可选，类型为timelong时才必须有，单位秒）
@property (nonatomic, copy) NSString *sec;

/// title：标题（可选，webpage类型必填
@property (nonatomic, copy) NSString *title;

- (RACCommand *)requestCmd;

@end
