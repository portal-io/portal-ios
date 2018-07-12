//
//  WVRUserInfoView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/29/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRThirdPartyLoginView.h"

typedef NS_ENUM(NSInteger, WVRUserInfoStyle) {
    WVRUserInfoStyleAvatar = 0,
    WVRUserInfoStyleNickname,
    WVRUserInfoStylePassword,
    WVRUserInfoStylePhoneNum,
};

@class WVRUserInfoView;

@protocol WVRUserInfoViewDelegate <NSObject>

- (void)bindView:(WVRUserInfoView *)view buttonClickedAtIndex:(NSInteger)index;

@end


@interface WVRUserInfoView : UIView

@property (nonatomic, weak) id<WVRUserInfoViewDelegate>delegate;

@property (nonatomic, strong) WVRThirdPartyLoginView *thirdPartyLoginView;

@property (nonatomic, strong) NSMutableArray *itemViewArray;
@property (nonatomic, strong) UITableView *tableView;

@property (copy) void(^gotoChangePhoneBlock)(void);

- (void)updateAvator;
- (void)updateNickName:(NSString*)nick;
- (void)updatePhoneNum:(NSString*)phoneNum;
- (void)updateStatusOfQQIcon:(BOOL)QQisBinded WBIcon:(BOOL)WBisBinded WXIcon:(BOOL)WXisBinded;

- (void)logOut;
@end
