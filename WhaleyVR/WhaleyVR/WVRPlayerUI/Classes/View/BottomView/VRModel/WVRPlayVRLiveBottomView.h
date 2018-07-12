//
//  WVRPlayVRLiveBottomView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/30.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 分屏模式下，直播的Bottom UI，目前没有用到，因为分屏跳到了Unity

#import "WVRPlayerVRBottomView.h"
#import "WVRPlayerBottomViewProtocol.h"
#import "WVRPlayLiveBottomCellViewModel.h"

@interface WVRPlayVRLiveBottomView : WVRPlayerVRBottomView<WVRPlayerBottomViewProtocol>
//@property (nonatomic, strong) WVRPlayLiveBottomCellViewModel * gViewModel;

//@property (weak, nonatomic) IBOutlet UIButton *defiButton;
//- (IBAction)defiBtnOnClick:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *backBtn;
//- (IBAction)backOnClick:(id)sender;

- (IBAction)vrModeBtnOnClick:(id)sender;

@end
