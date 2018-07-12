//
//  WVRUnityPlayerTopToast.h
//  WhaleyVR
//
//  Created by Bruce on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRUnityPlayerViewModel.h"

@interface WVRUnityPlayerTopToast : UIView

- (instancetype)init NS_UNAVAILABLE;

- (void)showToast:(WVRUnityPlayerViewModel *)viewModel;

- (void)hideToast:(WVRUnityPlayerViewModel *)viewModel;

@end
