//
//  WVRPlayBottomCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCellViewModel.h"
#import "WVRPlayerBottomViewDelegate.h"
#import "WVRSlider.h"

@interface WVRPlayBottomCellViewModel : WVRPlayViewCellViewModel

@property (nonatomic, strong) NSString * defiTitle;

@property (nonatomic, assign) long position;

@property (nonatomic, assign) long bufferPosition;

@property (nonatomic, assign) long duration;

@property (nonatomic, assign) BOOL isVRMode;

@property (nonatomic, copy) NSString * toFullIcon;

@end
