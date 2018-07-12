//
//  WVRLoginView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/24/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPhoneNumInputView.h"
#import "WVRPassWordInputView.h"

typedef NS_ENUM(NSInteger, WVRLoginViewViewStyle) {
    WVRLoginViewViewStyleNormalLogin = 0,
//    WVRLoginViewViewStyleQuickLogin,
};

@class WVRLoginView;

@protocol WVRLoginViewDelegate <NSObject>

- (void)bindView:(WVRLoginView *)view buttonClickedAtIndex:(NSInteger)index;

@end


@interface WVRLoginView : UIView

@property (nonatomic, weak) id<WVRLoginViewDelegate>delegate;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) WVRPhoneNumInputView *inputPhoneNumView;
@property (nonatomic, strong) WVRPassWordInputView *inputPassWDView;

- (void)updateWithViewStyle:(WVRLoginViewViewStyle)style;

- (NSString *)getPhoneNum;
- (NSString *)getPassword;

- (void)showKeyboard;
@end
