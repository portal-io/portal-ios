//
//  WVRModifyPhoneNViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRModifyPhoneNViewModel : WVRViewModel

@property (nonatomic, strong) NSString * inputCode;

@property (nonatomic, strong) NSString * inputPhoneNum;

@property (nonatomic, strong) NSString * inputCaptcha;
@property (nonatomic, strong) NSString * responseCaptcha;
@property (nonatomic, strong) NSString * responseMsg;
@property (nonatomic, strong) NSString * responseCode;

@property (nonatomic, strong, readonly) RACSignal * completeSignal;

-(RACCommand*)modifyPhoneCmd;

- (RACCommand *)validateCmd;


@end
