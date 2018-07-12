//
//  WVRFindPagePresenterImpl.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenter.h"
#import "WVRHomePagePresenterProtocol.h"
#import "WVRPageView.h"

@interface WVRHomePagePresenter : WVRPresenter<WVRHomePagePresenterProtocol, WVRPageViewDelegate, WVRPageViewDataSource>

@property (nonatomic, strong) id args;

- (void)updatePageView:(NSInteger)index;

- (void)updatePlayerStatusForCurIndex;

/// just fot BI
- (NSString *)getRealNameForIndex:(NSInteger)index;

@end
