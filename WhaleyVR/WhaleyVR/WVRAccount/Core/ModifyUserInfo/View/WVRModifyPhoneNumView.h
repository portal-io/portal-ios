//
//  WVRModifyPhoneNumView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/1/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WVRPhoneNumInputView, WVRSecurityOrVerifyCodeInputView;

@interface WVRModifyPhoneNumView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *oldPhoneNumLabel;
@property (nonatomic, strong) UILabel *oldPhoneNum;

@property (nonatomic, strong) WVRPhoneNumInputView *phoneNumInputView;
@property (nonatomic, strong) WVRSecurityOrVerifyCodeInputView *securityCodeInputView;

@property (copy) void(^getCodeBlock)(void);
@property (copy) void(^getCaptchaBlock)(void);
@property (nonatomic, assign) BOOL verifyCodeViewIsHidden;


-(NSString*)getNewPhoneNum;
-(NSString*)getPhoneCode;
-(NSString*)getCaptchaCode;
- (void)startTimer;
- (void)stopTimer;
- (void)setCaptcha:(NSString*) captcha;
- (void)displayVeryfyCodeInputView;
@end
