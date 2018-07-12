//
//  WVRDramaDetailViewModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/9.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧ViewModel

#import "WVRViewModel.h"
#import "WVRInteractiveDramaModel.h"
@class WVRDramaDetailUseCase;

@interface WVRDramaDetailViewModel : WVRViewModel

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, strong) WVRInteractiveDramaModel *dataModel;

@property (nonatomic, strong, readonly) RACSignal * gSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gFailSignal;

@property (nonatomic, strong, readonly) RACCommand * gDetailCmd;

@property (nonatomic, strong) WVRDramaDetailUseCase* gDetailUC;

@end
