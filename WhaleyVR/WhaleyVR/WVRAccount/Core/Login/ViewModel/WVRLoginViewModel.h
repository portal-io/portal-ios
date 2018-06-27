//
//  LoginViewModel.h
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/7/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACCommand.h"
#import "WVRModelUserInfo.h"
#import "WVRViewModel.h"
#import "WVRThirtyPLoginModel.h"

@interface WVRLoginViewModel : WVRViewModel

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) NSInteger origin;

@property (nonatomic, strong) NSString * responseMsg;

@property(nonatomic, strong) WVRModelUserInfo *userInfo;


@property (nonatomic, strong) WVRThirtyPLoginModel * tpLoginModel;

- (RACCommand *)loginCmd;

//- (RACCommand *)thirtyPartyLoginCmd;

@end
