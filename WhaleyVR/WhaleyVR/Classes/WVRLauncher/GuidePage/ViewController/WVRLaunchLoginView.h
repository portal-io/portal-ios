//
//  WVRLaunchLoginView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQBaseView.h"

typedef NS_ENUM(NSInteger, WVRLaunchLoginType) {
    WVRLaunchLoginTypeGoTry,
    WVRLaunchLoginTypeLogin,
    WVRLaunchLoginTypeRegister,
    WVRLaunchLoginTypeQQ,
    WVRLaunchLoginTypeWX,
    WVRLaunchLoginTypeWB,
};

@class WVRLaunchLoginView;
@protocol WVRLaunchLoginDelegate <NSObject>

- (void)onClickItem:(WVRLaunchLoginType)type btn:(UIButton*)btn;

@end


@interface WVRLaunchLoginView : SQBaseView

@property (nonatomic, weak) id<WVRLaunchLoginDelegate> loginDelegate;

- (void)configPanoView:(UIViewController *)vc;

@end
