//
//  WVRSecurityOrVerifyCodeInputView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/25/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRBaseInputView.h"

typedef NS_ENUM(NSInteger, WVRSecurityOrVerifyCodeInputViewStyle) {
    WVRSecurityCodeViewStyle = 0,
    WVRVerifyCodeViewStyle,
};

@protocol WVRSecurityOrVerifyCodeInputViewDelegate <NSObject>

- (void)buttonClickedWithIndex:(NSInteger)index;
- (void)inputFinishedWithView:(UIView *)view;
- (BOOL)phoneNumIsValid;

@end


@interface WVRSecurityOrVerifyCodeInputView : WVRBaseInputView

@property (nonatomic, assign) BOOL timerStoped;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *securityCodeBtn;
@property (nonatomic, strong) UIImageView *verifyCodeBtn;

@property (nonatomic) NSString* eventId;
@property (nonatomic) NSString* burialPoint;

@property (nonatomic, strong) id<WVRSecurityOrVerifyCodeInputViewDelegate> delegate;

- (void)setBtnEnable:(BOOL)enable;
- (void)startTimer;
- (void)stopTimer;
- (void)retrieveSecurityCode;
- (void)updateWithViewStyle:(WVRSecurityOrVerifyCodeInputViewStyle)style;

@end
