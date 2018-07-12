//
//  WVRUserInfoViewController.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/29/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRUserInfoViewController.h"
#import "WVRSetAvatarViewController.h"
#import "WVRModifyNickNameViewcontroller.h"
#import "WVRModifyPasswordViewController.h"
#import "WVRModifyPhoneNumViewController.h"
#import "WVRConfigCell.h"
#import "WVRUserInfoView.h"
#import "WVRAccountAlertView.h"
#import "WVRUserModel.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"

#import "WVRModifyPhoneNumViewController.h"
#import "WVRUserInfoViewModel.h"

@interface WVRUserInfoViewController ()<WVRUserInfoViewDelegate, WVRAccountAlertViewDelegate>

@property (nonatomic, assign) NSInteger currentClickedBtn;
@property (nonatomic, strong) WVRUserInfoView *contentView;
@property (nonatomic, strong) WVRAccountAlertView *accountAlertView;

@property (nonatomic, strong) WVRUserInfoViewModel * gUserInfoViewModel;

@property (nonatomic, weak) UIButton * gLogOutBtn;

@end


@implementation WVRUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSelf];
    [self configSubviews];
    [self initUserInfoRAC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_contentView.thirdPartyLoginView updateStatusOfQQIcon:[WVRUserModel sharedInstance].QQisBinded WBIcon:[WVRUserModel sharedInstance].WBisBinded WXIcon:[WVRUserModel sharedInstance].WXisBinded];
    [_contentView.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([WVRUserModel sharedInstance].username.length > 0) {
        [_contentView updateNickName:[WVRUserModel sharedInstance].username];
    }
    if ([WVRUserModel sharedInstance].mobileNumber.length > 0) {
        [_contentView updatePhoneNum:[WVRUserModel sharedInstance].mobileNumber];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.contentView.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

-(WVRUserInfoViewModel *)gUserInfoViewModel
{
    if (!_gUserInfoViewModel) {
        _gUserInfoViewModel = [[WVRUserInfoViewModel alloc] init];
    }
    return _gUserInfoViewModel;
}

- (void)initUserInfoRAC {
    @weakify(self);
    [[[RACObserve(self.gUserInfoViewModel, bind) skip:1] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.gUserInfoViewModel.bind) {
            [self httpThirdBindSuccessBlock];
        }else{
            [self httpThirdUNBindSuccessBlock];
        }
    }];
    [[RACObserve(self.gUserInfoViewModel, msg) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString *message = self.gUserInfoViewModel.msg;
        if (message.length>0) {
            [self showMessageToWindow:message];
        }
    }];
    [[RACObserve(self.gUserInfoViewModel, errorModel) skip:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    [RACObserve([WVRUserModel sharedInstance], isLogined) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
             self.gLogOutBtn.hidden = ![WVRUserModel sharedInstance].isLogined;
    }];
}

- (void)configSelf {
    
    [self.navigationItem setTitle:@"个人信息"];
    _currentClickedBtn = -1;
    [self addRightBtn];
}

-(void)addRightBtn
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 70, 44);
    [rightButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [rightButton setTitleColor:k_Color5 forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
//    [rightButton setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"logout_press"] forState:UIControlStateHighlighted];
//    rightButton.layer.borderWidth = 1;
//    rightButton.layer.borderColor = k_Color9.CGColor;
//    [rightButton setBackgroundImageWithColor:k_Color11 forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(logOutOnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.gLogOutBtn = rightButton;
}

-(void)logOutOnClick
{
    [self.contentView logOut];
}

- (void)gotoChangePhoneVC {
    
    WVRModifyPhoneNumViewController *vc = [[WVRModifyPhoneNumViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configSubviews {
    
    __block WVRUserInfoViewController * blockSelf = self;
    _contentView = [[WVRUserInfoView alloc] init];
    _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _contentView.delegate = self;
    _contentView.gotoChangePhoneBlock = ^{
        [blockSelf gotoChangePhoneVC];
    };
    [self.view addSubview:_contentView];
//    _contentView.frame = self.view.bounds;
    
    /* Ensure Alert View */
    _accountAlertView = [[WVRAccountAlertView alloc] init];
    [_accountAlertView setEnableBgTouchDisappear:YES];
    [_accountAlertView setDelegate:self];
}

- (void)updateNickName:(NSString *)nickName {
    
    [_contentView updateNickName:nickName];
}

- (void)updatPhoneNum:(NSString *)phoneNum {
    
    [_contentView updatePhoneNum:phoneNum];
}

- (void)requestFaild:(NSString *)errorStr {
    
    [self hideProgress];
    [self showMessageToWindow:errorStr];
}

#pragma mark - thirdparty bind

- (void)thirdpartyBindClick:(int)tag {
    self.gUserInfoViewModel.isBind = YES;
    self.gUserInfoViewModel.origin = tag;
}

- (UMSocialPlatformType)mappingPlatformType:(NSInteger)tag {
    
    NSDictionary* dic = @{
                          @(QQ_btn_tag):@(UMSocialPlatformType_QQ),
                          @(WX_btn_tag):@(UMSocialPlatformType_WechatSession),
                          @(WB_btn_tag):@(UMSocialPlatformType_Sina)};
    UMSocialPlatformType type = [dic[@(tag)] intValue];
    return type;
}

- (void)httpThirdBindSuccessBlock {
    UMSocialPlatformType platformType = [self mappingPlatformType:self.gUserInfoViewModel.origin];
    if (platformType == UMSocialPlatformType_QQ) {
        [WVRUserModel sharedInstance].QQisBinded = YES;
    }else if (platformType == UMSocialPlatformType_WechatSession) {
        [WVRUserModel sharedInstance].WXisBinded = YES;
    }else if (platformType == UMSocialPlatformType_Sina) {
        [WVRUserModel sharedInstance].WBisBinded = YES;
    }
    [_contentView.thirdPartyLoginView updateStatusOfQQIcon:[WVRUserModel sharedInstance].QQisBinded WBIcon:[WVRUserModel sharedInstance].WBisBinded WXIcon:[WVRUserModel sharedInstance].WXisBinded];
}

#pragma mark - thirdparty unbind

- (void)thirdpartyUNBindClick:(int)tag {
    self.gUserInfoViewModel.isBind = NO;
    self.gUserInfoViewModel.origin = tag;
//    UMSocialPlatformType platformType = [self mappingPlatformType:tag];
//    [self httpThirdpartyUNBindWithOrigin:[self mappinghttpPlatformType:platformType] successBlock:^(WVRUserInfoVCThirdpartyModel* model) {
//        [self httpThirdUNBindSuccessBlock:model.data platformType:platformType];
//    }];
}

- (void)httpThirdUNBindSuccessBlock {
    UMSocialPlatformType platformType = [self mappingPlatformType:self.gUserInfoViewModel.origin];
    if (platformType == UMSocialPlatformType_QQ) {
        [WVRUserModel sharedInstance].QQisBinded = NO;
    }else if (platformType == UMSocialPlatformType_WechatSession) {
        [WVRUserModel sharedInstance].WXisBinded = NO;
    }else if (platformType == UMSocialPlatformType_Sina) {
        [WVRUserModel sharedInstance].WBisBinded = NO;
    }
    [_contentView.thirdPartyLoginView updateStatusOfQQIcon:[WVRUserModel sharedInstance].QQisBinded WBIcon:[WVRUserModel sharedInstance].WBisBinded WXIcon:[WVRUserModel sharedInstance].WXisBinded];
}

#pragma mark - WVRAccountAlertViewDelegate

- (void)ensureView:(WVRAccountAlertView *)ensureView buttonDidClickedAtIndex:(NSInteger)index {
    
    NSLog(@"Click %ld", (long)index);
    
    [_accountAlertView disappearHandle];
    
    if (0 == index) {
        [self thirdpartyUNBindClick:(int)_currentClickedBtn];
    } else if (1 == index) {
        
    }
}

#pragma mark - WVRUserInfoDelegate

- (void)bindView:(WVRUserInfoView *)view buttonClickedAtIndex:(NSInteger)index {
    
    _currentClickedBtn = index;
    
    switch (_currentClickedBtn) {
        case WVRUserInfoStyleAvatar:
        {
            [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_avatar];
            WVRSetAvatarViewController *setAvatarVC = [[WVRSetAvatarViewController alloc] init];
            
            setAvatarVC.image = [WVRUserModel sharedInstance].tmpAvatar;
            [self.navigationController pushViewController:setAvatarVC animated:YES];
        }
            break;
        case WVRUserInfoStyleNickname:
        {
            [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_name];
            WVRModifyNickNameViewcontroller *modifyNickNameVC = [[WVRModifyNickNameViewcontroller alloc] init];
            modifyNickNameVC.nickName = (NSString*)[_contentView.itemViewArray[index] objectForKey:@"info"];
            [self.navigationController pushViewController:modifyNickNameVC animated:YES];
        }
            break;
        case WVRUserInfoStylePassword:
        {
            [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_password];
            WVRModifyPasswordViewController *modifyPasswordVC = [[WVRModifyPasswordViewController alloc] init];
            [self.navigationController pushViewController:modifyPasswordVC animated:YES];
        }
            break;
        case WVRUserInfoStylePhoneNum:
        {
            [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_mobile];
            WVRModifyPhoneNumViewController *modifyPhoneNumVC = [[WVRModifyPhoneNumViewController alloc] init];
            [self.navigationController pushViewController:modifyPhoneNumVC animated:YES];
        }
            break;
        case QQ_btn_tag:
        {
            if ([WVRUserModel sharedInstance].QQisBinded) {
            [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_qqCancel];
                [_accountAlertView setTitle:@"是否要取消绑定"];
                [_accountAlertView showOnView:self.view];
            }else{
                [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_qq];
                [self thirdpartyBindClick:QQ_btn_tag];
            }
        }
            break;
        case WX_btn_tag:
        {
            if ([WVRUserModel sharedInstance].WXisBinded) {
                [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_wechatCancel];
                [_accountAlertView setTitle:@"是否要取消绑定"];
                [_accountAlertView showOnView:self.view];
            }else{
                [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_wechat];
                [self thirdpartyBindClick:WX_btn_tag];
            }
        }
            break;
        case WB_btn_tag:
        {
            if ([WVRUserModel sharedInstance].WBisBinded) {
            [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_weiboCancel];
                [_accountAlertView setTitle:@"是否要取消绑定"];
                [_accountAlertView showOnView:self.view];
            }else{
                [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_weibo];
                [self thirdpartyBindClick:WB_btn_tag];
            }
        }
            break;
        default:
            break;
    }
}

@end
