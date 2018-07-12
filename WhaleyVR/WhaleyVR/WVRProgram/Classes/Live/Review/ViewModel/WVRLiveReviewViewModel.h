//
//  WVRTopBarViewModel.h
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRLiveReviewViewModel : WVRViewModel

@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * subCode;

@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

-(RACCommand*)getLiveReviewCmd;
-(RACCommand*)getLiveReviewMoreCmd;

@end
