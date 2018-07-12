//
//  WVRShowGiftStrategy.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WVRGiftAnimalViewModel;

@interface WVRShowGiftStrategy : NSObject

@property (nonatomic, strong) WVRGiftAnimalViewModel * gAnimalViewModel;
@property (nonatomic, assign) BOOL isPortrait;

@end
