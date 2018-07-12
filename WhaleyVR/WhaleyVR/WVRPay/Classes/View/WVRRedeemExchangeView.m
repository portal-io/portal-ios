//
//  WVRRedeemExchangeView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/20.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 兑换码兑换

#import "WVRRedeemExchangeView.h"

#import "WVRExchangeSuccessView.h"

#import <WVRAppContextHeader.h>
#import <UIView+Extend.h>
#import "WVRMediator+Launcher.h"
#import "WVRExchangeRedeemCodeUC.h"
#import "WVRErrorViewModel.h"

@interface WVRRedeemExchangeView ()<UITextFieldDelegate>

@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, assign) CGSize originSize;

@property (nonatomic, assign) CGPoint finalPoint;

@property (nonatomic, strong) WVRExchangeTextField *textField;

@property (nonatomic, strong) UIButton *exchangeBtn;

@property (nonatomic, assign) BOOL keyboardIsVisible;
@property (atomic   , assign) BOOL isRequesting;

@property (nonatomic, weak) WVRExchangeSuccessView *successView;

@property (nonatomic, strong) WVRExchangeRedeemCodeUC *gRedeemCodeUC;

@end


@implementation WVRRedeemExchangeView

- (instancetype)initWithTextFieldOrigin:(CGPoint)originPoint size:(CGSize)originSize {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        _originPoint = originPoint;
        _originSize = originSize;
        
        _finalPoint = CGPointMake(originPoint.x, kNavBarHeight + adaptToWidth(25));
        
        [self registerNotification];
        [self drawUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.window endEditing:YES];
    
    if (!_isRequesting) {
        [self dissmissWithAnimate];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (WVRExchangeRedeemCodeUC *)gRedeemCodeUC {
    if (!_gRedeemCodeUC) {
        _gRedeemCodeUC = [[WVRExchangeRedeemCodeUC alloc] init];
        @weakify(self);
        [[_gRedeemCodeUC buildUseCase] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.isRequesting = NO;
            [self hideProgress];
            self.exchangeBtn.enabled = YES;
            
            if ([x isKindOfClass:[NSError class]]) {
                [self dealWithExchangeRedeemCodeError:((NSError *)x).domain];
            } else {
                
                [self showSuccessResultWithItemModel:x];
            }
        }];
        [[_gRedeemCodeUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.isRequesting = NO;
            [self hideProgress];
            self.exchangeBtn.enabled = YES;
            
            [self dealWithExchangeRedeemCodeError:kLoadError];
        }];
    }
    return _gRedeemCodeUC;
}

#pragma mark - UI

- (void)drawUI {
    
    self.backgroundColor = [Color_RGB(245, 245, 245) colorWithAlphaComponent:0.6];
    
    [self textField];
}

- (WVRExchangeTextField *)textField {
    
    if (!_textField) {
        _textField = [[WVRExchangeTextField alloc] initWithFrame:CGRectMake(_originPoint.x, _originPoint.y, _originSize.width, _originSize.height)];
        _textField.placeholder = @" 请输入兑换码";
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyGo;
        _textField.clearButtonMode = UITextFieldViewModeNever;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        
        _textField.textColor = k_Color1;
        _textField.font = kFontFitForSize(16);
        
        _textField.layer.shadowColor = [k_Color2 colorWithAlphaComponent:0.12].CGColor;
        _textField.layer.shadowOffset = CGSizeMake(0, 7);
        _textField.layer.shadowOpacity = 0.2;
        _textField.layer.shadowRadius = 4;
        
        [_textField setRightView:self.exchangeBtn];
        [_textField setRightViewMode:UITextFieldViewModeNever];
        
        [self addSubview:_textField];
    }
    return _textField;
}

- (UIButton *)exchangeBtn {
    
    if (!_exchangeBtn) {
        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeBtn.bounds = CGRectMake(0, 0, adaptToWidth(60), adaptToWidth(32));
        _exchangeBtn.backgroundColor = k_Color1;
        
        _exchangeBtn.layer.cornerRadius = fitToWidth(4);
        _exchangeBtn.layer.masksToBounds = YES;
        
        [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [_exchangeBtn setTintColor:[UIColor whiteColor]];
        [_exchangeBtn.titleLabel setFont:kFontFitForSize(13)];
        
        [_exchangeBtn addTarget:self action:@selector(exchangeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeBtn;
}

#define Animat_Time 0.26

- (void)showWithAnimate {
    
    UITabBarController *tab = [[WVRMediator sharedInstance] WVRMediator_TabbarController];
    
    [tab.view addSubview:self];
    
    [UIView animateWithDuration:Animat_Time
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         _textField.y = _finalPoint.y;
                         self.backgroundColor = Color_RGB(245, 245, 245);
                         
                     } completion:^(BOOL finished) {
                         
                         [self.textField becomeFirstResponder];
                     }];
    
    if ([self.realDelegate respondsToSelector:@selector(viewControllerNeedUpdateStatusBar:)]) {
        [self.realDelegate viewControllerNeedUpdateStatusBar:YES];
    }
}

- (void)dissmissWithAnimate {
    
    [UIView animateWithDuration:Animat_Time
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.alpha = 0.05;
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         if (self.successView) {
                             [self.successView successIconAnimate];
                         }
                     }];
    
    if ([self.realDelegate respondsToSelector:@selector(viewControllerNeedUpdateStatusBar:)]) {
        [self.realDelegate viewControllerNeedUpdateStatusBar:NO];
    }
}

- (void)showSuccessResultWithItemModel:(WVRMyTicketItemModel *)model {
    
    if ([self.realDelegate respondsToSelector:@selector(showSuccessResultWithModel:)]) {
        [self.realDelegate showSuccessResultWithModel:model];
    }
    
    [self dissmissWithAnimate];
}

#pragma mark - request

- (void)requestForRedeemExchangeWithCode {
    
    [self showProgress];
    self.isRequesting = YES;
    
    self.gRedeemCodeUC.redeemCode = [_textField.text uppercaseString];
    
    [self.gRedeemCodeUC.getRequestCmd execute:nil];
}

- (void)dealWithExchangeRedeemCodeError:(NSString *)msg {
    
    UIViewController *curVC_root = [UIViewController getCurrentVC_RootVC];
    
    [UIAlertController alertMesasge:msg confirmHandler:nil viewController:curVC_root];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    
    if (text.length > 0) {
        [_textField setRightViewMode:UITextFieldViewModeAlways];
    } else {
        [_textField setRightViewMode:UITextFieldViewModeNever];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self exchangeButtonAction];
    return YES;
}

#pragma mark - action

- (void)exchangeButtonAction {
    
    [self.window endEditing:YES];
    self.exchangeBtn.enabled = NO;
    
    [self requestForRedeemExchangeWithCode];
}

#pragma mark - Notification

- (void)registerNotification {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardDidShow {
    
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide {
    
    _keyboardIsVisible = NO;
}

@end


@implementation WVRExchangeTextField

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
    
    textRect.origin.x -= adaptToWidth(10);
    return textRect;
}

@end
