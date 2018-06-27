//
//  WVRBindWhaleyAccountViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRBindWhaleyAccountViewModel : WVRViewModel

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSString * inputCaptcha;
@property (nonatomic, strong) NSString * responseCaptcha;
@property (nonatomic, strong) NSString * responseMsg;
@property (nonatomic, strong) NSString * responseCode;

@property (nonatomic, strong) NSString * origin;

@property (nonatomic, strong) NSString * msg;

@property (nonatomic, strong) NSString * reg_type;

@property (nonatomic, strong) NSString * unionId;

@property (nonatomic, strong) NSString * thirdId;

@property (nonatomic, strong) NSString * openId;

@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * avatar;


@property (nonatomic, assign) BOOL isBind;

- (RACCommand *)bindCmd;

-(RACCommand*)sendCodeCmd;

@end
