//
//  WVRMineAvatarCellViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMineAvatarCellViewModel.h"
#import "WVRSettingViewHeader.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface WVRMineAvatarCellViewModel ()

@property (nonatomic, strong) RACSubject * gClickSubscriber;

@end


@implementation WVRMineAvatarCellViewModel

- (instancetype)initWithParams:(id)args
{
    self = [super initWithParams:args];
    if (self) {
        self.args = args;
        self.cellClassName = UI_NAME_MINE_HEAD_CELL;
        self.cellHeight = 227.5f;
    }
    return self;
}

-(void)installRAC
{
//    self.isLogin = [WVRUserModel sharedInstance].isLogined;
//    self.avatar = [WVRUserModel sharedInstance].loginAvatar;
//    self.nickName = [WVRUserModel sharedInstance].username;
//    RAC(self, isLogin) = RACObserve([WVRUserModel sharedInstance], isLogined);
//    RAC(self, avatar) = RACObserve([WVRUserModel sharedInstance], loginAvatar);
//    RAC(self, nickName) = RACObserve([WVRUserModel sharedInstance], username);
}

//-(void (^)(WVRMAvatarClickType))clickBlock
//{
//    if (!_clickBlock) {
//        _clickBlock = ^(WVRMAvatarClickType type){
//            
//        };
//    }
//    return _clickBlock;
//}


//-(RACSignal *)avatarClickSignal
//{
//    @weakify(self);
//    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        @strongify(self);
//        self.gClickSubscriber = subscriber;
//        return nil;
//    }];
//    return signal;
//}

@end
