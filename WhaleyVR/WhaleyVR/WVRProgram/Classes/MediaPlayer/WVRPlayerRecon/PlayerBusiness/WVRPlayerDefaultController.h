//
//  WVRPlayerDefaultController.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRPlayerBusinessController.h"

@interface WVRPlayerDefaultController : NSObject <WVRPlayerBusinessController>

- (void)addController:(id<WVRPlayerBusinessController>) controller;
- (void)removeController:(id<WVRPlayerBusinessController>) controller;
- (void)clearController;

@end
