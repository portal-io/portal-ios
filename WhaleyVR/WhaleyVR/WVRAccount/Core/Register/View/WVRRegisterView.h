//
//  WVRRegisterView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/25/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WVRRegisterView;

typedef NS_ENUM(NSInteger, WVRRegisterViewStyle) {
    
    WVRRegisterViewStyleInputPhoneNum = 0,
    WVRRegisterViewStyleInputNameAndPD,
    WVRRegisterViewStyleInputPhoneNumForSecurityLogin,
    WVRRegisterViewStyleInputPhoneNumAndPDForThirdPartyBind,
    WVRRegisterViewStyleFindOldPassword,
};


@protocol WVRRegisterViewDelegate <NSObject>

- (void)bindView:(WVRRegisterView *)view buttonClickedAtIndex:(NSInteger)index;

@end


@interface WVRRegisterView : UIView

@property (nonatomic, weak) id<WVRRegisterViewDelegate>delegate;

@property (nonatomic, assign) BOOL verifyCodeViewIsHidden;
@property (nonatomic, strong) UIButton *loginBtn;

- (NSString *)getPhoneNum;
- (NSString *)getCaptcha;
- (NSString *)getSecurityCode;
- (NSString *)getNickname;
- (NSString *)getPassword;

- (void)setCaptcha:(NSString *)captcha;
- (void)setAvatar:(NSString *)avatar;
- (void)setPhoneNum:(NSString *)phoneNum;

- (void)updateWithViewStyle:(WVRRegisterViewStyle)style;
- (void)displayVeryfyCodeInputView;

- (void)startTimer;
- (void)stopTimer;

- (void)setEventId:(NSString *)eventId;

@end
