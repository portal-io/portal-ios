//
//  WVRPlayerUIEventCallBack.h
//  WVRPlayerUI
//
//  Created by Bruce on 2017/9/19.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRPlayerUIEventCallBack : NSObject

/**
 是否响应此事件 default is YES 若不响应则无需创建本对象
 */
@property (nonatomic, assign) BOOL isResponsed;

/**
 是否拦截此事件 default is NO
 */
@property (nonatomic, assign) BOOL isIntercept;

/**
 callback参数
 */
@property (nonatomic, strong) NSDictionary *params;

@end
