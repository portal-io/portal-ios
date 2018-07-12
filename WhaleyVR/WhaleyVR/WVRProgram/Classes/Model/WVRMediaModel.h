//
//  WVRMediaModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/4/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseModel.h"
#import <WhaleyVRPlayer/WVRDataParam.h>

@interface WVRMediaModel : WVRBaseModel

@property (nonatomic, copy) NSString * resolution;

@property (nonatomic, assign) WVRRenderType renderTyper;

@property (nonatomic, copy) NSString * playUrl;

@property (nonatomic, copy) NSString * defiKey;

/// 播放为足球时生效
@property (nonatomic, copy) NSString * cameraStand;

@end
