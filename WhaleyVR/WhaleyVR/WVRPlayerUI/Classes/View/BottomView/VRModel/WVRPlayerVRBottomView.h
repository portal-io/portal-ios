//
//  WVRPlayerVRBottomView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerFullSBottomView.h"

@interface WVRPlayerVRBottomView : WVRPlayerFullSBottomView

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backOnClick:(id)sender;

@end
