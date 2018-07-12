//
//  WVRPlayVRLiveFootballBottomView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVRBottomView.h"
#import "WVRPlayerBottomViewProtocol.h"
#import "WVRPlayLiveBottomCellViewModel.h"

@interface WVRPlayVRLiveFootballBottomView : WVRPlayerVRBottomView<WVRPlayerBottomViewProtocol>

//@property (nonatomic, strong) WVRPlayLiveBottomCellViewModel * gViewModel;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
- (IBAction)cameraBtnOnClick:(id)sender;

//@property (weak, nonatomic) IBOutlet UIButton *defiButton;
//- (IBAction)defiBtnOnClick:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *backBtn;
//- (IBAction)backOnClick:(id)sender;

//- (IBAction)vrModeBtnOnClick:(id)sender;
@end
