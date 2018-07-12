//
//  WVRModifyPasswordView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/1/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>



@class WVRPassWordInputView;

typedef NS_ENUM(NSInteger, WVRModifyPasswordViewStyle) {
    WVRModifyPasswordViewStyleModifyPW = 0,
    WVRModifyPasswordViewStyleFindOldPW,
};

@interface WVRModifyPasswordView : UIView

@property (nonatomic ,assign) WVRModifyPasswordViewStyle style;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WVRPassWordInputView *oldPassword;
@property (nonatomic, strong) WVRPassWordInputView *password;
@property (nonatomic, strong) WVRPassWordInputView *confirmPassword;

@property (nonatomic, strong) UILabel *forgetPasswordLabel;
@property (nonatomic, strong) UILabel *tintLabel;

@property (copy) void(^forgotLabelOnClickBlock)(void);

-(NSString*)getOldPassword;
- (NSString*)getNewPassword;
- (NSString*)getConfirmNewPassword;
- (BOOL)isPasswordSame;

- (void)changeToFindOldPWMode;
- (void)updateTextFieldBgSelected:(BOOL) selected;

-(void)showInputBoard;

@end
