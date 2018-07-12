//
//  WVRModifyNickNameView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/31/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRModifyNickNameView.h"
#import "WVRLoginStyleHeader.h"

@interface WVRModifyNickNameView()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *clearBtn;
@property (nonatomic, strong) WVRPhoneNumInputView *inputPhoneNumView;

@end


@implementation WVRModifyNickNameView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configSelf];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubviews];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configSelf
{
    [self addObservers];
    self.backgroundColor = [UIColor clearColor];
}

- (void)allocSubviews
{
    _scrollView = [[UIScrollView alloc] init];
    _inputPhoneNumView = [[WVRPhoneNumInputView alloc] init];
    _tintLabel = [[UILabel alloc] init];
}

- (void)configSubviews
{
    /* Scroll View */
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    _scrollView.scrollEnabled = YES;
    [_scrollView addGestureRecognizer:[self tapGesture]];

    _inputPhoneNumView.eventId = kEvent_login;
    [_inputPhoneNumView updateViewStyleWithIcon:YES andPlacehoderText:@"请输入昵称"];
//    _inputPhoneNumView.delegate = self;
    _inputPhoneNumView.textField.returnKeyType = UIReturnKeyNext;
//    _inputPhoneNumView.textField.keyboardType = UIKeyboardTypePhonePad;
    [_inputPhoneNumView.textField becomeFirstResponder];
    
    _tintLabel.text = @"昵称长度3-30个字符，1个中文占2个字符";
    _tintLabel.textColor = [UIColor colorWithHex:0xc9c9c9];
    _tintLabel.font = kFontFitForSize(21/2);
    
    [_scrollView addSubview:_inputPhoneNumView];
    [_scrollView addSubview:_tintLabel];
    
    [self addSubview:_scrollView];
}

- (void)positionSubviews
{
    CGRect tmpRect = CGRectZero;
    /* Scroll View */
    /* 这边的逻辑为保证与键盘出现逻辑的兼容 */
    if (0 == _scrollView.bounds.size.height) {
        tmpRect = self.bounds;
        [_scrollView setFrame:tmpRect];
    }
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:fitToWidth(TOP_TO_VIEW)];
    _inputPhoneNumView.frame = tmpRect;
    CGSize size = [self labelTextSize:_tintLabel];
    tmpRect = [self rectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:size.height toLeft:_inputPhoneNumView.x toTop:_inputPhoneNumView.bottom + adaptToWidth(MARGIN_ITEM)];
    _tintLabel.frame = tmpRect;
}

- (void)layoutSubviews
{
    [self positionSubviews];
}

- (void)updateNickName:(NSString *)nick
{
    if (nick && ![nick isEqualToString:@""] && ![nick isEqualToString:@"未设置"] ) {
        
        _inputPhoneNumView.textField.text = nick;
    }
}

- (NSString *)getNewNickName
{
    return _inputPhoneNumView.textField.text;
}

- (CGSize)labelTextSize:(UILabel*) label
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x-10, 9999);
    
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

#pragma mark - Observer
- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    
    CGRect tmpRect = self.bounds;
    tmpRect.size.height = self.bounds.size.height - keyboardHeight;
    [_scrollView setFrame:tmpRect];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    CGRect tmpRect = self.bounds;
    [_scrollView setFrame:tmpRect];
}

#pragma mark - Target-Action Pair
- (void)cellClicked:(UIGestureRecognizer *)gesture
{
    [self endEditing:YES];
}

#pragma mark - MISC
- (UIGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
    return tapGesture;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        _clearBtn.hidden = YES;
        
    } else {
        _clearBtn.hidden = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""] && (1 == range.length) && (0 == range.location)) {
        _clearBtn.hidden = YES;
        
    } else {
        _clearBtn.hidden = NO;
    }
    //不支持系统表情的输入
//    return ![self isContainsEmoji:string];
//    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"]) {
//        return NO;
//    }
    return YES;
}

-(BOOL)isContainsEmoji:(NSString *)string {
    
    
    
    __block BOOL isEomji = NO;
    
    
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         
         
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 isEomji = YES;
                 
             }
             
             
             
         } else {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 
                 isEomji = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 isEomji = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 isEomji = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 
                 isEomji = YES;
                 
             }
             
         }
         
     }];
    
    
    
    return isEomji;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _clearBtn.hidden = YES;
    
    return YES;
}

@end
