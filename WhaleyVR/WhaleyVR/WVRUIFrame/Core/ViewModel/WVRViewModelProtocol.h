//
//  WVRViewModelProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRViewModelProtocol <NSObject>

- (instancetype)initWithParams:(id)args;

@optional
- (id)getSectionInfo:(id)args;

@end
