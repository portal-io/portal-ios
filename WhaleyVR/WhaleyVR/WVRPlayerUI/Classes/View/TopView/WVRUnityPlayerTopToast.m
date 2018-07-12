//
//  WVRUnityPlayerTopToast.m
//  WhaleyVR
//
//  Created by Bruce on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUnityPlayerTopToast.h"
#import "YYText.h"
#import "WVRUnityPlayerViewModel.h"

@interface WVRUnityPlayerTopToast()

@property (atomic, copy) NSString *toastId;
@property (atomic, assign) UnityPlayerToastType toastType;
@property (nonatomic, weak) YYLabel *mainLabel;

@end


@implementation WVRUnityPlayerTopToast

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configSelf];
        [self createSubViews];
    }
    return self;
}

- (void)configSelf {
    
}

- (void)createSubViews {
    
    [self createMainLabel];
}

- (void)createMainLabel {
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:self.bounds];
    label.font = kFontFitForSize(13);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    _mainLabel = label;
}

- (void)showToast:(WVRUnityPlayerViewModel *)viewModel {
    
    self.toastType = viewModel.toastType;
    self.toastId = viewModel.currentToastId;
    
    @weakify(self);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 目前Unity UI类似于单例，所以先这么写，以后需求变更再改掉
        [RACObserve(viewModel, toastStr) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (self.toastType == UnityPlayerToastTypeLoading) {
//                [self.mainLabel setText:x];
                [self.mainLabel setAttributedText:x];
            }
        }];
    });
    
    [self.mainLabel setAttributedText:viewModel.toastStr];
//    [self.mainLabel setText:viewModel.toastStr];
//    if (viewModel.toastType == UnityPlayerToastTypeMsg) {
//
//        [self.mainLabel setTextColor:viewModel.toastColor];
//    } else {
//        [self.mainLabel setTextColor:[UIColor whiteColor]];
//    }
    
    [UIView animateWithDuration:UnityDefaultToastTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.y = fitToWidth(5);
    } completion:^(BOOL finished) {
        if (viewModel.toastIsTemp) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideToast:viewModel];
            });
        }
    }];
    
    viewModel.showingToast = YES;
}

- (void)hideToast:(WVRUnityPlayerViewModel *)viewModel {
    
    if (![self.toastId isEqualToString:viewModel.currentToastId]) {
        return;
    }
    
    [UIView animateWithDuration:UnityDefaultToastTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bottomY = 0;
    } completion:nil];
    
    viewModel.showingToast = NO;
}

@end
