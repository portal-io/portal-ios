//
//  WVRPlayerTopViewDelegate.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRPlayerTopViewDelegate <NSObject>

@optional;
- (void)backOnClick:(UIButton *)sender;
- (void)refreshLiveAlertInfo;
- (BOOL)playOnClick:(BOOL)isPlay;
@end
