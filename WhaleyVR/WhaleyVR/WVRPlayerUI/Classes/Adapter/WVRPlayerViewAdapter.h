//
//  WVRPlayerViewAdapter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRPlayerViewDataSource.h"
@class WVRPlayViewCellViewModel, WVRPlayViewCell;

#define kLEFT_PLAYVIEW (@"left")
#define kRIGHT_PLAYVIEW (@"right")
#define kTOP_PLAYVIEW (@"top")
#define kBOTTOM_PLAYVIEW (@"bottom")
#define kLOADING_PLAYVIEW (@"loading")
#define kCENTER_PLAYVIEW (@"center")
#define kCHANGETOVRMODE_ANIMATION_PLAYVIEW (@"changeToVRMode_animation")
#define kGIFTCONTAINER_PLAYVIEW (@"gift_container")

@interface WVRPlayerViewAdapter : NSObject<WVRPlayerViewDataSource>

//@"left",@"right",@"top",@"bottom"
@property (nonatomic, strong, readonly) NSDictionary * gOriginDic;

//- (void)loadData:(NSDictionary *(^)(void))loadDataBlock;
- (void)loadData:(NSDictionary *)dict;

#pragma mark - 子类调用

- (WVRPlayViewCell *)cellForSection:(WVRPlayViewCellViewModel *)viewModel playView:(WVRPlayerView *)playView;

@end
