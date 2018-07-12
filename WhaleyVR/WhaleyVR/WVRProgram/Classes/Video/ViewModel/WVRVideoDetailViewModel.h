//
//  WVRVideoDetailViewModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRViewModel.h"
#import "WVRVideoDetailVCModel.h"

@class WVRVideoDetailUseCase;

@interface WVRVideoDetailViewModel : WVRViewModel

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) WVRVideoDetailVCModel *dataModel;

@property (nonatomic, strong, readonly) RACSignal * gSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gFailSignal;

@property (nonatomic, strong, readonly) RACSignal * gTVItemSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gTVSeriesSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gTVSelectSuccessSignal;

@property (nonatomic, strong, readonly) RACCommand * gDetailCmd;

@property (nonatomic, strong, readonly) RACCommand * gTVItemDetailCmd;

@property (nonatomic, strong, readonly) RACCommand * gTVseriesDetailCmd;

@property (nonatomic, strong, readonly) RACCommand * gTVSelectItemDetailCmd;

@property (nonatomic, strong) WVRVideoDetailUseCase* gDetailUC;

@end
