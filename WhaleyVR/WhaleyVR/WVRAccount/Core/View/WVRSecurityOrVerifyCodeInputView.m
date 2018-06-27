//
//  WVRSecurityOrVerifyCodeInputView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/25/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSecurityOrVerifyCodeInputView.h"


@interface WVRSecurityOrVerifyCodeInputView()<UITextFieldDelegate>

@property (nonatomic, assign) NSInteger leftTime;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic) UIButton * clearBtn;
@end

@implementation WVRSecurityOrVerifyCodeInputView

- (id)init {
    self = [super init];
    
    if (self) {
        self.lineHeight = 1.0f;
        [self configSelf];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubvies];
    }
    
    return self;
}

- (void)dealloc {
}

- (void)configSelf {
    _timerStoped = YES;
    self.backgroundColor = [UIColor colorWithHex:0xfdfdfd];
}

- (void)allocSubviews {
    _leftView = [[UIView alloc] init];
    _textField = [[UITextField alloc] init];
    _securityCodeBtn = [[UIButton alloc] init];
    _verifyCodeBtn = [[UIImageView alloc] init];
    self.clearBtn = [[UIButton alloc] init];
}

- (void)configSubviews {
//    _leftView.layer.borderWidth = 0.5;
//    _leftView.layer.borderColor = [[UIColor colorWithHex:0xe3e3e3] CGColor];
//    _leftView.layer.cornerRadius = 4;
    _leftView.backgroundColor = UIColorFromRGB(0xcccccc);
    [_textField setTextColor:[UIColor blackColor]];
    [_textField setFont:kFontFitForSize(15)];
    [_textField setTextAlignment:NSTextAlignmentLeft];
    _textField.placeholder = @"请输入安全码";
    _textField.delegate = self;
    
    [_securityCodeBtn setTitle:@"获取安全码" forState:UIControlStateNormal];
    [_securityCodeBtn.titleLabel setFont:kFontFitForSize(15)];
    [_securityCodeBtn setBackgroundImageWithColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_securityCodeBtn setBackgroundImageWithColor:[UIColor clearColor] forState:UIControlStateDisabled];
    [_securityCodeBtn setTitleColor:[UIColor colorWithHex:0x2a2a2a] forState:UIControlStateNormal];
    [_securityCodeBtn setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateDisabled];
    [_securityCodeBtn setClipsToBounds:YES];
    _securityCodeBtn.layer.borderWidth = fitToWidth(2.0);
//    [_securityCodeBtn.layer setCornerRadius:4];
    [_securityCodeBtn.layer setBorderColor:UIColorFromRGB(0xcccccc).CGColor];
    [_securityCodeBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _securityCodeBtn.tag = security_btn_tag;
    _securityCodeBtn.enabled = NO;
    
    _verifyCodeBtn.image = [UIImage imageNamed:@"icon_setting"];
    _verifyCodeBtn.tag = VerifyCode_btn_tag;
    _verifyCodeBtn.userInteractionEnabled = YES;
    [_verifyCodeBtn addGestureRecognizer:[self tapGesture]];
    
//    [_leftView addSubview:_textField];
    
    [self addSubview:_securityCodeBtn];
    [self addSubview:_verifyCodeBtn];
    [self addSubview:_leftView];
    [self addSubview:_textField];
    
    [self.clearBtn addTarget:self action:@selector(clearTextFiled) forControlEvents:UIControlEventTouchUpInside];
    [self.clearBtn setImage:[UIImage imageNamed:@"icon_input_clear"] forState:UIControlStateNormal];
    self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.textField setRightView:self.clearBtn];
}

- (void)positionSubvies {
    CGRect tmpRect = CGRectZero;
    
    tmpRect = [self rectInSubviewWithWidth:fitToWidth(375/2) height:self.lineHeight toLeft:0 toBottom:0];
    _leftView.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:_leftView.width height:self.height-1 toLeft:0];
    _textField.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:fitToWidth(103) height:self.height toLeft:_leftView.right + fitToWidth(21) toBottom:0];
    _securityCodeBtn.frame = tmpRect;
    _verifyCodeBtn.frame = tmpRect;
    self.clearBtn.frame = CGRectMake(0, 0, fitToWidth(27), fitToWidth(27));
}

- (void)layoutSubviews {
    [self positionSubvies];
}


-(void)clearTextFiled {
    self.textField.text = @"";
}


- (void)updateWithViewStyle:(WVRSecurityOrVerifyCodeInputViewStyle)style {
    switch (style) {
        case WVRSecurityCodeViewStyle:
        {
            [_textField setPlaceholder:@"请输入安全码"];
            _verifyCodeBtn.hidden = YES;
        }
            break;
        case WVRVerifyCodeViewStyle:
        {
            [_textField setPlaceholder:@"请输入验证码"];
        }
            break;
        default:
            break;
    }
}

-(void)getCodetime:(id )sender {
    _leftTime--;
    if (_leftTime > 1) {
        
        [_securityCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取", (long)_leftTime] forState:UIControlStateNormal];
        
    }else{
        [self retrieveSecurityCode];
    }
}

- (void)retrieveSecurityCode {
    [_securityCodeBtn setTitle:@"重新获取安全码" forState:UIControlStateNormal];
    _securityCodeBtn.enabled = YES;
    [_securityCodeBtn setTitleColor:UIColorFromRGB(0x2a2a2a) forState:UIControlStateNormal];
    
    [self stopTimer];
}

- (void)startTimer {
    _timerStoped = NO;
    _leftTime = 60;
    
    _securityCodeBtn.enabled = NO;
    [_securityCodeBtn.titleLabel setFont:kFontFitForSize(13)];
    [_securityCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)_leftTime] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCodetime:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    _timerStoped = YES;
    
    _securityCodeBtn.enabled = YES;
    _leftTime = 0;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setBtnEnable:(BOOL)enable {
    _securityCodeBtn.enabled = enable;
    if (enable) {
        [_securityCodeBtn.layer setBorderColor:UIColorFromRGB(0x2a2a2a).CGColor];
    } else {
        [_securityCodeBtn.layer setBorderColor:UIColorFromRGB(0xcccccc).CGColor];
    }
}

#pragma mark - Target-Action Pair
- (void)cellClicked:(UIGestureRecognizer *)gesture {
    UIView *tmpView = gesture.view;
    
    if (tmpView == _verifyCodeBtn) {
         if ([self.delegate respondsToSelector:@selector(buttonClickedWithIndex:)]) {
             [self.delegate buttonClickedWithIndex:_verifyCodeBtn.tag];
         }
     }
}

- (void)buttonClicked:(id) sender {
    UIButton *button = (UIButton*)sender;
    if ([self.delegate respondsToSelector:@selector(phoneNumIsValid)]) {
        if(![self.delegate phoneNumIsValid])
            return;
    }
    
    if ([self.delegate respondsToSelector:@selector(buttonClickedWithIndex:)]) {
        [self.delegate buttonClickedWithIndex:button.tag];
    }
}

#pragma mark - MISC
- (UIGestureRecognizer *)tapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
    return tapGesture;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputFinishedWithView:)]) {
        [self.delegate inputFinishedWithView:self];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.eventId.length > 0 && self.burialPoint.length > 0) {
        [WVRTrackEventMapping curEvent:self.eventId flag:self.burialPoint];
    }
    _leftView.backgroundColor = [UIColor colorWithHex:0x2a2a2a];
    self.lineHeight = 2.0f;
    [self positionSubvies];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _leftView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    self.lineHeight = 1.0f;
    [self positionSubvies];
    return YES;
}

@end

