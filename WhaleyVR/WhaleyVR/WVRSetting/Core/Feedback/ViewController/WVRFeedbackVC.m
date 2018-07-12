//
//  WVRFeedbackVC.m
//  VRManager
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 我要反馈

#import "WVRFeedbackVC.h"
#import <StoreKit/StoreKit.h>

#import "WVRFeedBackViewModel.h"
 
@interface WVRFeedbackVC ()<UITextViewDelegate, SKStoreProductViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) WVRFeedBackViewModel * gFeedBackViewModel;

@property (nonatomic, assign) BOOL isSend;

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UILabel  *tips;
@property (nonatomic, weak) UIButton *qqBtn;

@end


@implementation WVRFeedbackVC

static NSString *const vrManagerAppID = @"963637613";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bulidUI];
    [self setUpRAC];
}

- (WVRFeedBackViewModel *)gFeedBackViewModel {
    
    if (!_gFeedBackViewModel) {
        _gFeedBackViewModel = [[WVRFeedBackViewModel alloc] init];
    }
    return _gFeedBackViewModel;
}

- (void)setUpRAC {
    
    @weakify(self);
    [[self.gFeedBackViewModel gSuccessSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self successBlock];
    }];
    
    [[self.gFeedBackViewModel gFailSignal] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self failBlock];
    }];
}

- (void)bulidUI {
    
    self.title = @"我要反馈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMsg:)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20, 84, self.view.bounds.size.width-40, 208)];
    [containerView.layer setCornerRadius:4];
    [containerView.layer setMasksToBounds:YES];
    [containerView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.7]];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 0, containerView.width-20, containerView.height)];
    [textView setDelegate:self];
    textView.scrollEnabled = NO;
    textView.editable = YES;
    textView.returnKeyType = UIReturnKeyNext;
    textView.keyboardType  = UIKeyboardTypeDefault;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.font = kFontFitForSize(16);
    [textView becomeFirstResponder];
    textView.backgroundColor = [UIColor clearColor];
    
    [containerView addSubview: textView];
    [self.view addSubview: containerView];
    _textView = textView;
    
    UILabel *tips_ = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, textView.width-5, 20)];
    [textView addSubview:tips_];
    tips_.font = kFontFitForSize(16);
    [tips_ setText:@"请留下您的宝贵意见，我们将不断完善"];
    [tips_ setTextColor:Color_RGB(185, 185, 185)];
    _tips = tips_;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+20,  312, self.view.bounds.size.width-40, 42)];
    [view.layer setCornerRadius:2];
    [view.layer setMasksToBounds:YES];
    [view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.7]];
    
    UITextField *textField =  [[UITextField alloc]initWithFrame:CGRectMake(15, 0, view.width-20, view.height)];
    [textField.layer setCornerRadius:2];
    [textField.layer setMasksToBounds:YES];
    [textField setDelegate:self];
    textField.placeholder = @"请填写您的联系方式（选填）";
    [textField setBackgroundColor:[UIColor clearColor]];
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:textField];
    [self.view addSubview:view];
    _textField = textField;
    
    UIButton *qqBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqBtn_ setTitle:@"加入QQ粉丝群 170321770" forState:UIControlStateNormal];
    [qqBtn_ setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [qqBtn_.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [qqBtn_ addTarget:self action:@selector(qqAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqBtn_];
    qqBtn_.frame = CGRectMake(self.view.bounds.size.width/2-120, self.view.bounds.size.height-120, 240, 48);
    [qqBtn_.layer setCornerRadius:24];
    [qqBtn_.layer setMasksToBounds:YES];
    [qqBtn_.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:0.8].CGColor];
    [qqBtn_.layer setBorderWidth:1.0];
    
    _qqBtn = qqBtn_;
    
    _isSend = NO;
}

- (void)enableUI {
    
    [_textView setEditable:YES];
    [_textField setEnabled:YES];
}

- (void)disableUI {
    
    [_textView setEditable:NO];
    [_textField setEnabled:NO];
}

- (void)successBlock {
    
    [self hideProgress];
    self.isSend = NO;
    [self enableUI];
    [self.textView setText:@""];
    [self.textField setText:@""];
    @weakify(self);
    [UIAlertController alertTitle:@"提示" mesasge:@"发送成功" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];

    } viewController:self];
}

- (void) failBlock {
    
    [self hideProgress];

    [self enableUI];
    _isSend = NO;

    if ([WVRReachabilityModel sharedInstance].isNoNet) {
        [self showMessageToWindow:kNoNetAlert];
    }
}
#pragma mark - request

- (void)sendMsg:(id)sender {
    
    [self.view endEditing:YES];
    if ([_textView.text length] < 1) {
        
        [self showMessageToWindow:@"请输入您宝贵的意见"];
        return;
    } else if ([_textView.text length] > 140) {
        
        [UIAlertController alertMessage:@"请输入140个以内的字符" viewController:self];
        return;
    }
    
    if (_isSend) {
        return;
    }
    
    [WVRTrackEventMapping trackEvent:@"feedback" flag:@"send"];
    
    [self disableUI];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *qq =@"^[1-9]\\d{4,10}";
   
    NSString *tel =@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tel];
    
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", qq];
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
   
    if ([emailTest evaluateWithObject:_textField.text]) {
        params[@"email"] = _textField.text;
    }
    else if ([telTest evaluateWithObject:_textField.text]) {
        params[@"telephone"] = _textField.text;
    }
    else if ([qqTest evaluateWithObject:_textField.text]) {
        params[@"qq"] = _textField.text;
    }
    
    params[@"content"] = _textView.text;
    params[@"systemname"] = [UIDevice currentDevice].systemName;
    params[@"systemcode"] = [UIDevice currentDevice].systemVersion;
    params[@"versionname"] = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    params[@"versioncode"] = [infoDictionary objectForKey:@"CFBundleVersion"];
    params[@"model"] = [UIDevice currentDevice].model;
    
    _isSend = YES;
    [self showProgress];
    self.gFeedBackViewModel.params = params;
    [self.gFeedBackViewModel.gFeedBackCmd execute:nil];
}

#pragma mark - action

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key {
    
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin,@"9d02ee2c316e976622980449d9a37b1a678acb0607826da5cd8925dedf28091f"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
        
        return YES;
        
    } else {
        
        return NO;
    }
}

- (void)qqAction:(id)sender {
    
    
    if (![self joinGroup:@"170321770" key:@"HMVyVQ9MJj9awwF4qPj7haS7HqpT13BP"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未安装QQ" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 返回
- (void)backClick:(UIButton *)btn {
    
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
    [WVRTrackEventMapping trackEvent:@"feedback" flag:@"back"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [WVRTrackEventMapping trackEvent:@"feedback" flag:@"contact"];
    self.view.frame = CGRectOffset(self.view.frame, 0, -84);
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.view.frame = CGRectOffset(self.view.frame, 0, 84);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
       
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([textView.text length] > 0) {
        
        [_tips setHidden:YES];
    }
    if ([textView.text length] < 1) {
        
        [WVRTrackEventMapping trackEvent:@"feedback" flag:@"suggestion"];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text length] < 1) {
        
        [_tips setHidden:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([textView.text length] > 140 && text.length > 0) {
        
        return NO;
    }
    [_tips setHidden:YES];
    
    if ([text isEqualToString:@"\n"]) {
        if ([textView.text length] > 1) {
            [_textField becomeFirstResponder];
        }
    }
    return YES;
}

// 跳转到AppStore评论页面（分为应用内加载和跳出应用）
- (void)jumpToStoreProductPage:(UIButton *)sender {
    
    if (sender.tag == 1) {
        // 直接跳转
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/%@", vrManagerAppID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    
    } else {
        //第二中方法  应用内跳转
        SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
        storeProductViewContorller.delegate = self;
//       WVRFeedbackVC  *viewc = [[WVRFeedbackVC alloc] init];
//        __weak typeof(viewc) weakViewController = viewc;
        
        //加载一个新的视图展示
        [storeProductViewContorller loadProductWithParameters: @{ SKStoreProductParameterITunesItemIdentifier:vrManagerAppID } completionBlock:^(BOOL result, NSError *error) {
            
             if(error) {
                 NSLog(@"错误: %@", error);
             } else {
                 
                 [self presentViewController:storeProductViewContorller animated:YES completion:nil];
             }
         }];
    }
}

#pragma mark - SKStoreProductViewControllerDelegate

// 评分取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}

@end
