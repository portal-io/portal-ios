//
//  WVRFindTopBarPresenterImpl.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenter.h"
#import "WVRTopBarPresenterProtocol.h"

@interface WVRTopBarPresenter : WVRPresenter<WVRTopBarPresenterProtocol>

@property (nonatomic, strong) id args;

@property (nonatomic, strong, readonly) NSMutableArray* mItemModels;

-(NSInteger)gMixPageIndex;

@end
