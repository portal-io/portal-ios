//
//  WVRPlayerVRFootballBottomView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVRBottomView.h"

@interface WVRPlayerVRFootballBottomView : WVRPlayerVRBottomView

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
- (IBAction)defiBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

@property (nonatomic, assign, readonly) BOOL isFootball;
- (IBAction)cameraBtnClick:(UIButton *)sender;

- (NSString *)cameraPoint;     // 为了能够动态调用，将其转为String

@end
