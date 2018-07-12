//
//  WVRCollectionViewPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewProtocol.h"

@protocol WVRPresenterProtocol <NSObject>

@required
- (instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view;

- (void)fetchData;

@end
