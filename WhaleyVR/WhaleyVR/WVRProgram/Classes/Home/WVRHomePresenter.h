//
//  WVRHomePresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRHomePresenterProtocol.h"
#import "WVRTopBarPresenterProtocol.h"

#import "WVRTopBarPresenter.h"
#import "WVRHomePagePresenter.h"
#import "WVRPresenter.h"

@interface WVRHomePresenter : WVRPresenter <WVRHomePresenterProtocol>

@property (nonatomic, strong, readonly) WVRTopBarPresenter* gTopBarPresenter;

@property (nonatomic, strong, readonly) WVRHomePagePresenter* gPagePresenter;

@end
