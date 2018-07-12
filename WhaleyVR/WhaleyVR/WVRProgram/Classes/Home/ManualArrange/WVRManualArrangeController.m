//
//  WVRSQArrangeMoreController.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 专题列表

#import "WVRManualArrangeController.h"

#import "WVRProgramBIModel.h"

#import "WVRSQArrangeMaCell.h"
//#import "WVRSQTagHorCell.h"
//#import "WVRSQArrangeMAHeader.h"
//#import "WVRManualArrangeShareHeader.h"
//#import "WVRManualAShareCell.h"

#import "WVRNavigationBar.h"
#import "WVRBaseCollectionView.h"
#import "WVRManualArrangePresenter.h"

#import "WVRSpring2018TopicController.h"

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//#import <MobLink/MobLink.h>
//#import <MobLink/MLSDKScene.h>
//#import <WVRBI/WVRBIModel.h>

@interface WVRManualArrangeController () {
    
    BOOL _isNotFirstIn;
    BOOL _isGoSpring2018;
    
    WVRUMShareView *_mShareView;
}

@property (nonatomic, strong) WVRNavigationBar *bar;

@property (nonatomic, strong) UINavigationItem * gBarItem;

@property (nonatomic) UIBarButtonItem *mBackItem;
@property (nonatomic) UIBarButtonItem *mShareItem;

@property (nonatomic, copy) NSString *mobLinkId;

@end


@implementation WVRManualArrangeController
@synthesize gCollectionView = _gCollectionView;
//@synthesize mShareView = _mShareView;

//@synthesize bar;

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.gCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self createNavBar];
    [self.gPresenter fetchData];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareNotfResponse:) name:NAME_NOTF_MANUAL_ARRANGE_SHARE object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [WVRAppModel forceToOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerObserverEvent];
    
    if (_isNotFirstIn) {
        
        [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
    }
    _isNotFirstIn = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [WVRProgramBIModel trackEventForBrowseEnd:[self biModel]];
    
    if (_isGoSpring2018) {
        
        NSMutableArray<UIViewController *> *tmpArr = [NSMutableArray array];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            [tmpArr addObject:vc];
        }
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if (vc == self) {
                [tmpArr removeObject:vc];
            }
        }
        self.navigationController.viewControllers = tmpArr;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.bar setNeedsLayout];
}

- (void)dealloc {
    
    DDLogInfo(@"%@ dealloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Spring 2018

- (void)gotoSpring2018TopicVC:(WVRItemModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        WVRSpring2018TopicController * vc = [[WVRSpring2018TopicController alloc] init];
        vc.createArgs = model;
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
        
        _isGoSpring2018 = YES;
    });
}

#pragma mark - Notification

- (void)registerObserverEvent {      // 界面进入前后台
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    
    [WVRProgramBIModel trackEventForBrowseEnd:[self biModel]];
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    
    [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
}

#pragma mark - getter

- (WVRManualArrangePresenter *)gPresenter {
    
    if (!_gPresenter) {
        _gPresenter = [[WVRManualArrangePresenter alloc] initWithParams:self.createArgs attchView:self];
        _gPresenter.biDelegate = self;
    }
    return _gPresenter;
}

- (UICollectionView *)getCollectionView {
    
    return self.gCollectionView;
}

- (WVRBaseCollectionView *)gCollectionView {
    
    if (!_gCollectionView) {
        _gCollectionView = [[WVRBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        [self.view addSubview:_gCollectionView];
        CGFloat offset = kDevice_Is_iPhoneX? kStatuBarHeight:0;
        [_gCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view).offset(offset);
            make.height.mas_equalTo(self.view.height-offset);
            make.width.mas_equalTo(self.view.width);
        }];
        _gCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return (WVRBaseCollectionView *)_gCollectionView;
}

- (WVRSectionModel *)gSectionModel {
    
    return self.createArgs;
}

#pragma mark - WVRPackBIDelegate

/// 专题、节目包、合集 BI浏览事件触发
- (void)trackEventForPackBrowse {   // 此事件生命周期内只走一次
    
    [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
}

#pragma mark - WVRCollectionViewCProtocol

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate andDataSource:(id<UICollectionViewDataSource>)dataSource {
    
    self.gCollectionView.delegate = delegate;
    self.gCollectionView.dataSource = dataSource;
    
    self.gCollectionView.backgroundColor = [UIColor whiteColor];
}

- (void)reloadData {
    
    self.gBarItem.rightBarButtonItems = @[ self.mShareItem ];
    
    [self requestForMobLinkId];
    
    [self.gCollectionView reloadData];
}

#pragma mark - UI

- (void)createNavBar {
    
    if (self.bar) { return; }
    
    self.bar = [[WVRNavigationBar alloc] init];
    [self.view addSubview:self.bar];
    [self.view bringSubviewToFront:self.bar];
    
    [self navBackSetting];
}

- (void)navBackSetting {
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    UIImage *backimage = [[UIImage imageNamed:@"icon_manual_back"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backimage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    self.mBackItem = backItem;
    item.leftBarButtonItems = @[ backItem ];
    
    UIImage *shareimage = [[UIImage imageNamed:@"icon_video_detail_share"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:shareimage style:UIBarButtonItemStylePlain target:self action:@selector(shareBarButtonClick)];
    self.mShareItem = shareItem;
    item.rightBarButtonItems = @[ shareItem ];
//    item.title = self.gSectionModel.name;
    self.gBarItem = item;
    [self.bar pushNavigationItem:item animated:NO];
    self.mBackItem.tintColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.mShareItem.tintColor = [UIColor colorWithWhite:0.9 alpha:1];
}

- (void)updateBarStatus:(CGFloat)alpha
{
    [self.bar setOverlayDiaphaneity:alpha];
    
    self.mBackItem.tintColor = [UIColor colorWithWhite:MIN(1-alpha, 0.9) alpha:1];
    self.mShareItem.tintColor = [UIColor colorWithWhite:MIN(1-alpha, 0.9) alpha:1];
}

- (void)updateTitle:(NSString *)title
{
    self.gBarItem.title = title;
}

#pragma mark - Action

// 返回
- (void)leftBarButtonClick {
    
    [WVRTrackEventMapping trackEvent:@"subject" flag:@"back"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBarButtonClick {
    // 分享功能模块
    
    WVRUMShareView *shareView = [WVRUMShareView shareWithContainerView:self.view
                                                                   sID:self.gSectionModel.linkArrangeValue
                                                               iconUrl:self.gSectionModel.thubImageUrl
                                                                 title:self.gSectionModel.name
                                                                 intro:self.gSectionModel.intrDesc
                                                                 mobId:nil
                                                             shareType:[self shareType]];
    _mShareView = shareView;
    
    [self.view addSubview:_mShareView];
    
    kWeakSelf(self);
    _mShareView.clickBlock = ^(kSharePlatform platform) {
        if (platform != kSharePlatformLink) {
            
            [WVRProgramBIModel trackEventForShare:[weakself biModel]];
            [weakself shareSuccessAction:platform];
        }
    };
}

- (void)scrollDidScrollingBlock:(CGFloat)y {
    
    if (y > 0) {
        [self updateBarStatus:fabs(y)/kNavBarHeight];
    }
    else {
        [self updateBarStatus:0];
    }
}

- (void)showNetErrorVWithreloadBlock:(void (^)(void))reloadBlock
{
    [super showNetErrorVWithreloadBlock:reloadBlock];
    [self.view bringSubviewToFront:self.bar];
    self.mBackItem.tintColor = [UIColor colorWithWhite:0 alpha:1];
    self.gBarItem.rightBarButtonItems = nil;
}

- (void)requestForMobLinkId {
    
//#warning waiting done
//    MLSDKScene *scene = [[MLSDKScene alloc] initWithMLSDKPath:@"" source:@"" params:@{}];
//    
//    kWeakSelf(self);
//    [MobLink getMobId:scene result:^(NSString *mobid) {
//        weakself.mobLinkId = mobid;
//    }];
}

#pragma mark - data

//- (NSArray *)iconStrs {
//
//    return [NSArray arrayWithObjects:@"share_icon_sina", @"share_icon_wechat", @"share_icon_friends", @"share_icon_qq", @"share_icon_qzone", nil];
//}
//
//- (void)shareNotfResponse:(NSNotification *)notf {
//
//    void(^block)(void) = [self shareBlockDic][notf.object];
//    block();
//}
//
//- (NSDictionary *)shareBlockDic {
//
//    NSString * sinaK = [[self iconStrs] firstObject];
//
//    NSString * wechatK = [self iconStrs][1];
//    NSString * wechatLineK = [self iconStrs][2];
//    NSString * qqK = [self iconStrs][3];
//
//    NSString * qzoneK = [[self iconStrs] lastObject];
//
//    kWeakSelf(self);
//    return @{sinaK:^{
//                [weakself.mShareView shareToIndex:0];
//            },
//             wechatK:^{
//                 [weakself.mShareView shareToIndex:2];
//             },
//             wechatLineK:^{
//                 [weakself.mShareView shareToIndex:4];
//             },
//             qqK:^{
//                [weakself.mShareView shareToIndex:1];
//            },
//             qzoneK:^{
//                [weakself.mShareView shareToIndex:3];
//            }
//             };
//}

#pragma mark - share

- (void)shareSuccessAction:(kSharePlatform)platform {
    
}

- (WVRShareType)shareType
{
    return WVRShareTypeSpecialTopic;
}

#pragma mark - BI

/// 对应BI埋点的pageId字段，合集-节目包页面已重写该方法
- (NSString *)currentPageId {
    
    return @"topic";
}

- (NSString *)biPageId {
    
    return [self.gPresenter biPageId];
}

- (NSString *)biPageName {
    
    return [self.gPresenter biPageTitle];
}

- (WVRProgramBIModel *)biModel {
    
    WVRProgramBIModel *model = [[WVRProgramBIModel alloc] init];
    model.currentPageId = [self currentPageId];
    model.biPageId = [self biPageId];
    model.biPageName = [self biPageName];
    model.isChargeable = [self.gPresenter biIsChargeable];
    
    return model;
}

@end
