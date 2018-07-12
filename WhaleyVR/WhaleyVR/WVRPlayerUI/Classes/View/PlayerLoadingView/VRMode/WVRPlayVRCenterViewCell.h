//
//  WVRPlayCenterViewCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCell.h"

@interface WVRPlayVRCenterViewCell : WVRPlayViewCell
//@property (weak, nonatomic) IBOutlet UIButton *gLeftPauseStatusView;
//@property (weak, nonatomic) IBOutlet UIButton *gRightPauseStatusView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backOnClick:(id)sender;

@end
