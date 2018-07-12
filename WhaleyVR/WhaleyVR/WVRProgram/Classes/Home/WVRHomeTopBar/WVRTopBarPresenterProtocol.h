//
//  WVRFindTopBarPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenterProtocol.h"

@protocol WVRTopTabViewProtocol ;

@protocol WVRTopBarPresenterProtocol <WVRPresenterProtocol>


@optional
-(void) requestInfo:(id)requestParams;
@end
