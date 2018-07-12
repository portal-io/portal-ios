//
//  WVRGiftPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenter.h"
#import "WVRGiftTempView.h"

@interface WVRGiftPresenterParams:NSObject

@property (nonatomic, assign) BOOL showGifts;
@property (nonatomic, assign) BOOL showMembers;

@property (nonatomic, strong) NSString * tempCode;
@property (nonatomic, strong) NSString * programCode;
@property (nonatomic, copy) NSString *videoName;

@end

@interface WVRGiftPresenter : WVRPresenter

@property (nonatomic, strong) WVRGiftViewModel * gGiftViewModel;

@property (nonatomic, assign) BOOL isPortrait;
@property (nonatomic, assign) BOOL viewIsHiden;

-(void)setParams:(WVRGiftPresenterParams*)params;

-(UIView*)bindContainerView:(UIView*)view;

-(void)reloadData;

@end
