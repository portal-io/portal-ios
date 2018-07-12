//
//  WVRSQArrangeMoreController.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 专题列表

//#import "SQBaseCollectionViewController.h"
#import "WVRCollectionViewController.h"
#import "WVRManualArrangeViewCProtocol.h"
#import "WVRManualArrangePresenter.h"
#import "WVRUMShareView.h"
@class WVRUMShareView, WVRSectionModel;

@interface WVRManualArrangeController : WVRCollectionViewController<WVRManualArrangeViewCProtocol, WVRPackBIDelegate>

@property (nonatomic, strong, readonly) WVRSectionModel * gSectionModel;

@property (nonatomic, strong) WVRManualArrangePresenter* gPresenter;

- (WVRShareType)shareType;

- (void)shareSuccessAction:(kSharePlatform)platform;

@end
