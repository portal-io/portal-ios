//
//  WVRVideoEntity.h
//  WhaleyVR
//
//  Created by 曹江龙 on 16/9/18.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRVideoParamEntity.h"
#import "WVRItemModel.h"
@class WVRBottomImageModel;

@interface WVRVideoEntity : WVRVideoParamEntity

/// 请求中心底图
- (void)requestForPlayerBottomImage:(void (^)(WVRBottomImageModel *model))complation;

@end


@interface WVRBottomImageModel : NSObject

@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, assign) float scale;

@end
