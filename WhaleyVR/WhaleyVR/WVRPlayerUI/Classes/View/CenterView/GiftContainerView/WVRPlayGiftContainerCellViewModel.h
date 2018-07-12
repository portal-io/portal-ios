//
//  WVRPlayGiftContainerCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCellViewModel.h"
#import "WVRGiftPresenter.h"
#import "WVRGiftAnimationPresenter.h"

@interface WVRPlayGiftContainerCellViewModel : WVRPlayViewCellViewModel

@property (nonatomic, assign) WVRLiveDisplayMode displayMode;

@property (nonatomic, strong) RACCommand * gShowGiftContainerCmd;

@property (nonatomic, strong, readonly) WVRGiftPresenter * gGiftPresenter;

@property (nonatomic, strong, readonly) WVRGiftAnimationPresenter * gGiftAnimationPresenter;

@property (nonatomic, assign) WVRPlayerToolVStatus gGiftStatus;

@end
