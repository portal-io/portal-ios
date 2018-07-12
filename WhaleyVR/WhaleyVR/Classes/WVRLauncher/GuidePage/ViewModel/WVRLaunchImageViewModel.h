//
//  WVRLaunchImageViewModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/9/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 开机广告数据请求

#import "WVRViewModel.h"
#import "WVRRecommendItemModel.h"

@interface WVRLaunchImageViewModel : WVRViewModel

@property (nonatomic, strong) WVRRecommendItemModel *dataModel;

- (RACCommand *)httpCmd;

@end
