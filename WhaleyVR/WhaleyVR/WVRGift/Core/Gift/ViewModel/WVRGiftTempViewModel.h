//
//  WVRGiftTempViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"
#import "WVRGiftModel.h"

@interface WVRGiftTempViewModel : WVRViewModel

@property (nonatomic, copy) NSString * tempCode;

@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

-(RACCommand*)getGiftTemoCmd;

@end
