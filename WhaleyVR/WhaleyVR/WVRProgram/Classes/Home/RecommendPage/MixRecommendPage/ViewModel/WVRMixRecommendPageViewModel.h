//
//  WVRSQDefaultFindMoreModel.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRMixRecommendPageViewModel : WVRViewModel

@property (nonatomic, strong) NSString * code;

@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

- (RACCommand *)getMixRecommendPageCmd;

@end
