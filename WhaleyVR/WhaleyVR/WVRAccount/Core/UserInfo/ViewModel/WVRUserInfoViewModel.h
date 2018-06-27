//
//  WVRUserInfoViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRUserInfoViewModel : WVRViewModel

@property (nonatomic, assign) NSInteger origin;

@property (nonatomic, strong) NSString * msg;

@property (nonatomic, assign) BOOL bind;

@property (nonatomic, assign) BOOL isBind;

- (RACCommand *)thirtyPartyBindCmd;

@end
