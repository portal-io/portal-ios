//
//  WVRPlayUrlModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/4/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRAPIConst.h"
@class WVRParserUrlElement;

@interface WVRPlayUrlModel : NSObject

/// 当前链接对应的清晰度类型 例如：kDefinition_ST
@property (nonatomic, copy) NSString *definition;

/// definition 对应的枚举值 需要解析时赋值
@property (nonatomic, assign) DefinitionType defiType;

/// 后端传的当前链接对应的渲染类型字段
@property (nonatomic, copy) NSString *renderType;

/// 后端传的或者解析库得到的播放链接
@property (nonatomic, strong) NSURL *url;

/// 机位，无机位信息则返回默认：kDefault_Camera_Stand
@property (nonatomic, copy) NSString *cameraStand;

- (instancetype)initWithElement:(WVRParserUrlElement *)element;

@end
