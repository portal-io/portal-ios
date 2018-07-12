//
//  WVRPlayerFullSFootBallBottomView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerSmallBottomView.h"

@interface WVRPlayerFullSFootBallBottomView : WVRPlayerSmallBottomView

@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

@property (nonatomic, assign, readonly) BOOL isFootball;
- (IBAction)cameraBtnClick:(id)sender;
- (NSString *)cameraPoint;     // 为了能够动态调用，将其转为String

@end
