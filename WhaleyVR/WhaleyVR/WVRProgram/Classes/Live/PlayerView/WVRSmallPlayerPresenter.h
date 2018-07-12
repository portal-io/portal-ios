//
//  WVRSmallPlayerPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//


#import "WVRItemModel.h"

@class WVRMediaModel;

@interface WVRSmallPlayerPresenter : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, weak) UIView * contentView;


@property (nonatomic, strong) WVRItemModel * itemModel;

@property (nonatomic, assign) BOOL isLive;


@property (nonatomic, assign) BOOL shouldPause;

@property (nonatomic, assign, readonly) BOOL isLaunch;

//- (UIView *)getView;
- (void)reloadData;

- (void)stop;

- (void)start;

- (void)destroy;

//- (void)destroyForLauncher;

//- (void)restart;

- (BOOL)isPlaying;
- (BOOL)isPaused;

- (BOOL)canPlay;

- (void)updateCanPlay:(BOOL)canPlay;

- (void)restartForLaunch;

- (void)responseCurPage:(NSInteger)pageNumber itemModel:(WVRItemModel *)itemModel contentView:(UIView *)contentView;

@end
