//
//  WVRMineController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMineController.h"
#import "WVRMineViewModel.h"
#import "WVRMineSuspendView.h"
#import "WVRMineInfoView.h"
#import <ReactiveObjC/ReactiveObjC.h>

#import "WVRMediator+ProgramActions.h"
#import "WVRMediator+PayActions.h"
#import "WVRMediator+AccountActions.h"
#import "WVRMediator+SettingActions.h"

#import "WVRFeedbackVC.h"
#import "WVRSQHelperController.h"
#import "WVRAboutUsVC.h"
#import "WVRMyTicketVC.h"
#import "WVRMineAvatarCellViewModel.h"
#import "WVRMediator+Currency.h"

#import "WVRPayMethodUseCase.h"
#import "WVRPayGoodsType.h"
#import "WVRSpring2018Manager.h"

#define VR_ManagerAppID (@"963637613")

@interface WVRMineController ()<UIScrollViewDelegate>

@property (nonatomic, strong) WVRMineViewModel * gMineViewModel;

@property (nonatomic, strong) NSDictionary * gGotoSubcribeBlockDic;

@property (nonatomic, strong) NSDictionary * gAvatarClickBlockDic;

@property (nonatomic, weak) UIImageView *headerImageV;

@property (nonatomic, weak) WVRMineSuspendView *suspendView;

@property (nonatomic, weak) WVRMineInfoView *infoView;

@property (nonatomic, strong) WVRPayMethodUseCase *gPayMethodUC;

@end


@implementation WVRMineController
@synthesize gTableView = _gTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.gTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self headerImageV];
    [self infoView];
    
    [self.view addSubview:self.gTableView];
    [self suspendView];
    
    [self bindViewModel:nil];
    [self.gMineViewModel fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self getUserInfo];
    
    [self refreshPurchaseSwitch];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [WVRSpring2018Manager addHomePageEntryForSpring2018];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//
////    self.gTableView.frame = self.view.bounds;
////    self.gTableView.y = -kStatuBarHeight;
////    self.gTableView.height -= kTabBarHeight;
//}

- (void)getUserInfo {
    
    if ([WVRUserModel sharedInstance].isLogined) {
        [[WVRMediator sharedInstance] WVRMediator_GetUserInfo];
    } else {
        [WVRUserModel sharedInstance].isLogined = NO;
        self.headerImageV.image = [UIImage imageNamed:@"mine_header_bg"];
    }
}

/// 请求支付方式接口，打开或关闭 鲸币、券、礼物 入口
- (void)refreshPurchaseSwitch {
    
    if (!self.gPayMethodUC.isRequesting) {
        self.gPayMethodUC.isRequesting = YES;
        [self.gPayMethodUC.getRequestCmd execute:nil];
    }
}

- (void)updateRewardDot:(BOOL)show {
    
}

- (void)createSubviews {
    
}

#pragma mark - bind viewModel

- (void)bindViewModel:(id)viewModel
{
    @weakify(self);
    [[RACObserve([WVRUserModel sharedInstance], isLogined) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([self.navigationController.viewControllers.lastObject isKindOfClass:NSClassFromString(@"WVRBaseUserController")]) {
            [self.navigationController popToViewController:self animated:NO];
        }
    }];
    [self.gMineViewModel.gotoSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        void (^block)(void) = self.gGotoSubcribeBlockDic[x];
        if (block) {
            block();   
        }
    }];
    [self.gMineViewModel.avatarClickSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        void (^block)(void) = self.gAvatarClickBlockDic[x];
        if (block) {
            block();
        }
    }];
    [self.gMineViewModel.updateModelSingal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self showUserViewModel];
    }];
}

- (WVRPayMethodUseCase *)gPayMethodUC {
    if (!_gPayMethodUC) {
        _gPayMethodUC = [[WVRPayMethodUseCase alloc] init];
        _gPayMethodUC.requestForSwitch = YES;
        
        @weakify(self);
        [[_gPayMethodUC buildUseCase] subscribeNext:^(NSArray *list) {
            @strongify(self);
            [self parserPayType:list];
        }];
        [[_gPayMethodUC buildErrorCase] subscribeNext:^(NSArray *list) {
            @strongify(self);
            [self parserPayType:list];
        }];
    }
    return _gPayMethodUC;
}

- (void)parserPayType:(NSArray *)list {
    
    long count = list.count;
    BOOL appInPurchase = NO;
    if (count == 1) {

        NSNumber *num = [list firstObject];
        if (num.intValue == WVRPayMethodAppStore) {

            appInPurchase = YES;
        }
    }

    BOOL entryNeedHide = (count == 0 || (count == 1 && appInPurchase));
    self.suspendView.hidden = entryNeedHide;
}

#pragma mark - gotoNext block dic

- (NSDictionary *)gGotoSubcribeBlockDic
{
    if (!_gGotoSubcribeBlockDic) {
        @weakify(self);
        _gGotoSubcribeBlockDic =
        @{
          @(WVRMineCellTypeLocal):^{
              @strongify(self);
              [self gotoLocal];
          },
          @(WVRMineCellTypeCollection):^{
              @strongify(self);
              [self gotoCollection];
          },
          @(WVRMineCellTypeFeedBack):^{
              @strongify(self);
              [self gotoFeedBack];
          },
          @(WVRMineCellTypeHelper):^{
              @strongify(self);
              [self gotoHelper];
          },
          @(WVRMineCellTypeOfficel):^{
              @strongify(self);
              [self gotoOfficel];
          },
          @(WVRMineCellTypeSocre):^{
              @strongify(self);
              [self gotoSocre];
          },
          @(WVRMineCellTypeAbount):^{
              @strongify(self);
              [self gotoAbount];
          },
          @(WVRMineCellTypeSetting):^{
              @strongify(self);
              [self gotoSetting];
          }
          };
    }
    return _gGotoSubcribeBlockDic;
}

/// 本地缓存
- (void)gotoLocal {
//    [WVRUserModel sharedInstance].isLogined = YES;
//    return;
    UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_LocalViewController:NO];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/// 我的收藏/播单
- (void)gotoCollection
{
    @weakify(self);
    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_CollectionViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            return nil;
        }];
    }];
    NSDictionary * params = @{ @"completeCmd": cmd };
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:params];
    
//    [WVRLoginTool checkAndAlertLogin:@"需要登录才能查看播单" completeBlock:^(BOOL isLogined) {
//    } loginCanceledBlock:nil];
}

/// 我的奖品
- (void)gotoReward
{
    @weakify(self);
    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_RewardViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [self updateRewardDot:NO];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            return nil;
        }];
    }];
    NSDictionary * params = @{ @"completeCmd": cmd };
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:params];
}

/// 兑换码/券
- (void)gotoTicket {
    @weakify(self);
    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        WVRMyTicketVC *vc = [[WVRMyTicketVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            return nil;
        }];
    }];
    NSDictionary * params = @{ @"completeCmd": cmd };
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:params];
   
}

/// 反馈 现在版本已弃用
- (void)gotoFeedBack
{
    UIViewController * vc = [[WVRFeedbackVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 官方论坛
- (void)gotoOfficel
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithUTF8String:@"http://bbs.whaley.cn/forum-60-1.html"]];
}

/// 使用帮助
- (void)gotoHelper
{
    UIViewController * vc = [[WVRSQHelperController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 去评分
- (void)gotoSocre {
    
    NSString *storeURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review", VR_ManagerAppID]; // https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeURL]];
    
//    NSString *itunesurl = @"itms-apps://itunes.apple.com/cn/app/idXXXXXX?mt=8&action=write-review";
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
}

/// 关于我们
- (void)gotoAbount
{
    UIViewController * vc = [[WVRAboutUsVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 鲸币
- (void)gotoCoin {
    
    @weakify(self);
    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_CurrencyConfigViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            return nil;
        }];
    }];
    NSDictionary * params = @{ @"completeCmd": cmd };
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:params];
}

- (void)suspendButtonClick:(MineSuspendButtonType)type {
    
    switch (type) {
        case MineSuspendButtonTypeCoin:
            [self gotoCoin];
            break;
        case MineSuspendButtonTypeTicket:
            [self gotoTicket];
            break;
        case MineSuspendButtonTypeReward:
            [self gotoReward];
            break;
            
        default:
            break;
    }
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float y = scrollView.contentOffset.y;
    
    if (y > 0) {
        if (y > 100) { return; }
        y = 0;
    }
    
    float transform = 1 - y / (self.headerImageV.height * 1.5);
    self.headerImageV.transform = CGAffineTransformMakeScale(transform, transform);
    
    self.suspendView.y = [self suspendViewY] - y * 0.5;
}

#pragma mark - avatar click block dic

- (NSDictionary *)gAvatarClickBlockDic
{
    if (!_gAvatarClickBlockDic) {
        @weakify(self);
        _gAvatarClickBlockDic =
        @{@(WVRMAvatarClickTypeLogin):^{
            @strongify(self);
            [self gotoLogin];
        },
          @(WVRMAvatarClickTypeRegister):^{
              @strongify(self);
              [self gotoRegister];
          },
          @(WVRMAvatarClickTypeEdit):^{
              @strongify(self);
              [self gotoUserInfo];
          },
          @(WVRMAvatarClickTypeSetting):^{
              @strongify(self);
              [self gotoSetting];
          }
          };
    }
    return _gAvatarClickBlockDic;

}

- (void)gotoLogin
{
    UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_LoginViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoRegister
{
    UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_RegisterViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoSetting
{
    UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_SettingViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoUserInfo
{
    if ([WVRUserModel sharedInstance].isLogined) {
        UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_UserInfoViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self showMessageToWindow:@"请登录"];
    }
}

#pragma mark - init

- (UITableView *)gTableView
{
    if (!_gTableView) {
        _gTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _gTableView.y = self.headerImageV.height;
        _gTableView.height -= kTabBarHeight;
        _gTableView.height -= self.headerImageV.height;
        _gTableView.delegate = self.gMineViewModel.gTableViewAdapter;
        _gTableView.dataSource = self.gMineViewModel.gTableViewAdapter;
        _gTableView.sectionFooterHeight = 0;
        _gTableView.sectionHeaderHeight = 0;
        _gTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptToWidth(15))];
        _gTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        [_gTableView setSeparatorColor:[UIColor grayColor]];
        [_gTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _gTableView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHex:0xebeff2];
        
        kWeakSelf(self);
        self.gMineViewModel.gTableViewAdapter.didScrollBlock = ^(void) {
            [weakself scrollViewDidScroll:weakself.gTableView];
        };
    }
    return _gTableView;
}

- (UIImageView *)headerImageV {
    
    if (!_headerImageV) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, fitToWidth(186.5))];
        imgV.image = [UIImage imageNamed:@"mine_header_bg"];
        
        [self.view addSubview:imgV];
        _headerImageV = imgV;
    }
    
    return _headerImageV;
}

- (WVRMineSuspendView *)suspendView {
    
    if (!_suspendView) {
        WVRMineSuspendView *suspendV = [[WVRMineSuspendView alloc] init];
        suspendV.hidden = YES;
        
        kWeakSelf(self);
        suspendV.btnClickBlock = ^(MineSuspendButtonType type) {
            [weakself suspendButtonClick:type];
        };
        suspendV.y = [self suspendViewY];
        suspendV.centerX = self.view.width * 0.5f;
        [self.view addSubview:suspendV];
        _suspendView = suspendV;
    }
    
    return _suspendView;
}

- (WVRMineInfoView *)infoView {
    if (!_infoView) {
        kWeakSelf(self);
        WVRMineInfoView *infoV = [[WVRMineInfoView alloc] initWithFrame:self.headerImageV.frame];
        infoV.loginClickBlock = ^{
            [weakself gotoLogin];
        };
        infoV.registerClickBlock = ^{
            [weakself gotoRegister];
        };
        infoV.infoClickBlock = ^{
            [weakself gotoUserInfo];
        };
        [self.view addSubview:infoV];
        
        _infoView = infoV;
    }
    return _infoView;
}

- (float)suspendViewY {
    
    return adaptToWidth(112);
}

- (WVRMineViewModel *)gMineViewModel {
    if (_gMineViewModel == nil) {
        _gMineViewModel = [[WVRMineViewModel alloc] init];
    }
    return _gMineViewModel;
}

#pragma mark - reloadData

- (void)showUserViewModel {
    
    [self.gTableView reloadData];
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end
