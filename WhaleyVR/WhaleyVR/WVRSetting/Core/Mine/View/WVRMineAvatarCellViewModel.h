//
//  WVRMineAvatarCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTableViewCellViewModel.h"

typedef NS_ENUM(NSInteger, WVRMAvatarClickType) {
    WVRMAvatarClickTypeLogin = 10,
    WVRMAvatarClickTypeRegister,
    WVRMAvatarClickTypeEdit,
    WVRMAvatarClickTypeSetting,
};

@interface WVRMineAvatarCellViewModel : WVRTableViewCellViewModel

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, strong) NSString * avatar;

@property (nonatomic, strong) NSString * nickName;

@property (nonatomic, assign) WVRMAvatarClickType clickType;

//@property (nonatomic, copy) void (^clickBlock)(WVRMineAvatarCellViewModel*);

@property (nonatomic, strong) RACSubject * gAvatarClickSubject;

@property (nonatomic, strong) RACSignal * clickSignal;

- (void)installRAC;

@end
