//
//  WVRPlayLiveTopViewDelegate.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WVRPlayerLiveTopView;

@protocol WVRPlayLiveTopViewDelegate <NSObject>

- (void)shareOnClick:(WVRPlayerLiveTopView *)view;

- (void)gotoContribution:(WVRPlayerLiveTopView *)view;

@end
