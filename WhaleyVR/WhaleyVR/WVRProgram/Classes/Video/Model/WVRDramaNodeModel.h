//
//  WVRDramaNodeModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/14.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧节点信息

#import <Foundation/Foundation.h>
#import "WVRMediaDto.h"

@interface WVRDramaNodeModel : NSObject

/// 播放链接相关信息
@property (nonatomic, strong) NSArray<WVRMediaDto *> *mediaDtos;

/// 父子结点相关连的code 在父节点的childrenCode字段中匹配
@property (nonatomic , copy) NSString              * code;

/// 自己的code，例如 "subcode0"
@property (nonatomic , copy) NSString              * cCode;

/// 提示语 "请选择..."
@property (nonatomic , copy) NSString              * tip;

@property (nonatomic , assign) NSInteger              position;

/// 图片链接
@property (nonatomic , copy) NSString              * smallPic;

/// "请选择..."
@property (nonatomic , copy) NSString              * defaultItem;

/// "子剧0"
@property (nonatomic , copy) NSString              * title;

/// 1为true，0位false
@property (nonatomic , assign) int                   defaultVisible;

/// "subcode1-subcode2"
@property (nonatomic , copy) NSString              * childrenCode;

/// 显示的时机，单位为毫秒
@property (nonatomic , assign) long                 tipTime;

//@property (nonatomic, strong) NSDictionary *xyz;  // 坐标，暂时用不到

#pragma mark - getter

- (NSString *)playUrl;
- (NSString *)definitionForPlayURL;
- (NSString *)renderTypeForPlayURL;

@end
