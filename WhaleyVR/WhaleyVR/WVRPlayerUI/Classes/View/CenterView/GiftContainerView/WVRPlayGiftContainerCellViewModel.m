//
//  WVRPlayGiftContainerCellViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayGiftContainerCellViewModel.h"

@implementation WVRPlayGiftContainerCellViewModel
@synthesize gGiftPresenter = _gGiftPresenter;
@synthesize gGiftAnimationPresenter = _gGiftAnimationPresenter;

-(WVRGiftPresenter *)gGiftPresenter
{
    if (!_gGiftPresenter) {
        _gGiftPresenter = [[WVRGiftPresenter alloc] init];
    }
    return _gGiftPresenter;
}

-(WVRGiftAnimationPresenter *)gGiftAnimationPresenter
{
    if (!_gGiftAnimationPresenter) {
        _gGiftAnimationPresenter = [[WVRGiftAnimationPresenter alloc] init];
    }
    return _gGiftAnimationPresenter;
}
@end
