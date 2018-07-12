//
//  WVRLiveTopTabView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WVRLiveTopTabView.h"
#import "WVRLiveTopTabViewPresenter.h"

@protocol WVRLiveTopTabVDelegate <NSObject>

-(void)didSelectSegmentItem:(NSInteger)index;

-(void)onClickMineReserveBtn;

@end

@interface WVRLiveTopTabViewImpl : UIView<WVRLiveTopTabView>


//-(void)updateSegmentSelectIndex:(NSInteger)index;
@end
