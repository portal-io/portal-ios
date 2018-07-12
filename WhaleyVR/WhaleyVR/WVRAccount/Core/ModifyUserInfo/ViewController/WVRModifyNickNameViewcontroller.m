//
//  WVRModifyNickNameViewcontroller.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/31/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRModifyNickNameViewcontroller.h"
#import "WVRModifyNickNameView.h"
#import "WVRUserModel.h"

#import "WVRModifyNickNameViewModel.h"

@interface WVRModifyNickNameViewcontroller ()

@property (nonatomic, strong) NSString * gNewName;
@property (nonatomic, strong) WVRModifyNickNameView *contentView;

@property (nonatomic, strong) WVRModifyNickNameViewModel * gMNickNameViewModel;

@end

@implementation WVRModifyNickNameViewcontroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configSelf];
    [self configSubviews];
    [self setUpRAC];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.contentView.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

-(WVRModifyNickNameViewModel *)gMNickNameViewModel
{
    if (!_gMNickNameViewModel) {
        _gMNickNameViewModel = [[WVRModifyNickNameViewModel alloc] init];
    }
    return _gMNickNameViewModel;
}

- (void)configSelf
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14.0f] } forState:UIControlStateNormal];
    [self.navigationItem setTitle:@"修改昵称"];
}

- (void)configSubviews
{
    _contentView = [[WVRModifyNickNameView alloc] init];
    [self.view addSubview:_contentView];
    
    _contentView.frame = self.view.bounds;
    
    [_contentView updateNickName:_nickName];
}

-(void)setUpRAC
{
    @weakify(self);
    [self.gMNickNameViewModel.completeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpChangeNickNameSuccessBlock:@""];
    }];
    [[RACObserve(self.gMNickNameViewModel, responseMsg) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        SQHideProgress;
        SQToast(x);
    }];
}

- (void)rightButtonClick
{
    SQShowProgress;
    [self.view endEditing:YES];
    NSString * nameStr = [_contentView getNewNickName];
    nameStr = [self removeSpaceAndNewline:nameStr];
//    nameStr = [nameStr stringByAddingPercentEscapesUsingEncoding:NSUTF16StringEncoding];
    nameStr = [self disable_EmojiString:nameStr];
    NSInteger totalNum = [self unicodeLengthOfString:nameStr];
//    if (![_contentView getNewNickName] || [[_contentView getNewNickName] isEqualToString:@""])
//        return;
//    
    if (totalNum < 3 || totalNum > 30) {
        [self showMessageToWindow:@"昵称格式不正确"];
        SQHideProgress;
        return;
    }
    self.gNewName = nameStr;
    self.gMNickNameViewModel.nickName = nameStr;
    
    [[self.gMNickNameViewModel modifyNickNameCmd] execute:nil];
}

- (NSString*)disable_EmojiString:(NSString *)text
{
    //去除表情规则
    //  \u0020-\\u007E  标点符号，大小写字母，数字
    //  \u00A0-\\u00BE  特殊标点  (?￠￡¤￥|§¨?a??-?ˉ°±23′μ?·?1o????)
    //  \u2E80-\\uA4CF  繁简中文,日文，韩文 彝族文字
    //  \uF900-\\uFAFF  部分汉字
    //  \uFE30-\\uFE4F  特殊标点(︴︵︶︷︸︹)
    //  \uFF00-\\uFFEF  日文  (???????)
    //  \u2000-\\u201f  特殊字符(‐??–—―‖?‘’??“”??)
    // 注：对照表 http://blog.csdn.net/hherima/article/details/9045765
    
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSString* result = [expression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    
    return result;
}

- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

//按照中文两个字符，英文数字一个字符计算字符数
- (NSUInteger)unicodeLengthOfString:(NSString *)text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

- (void)requestFaild:(NSString *) errorStr
{
    SQHideProgress;
    [self showMessageToWindow:errorStr];
}

- (void)httpChangeNickNameSuccessBlock:(NSString *)successStr
{
    SQHideProgress;
    [WVRUserModel sharedInstance].username = self.gNewName;
    
    SQToastInKeyWindow(@"昵称修改成功");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
