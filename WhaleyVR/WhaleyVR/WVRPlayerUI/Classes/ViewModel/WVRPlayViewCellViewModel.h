//
//  WVRPlayViewCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"
#import "WVRPlayerViewHeader.h"
#import "WVRPlayerBottomViewDelegate.h"
#import "WVRPlayViewCellViewModelProtocol.h"

@interface WVRPlayViewCellViewModel : WVRViewModel<WVRPlayViewCellViewModelProtocol>


@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) NSString * cellNibName;
@property (nonatomic, strong) NSString * cellClassName;

@property (nonatomic, strong) RACCommand * gAnimationCmd;

@property (nonatomic, strong) RACCommand * gUpAnimationCmd;

@property (nonatomic, assign) WVRPlayerToolVStatus lockStatus;

@property (nonatomic, assign) WVRPlayerToolVStatus playStatus;

@property (nonatomic, assign) WVRPlayerToolVStatus animationStatus;

@property (nonatomic, assign) WVRPlayerToolVStatus vrStatus;

@property (nonatomic, assign) WVRPlayerToolVStatus gPayStatus;

@property (nonatomic, assign) WVRPlayerToolVStatus gDramaStatus;

@property (nonatomic, assign) BOOL viewIsHiden;

@property (nonatomic, assign) BOOL canShowGift;

@property (nonatomic, assign) BOOL showCameraBtn;

@end
