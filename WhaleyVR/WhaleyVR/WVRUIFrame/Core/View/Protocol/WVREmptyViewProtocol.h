//
//  WVREmptyViewProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVREmptyViewProtocol <NSObject>

@optional

- (void)showNullViewWithTitle:(NSString*)title icon:(NSString*)icon withreloadBlock:(void(^)(void))reloadBlock;

- (void)showNetErrorVWithreloadBlock:(void(^)(void))reloadBlock;

- (void)clear;

@end
