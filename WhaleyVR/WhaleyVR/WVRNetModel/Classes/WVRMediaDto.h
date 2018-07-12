//
//  WVRMediaDto.h
//  WhaleyVR
//
//  Created by Bruce on 2017/7/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRMediaDto : NSObject

/// getter, resolution转为Definition
@property (nonatomic, readonly) NSString *curDefinition;

@property (nonatomic, copy) NSString * playUrl;
@property (nonatomic, copy) NSString * renderType;
@property (nonatomic, copy) NSString * resolution;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * srcName;

/// 一下属性暂时用不到，先注释掉，用到的时候解注释

//@property (nonatomic, copy) NSString * code;
//@property (nonatomic, assign) NSInteger updateTime;
//@property (nonatomic, assign) NSInteger createTime;
//@property (nonatomic, assign) NSInteger analysis;
//@property (nonatomic, copy) NSString * threedType;
//@property (nonatomic, copy) NSString * videoType;
//@property (nonatomic, assign) NSInteger idField;
//@property (nonatomic, copy) NSString * parentCode;
//@property (nonatomic, strong) NSObject * prefer;
//@property (nonatomic, strong) NSObject * publishTime;
//@property (nonatomic, assign) NSInteger status;

@end
