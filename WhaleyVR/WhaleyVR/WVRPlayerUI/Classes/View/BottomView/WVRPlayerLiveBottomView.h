//
//  WVRPlayerLiveBottomView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerSmallBottomView.h"
#import "WVRPlayerBottomViewProtocol.h"
#import "WVRPlayViewCell.h"
#import "WVRPlayerLiveBottomViewDelegate.h"
#import "WVRPlayLiveBottomCellViewModel.h"

@interface WVRPlayerLiveBottomView : WVRPlayerSmallBottomView<WVRPlayerBottomViewProtocol>

//@property (nonatomic, strong) WVRPlayLiveBottomCellViewModel * gViewModel;
@property (nonatomic, weak) UIButton *msgBtn;

@property (nonatomic, weak) UIButton * gGiftBtn;

-(void)updateGiftStatus:(BOOL)enableShowGift;

@end
