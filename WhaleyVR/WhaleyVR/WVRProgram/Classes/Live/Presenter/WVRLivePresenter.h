//
//  WVRLivePresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRLivePresenter_h
#define WVRLivePresenter_h

@protocol WVRLiveTopTabView;
@protocol WVRLivePresenter <NSObject>

-(void)showTopTabBarView:(id<WVRLiveTopTabView>)ttView;

-(void)updatePageView;



@end
#endif /* WVRLivePresenter_h */
