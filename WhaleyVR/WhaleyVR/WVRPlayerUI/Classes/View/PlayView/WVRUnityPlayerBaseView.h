//
//  WVRUnityPlayerBaseView.h
//  Unity-iPhone
//
//  Created by dy on 2017/12/14.
//

#import <UIKit/UIKit.h>
#import "WVRUnityPlayerViewModel.h"

@interface WVRUnityPlayerBaseView : UIView

@property (nonatomic, strong, readonly) WVRUnityPlayerViewModel *viewModel;

/// 供子类调用 如果重写，请调用super方法
- (void)setViewModel:(WVRUnityPlayerViewModel *)viewModel;

@end
