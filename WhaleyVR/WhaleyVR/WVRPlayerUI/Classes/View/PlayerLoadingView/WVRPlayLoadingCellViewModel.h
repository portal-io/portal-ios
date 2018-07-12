//
//  WVRPlayLoadingCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCellViewModel.h"

@interface WVRPlayLoadingCellViewModel : WVRPlayViewCellViewModel

@property (nonatomic, assign) BOOL gIsLive;

@property (nonatomic, assign) long gNetSpeed;

@property (nonatomic, strong) NSString* gTipStr;

@property (nonatomic, strong) NSString* gTitle;

@property (nonatomic, strong) NSString * gErrorMsg;

@property (nonatomic, assign) NSInteger gErrorCode;

@property (nonatomic, assign) BOOL gHidenBack;

@property (nonatomic, assign) BOOL gCanTrail;

@property (nonatomic, assign) BOOL gHidenVRBackBtn;

@property (nonatomic, strong) NSString * gPrice;

@property (nonatomic, strong) RACCommand * gShowRetryPlayStatus;

@end
