//
//  WVRUnityPlayerBaseView.m
//  Unity-iPhone
//
//  Created by dy on 2017/12/14.
//

#import "WVRUnityPlayerBaseView.h"

@implementation WVRUnityPlayerBaseView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _viewModel = [[WVRUnityPlayerViewModel alloc] init];
    }
    return self;
}

- (void)setViewModel:(WVRUnityPlayerViewModel *)viewModel {
    _viewModel = viewModel;
}

- (void)dealloc {
    NSLog(@"%@ dealloc ---", self);
}

@end
