//
//  WVRPlayerLiveFootBallBottomView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerLiveBottomView.h"
//#import "WVRPlayerBottomViewProtocol.h"
//#import "WVRPlayViewCell.h"
#import "WVRPlayerLiveBottomViewDelegate.h"
#import "WVRPlayLiveBottomCellViewModel.h"

@interface WVRPlayerLiveFootBallBottomView : WVRPlayerLiveBottomView

@property (nonatomic, assign, readonly) BOOL isFootball;

- (NSString *)cameraPoint;     // 为了能够动态调用，将其转为String

@end
