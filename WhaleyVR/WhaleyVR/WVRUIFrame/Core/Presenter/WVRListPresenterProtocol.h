//
//  WVRListPresenterProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenterProtocol.h"

@protocol WVRListPresenterProtocol <WVRPresenterProtocol>

@optional
- (void)fetchRefreshData;
- (void)fetchMoreData;

@end
