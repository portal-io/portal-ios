//
//  WVRStatModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/14.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 节目详情的统计信息

#import <Foundation/Foundation.h>

@interface WVRStat : NSObject

@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger playSeconds;
@property (nonatomic, copy) NSString *programType;
@property (nonatomic, copy) NSString *srcCode;
@property (nonatomic, copy) NSString *srcDisplayName;
@property (nonatomic, copy) NSString *videoType;

@end
