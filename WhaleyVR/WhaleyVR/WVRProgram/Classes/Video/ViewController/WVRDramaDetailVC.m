//
//  WVRDramaDetailVC.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRDramaDetailVC.h"
#import "WVRDramaDetailViewModel.h"

#import "WVRComputeTool.h"

#import "WVRSQDownView.h"
#import "WVRVideoModel.h"

#import "WVRNavigationController.h"
#import "WVRBottomToastView.h"

#import "WVRDetailBottomVTool.h"
#import "WVRAttentionModel.h"
#import "WVRHistoryModel.h"

#import "WVRPublisherView.h"
#import "WVRPublisherListVC.h"

#import "WVRVideoEntity360.h"

#import "WVRProgramBIModel.h"

#import "WVRParseUrl.h"

#import "UIAlertController+Extend.h"

#import "WVRVideoDetailViewModel.h"

#import "WVRMediator+AccountActions.h"
#import "WVRMediator+PayActions.h"
#import "WVRMediator+SettingActions.h"
#import "WVRUploadViewCountHandle.h"
#import "WVRPlayerDramaUIManager.h"
#import "WVRDramaPlayStrategy.h"

@interface WVRDramaDetailVC ()<WVRDramaPlayStrategyProtocol> {
    
    float _layoutLength;
    float _spaceY;
    id _rac_handler;        // 防止提前释放
}

@property (nonatomic, strong) WVRInteractiveDramaModel *detailModel;

@property (nonatomic, strong, readonly) WVRDramaDetailViewModel *gVideoDetailViewModel;

@property (nonatomic, strong) WVRDramaPlayStrategy *playStrategy;

@property (nonatomic, weak) UIScrollView          *scrollView;
@property (nonatomic, weak) UIImageView           *imageView;

@property (nonatomic, weak) UIButton *purchaseBtn;
@property (nonatomic, weak) UILabel *purchasedLabel;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) YYLabel *countLabel;


@property (nonatomic) WVRSQDownViewInfo * mSQDownViewInfo;
@property (nonatomic) WVRSQDownView * mSQDownView;
@property (nonatomic) WVRVideoModel * mVideoModel;

@property (nonatomic) UIActivityIndicatorView * mSubActivity;

@property (nonatomic) WVRDetailBottomVTool* mBottomVTool;

@property (nonatomic, weak) WVRPublisherView *publisherView;

@property (nonatomic) UIView * loadingView;
@property (nonatomic) UIActivityIndicatorView * mActivity;

@end


@implementation WVRDramaDetailVC
@synthesize gVideoDetailViewModel = _tmpVideoDetailViewModel;
@synthesize playerUI = _playerUI;

- (instancetype)initWithSid:(NSString *)sid {
    self = [super init];
    if (self) {
        
        [self setSid:sid];
    }
    return self;
}

- (WVRPlayerDramaUIManager *)playerUI {
    if (!_playerUI) {
        
        _playerUI = (id)[[WVRPlayerDramaUIManager alloc] init];
        _playerUI.uiDelegate = (id)self;
        [_playerUI installAfterSetParams];
        if (self.detailBaseModel) {
            [_playerUI updateAfterSetParams];
        }
    }
    return (WVRPlayerDramaUIManager *)_playerUI;
}

- (WVRDramaPlayStrategy *)playStrategy {
    
    if (!_playStrategy) {
        
        _playStrategy = [[WVRDramaPlayStrategy alloc] init];
        _playStrategy.delegate = self;
        
        RAC(_playStrategy, detailModel) = RACObserve(self, detailModel);
        RAC(_playStrategy, vPlayer) = RACObserve(self, vPlayer);
        RAC(_playStrategy, playerUI) = RACObserve(self, playerUI);
    }
    
    return _playStrategy;
}

#pragma mark - 生命周期相关控制在父类

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateVideoModel];
    [_publisherView viewWillAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBuySuccessNoti object:nil];
    
    if (self.playerUI.isGoUnity) {
        
        [self.playerUI execStalled];
        
        @weakify(self);
        __block RACDisposable *handler = [RACObserve(self.playerUI, unityBackParams) subscribeNext:^(id x) {
            
            if (nil != x) {
                
                @strongify(self);
                if (self.view.window) {
                    
                    [self checkPlayerStatusWhenBackFromOtherPage];
                }
                [handler dispose];
            }
        }];
        _rac_handler = handler;
    }
}

- (void)checkPlayerStatusWhenBackFromOtherPage {
    NSArray<NSString *> *arr = self.playerUI.unityBackParams[@"nodeTrack"];
    
    if (![arr lastObject] || [[arr lastObject] isEqualToString:self.playStrategy.currentNode.code]) {
        
        [super checkPlayerStatusWhenBackFromOtherPage];
    } else {
        [self.playStrategy setNodeTrackArray:arr];
        self.curPosition = self.vPlayer.dataParam.position;
        [self playNextNode:self.playStrategy.currentNode isUserSelect:NO];
        [(WVRPlayerDramaUIManager *)[self playerUI] updateDramaStatus:WVRPlayerToolVStatusChoosedDrama];
        
        if (self.playerUI.isLandscape) {
            [WVRAppModel changeStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.navigationController) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithBuySuccessNoti:) name:kBuySuccessNoti object:nil];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(_scrollView.width, MAX(_publisherView.bottomY + 1, self.view.height + 1));
}

- (void)buildData {
    [super buildData];
    
    _layoutLength = adaptToWidth(15);
    _spaceY = adaptToWidth(20);
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogInfo(@"");
}

#pragma mark - notification

- (void)dealWithBuySuccessNoti:(NSNotification *)noti {
    
    if (self.isCharged) { return; }
    NSString *coupon = noti.userInfo[@"goodsCode"];
    
    if ([coupon isEqualToString:self.detailModel.couponDto.code] || [coupon isEqualToString:self.detailModel.contentPackageQueryDto.couponDto.code]) {
        
        self.isCharged = YES;
        [self purchaseBtnHideWithAnimation];
        [self.playerUI execPaymentSuccess];
    }
}

#pragma mark - about UI

- (void)drawUI {
    
    if (!self.detailModel) {         // 初次viewDidLoad触发至此
        [self navBackSetting];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createSubviews];
    });
}

- (void)createSubviews {
    
    [self trackEventForBrowseDetailPage];
    
    [self hideProgress];
    
    [self uploadViewCount];         // 浏览次数上传,这个要在主请求完毕后执行，防止videoType为空
    
    [self createScrollView];
    
    [self createImageView];
    
    [self createPurchaseBtnIfNeed];
    
    [self createNameLabel];
    
    if (!self.detailModel.isChargeable) {
        // 下载
        [self updateVideoModel];
    }
    
    [self createCountLabel];
    
    // 已有观看券Label
    [self createHavePurchasedLabelIfNeed];
    
    float descY = _countLabel.bottomY + 2 * _spaceY;
    
    [self createBottomToolWithY:descY];
    
    [self createPublisherView];
    
    [self playAction];      // 开始播放
    
    [self dealWithDetailData];
    
    [super drawUI];     // navBar置顶
}

- (void)createScrollView {
    
    // 如果有需要的话，把scrollView放在imageView下方位置，改变他的y和高，然后把imageView/playerView独立出来
    //    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEIGHT_BOTTOMV);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    scrollView.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view insertSubview:scrollView atIndex:0];
    _scrollView = scrollView;
}

- (void)createImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.playerContentView.bounds];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:imageView aboveSubview:_scrollView];
    _imageView = imageView;
}

- (void)createPurchaseBtnIfNeed {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    float x = adaptToWidth(15);
    float y_space = adaptToWidth(10);
    float y = _imageView.bottomY + y_space;
    float height = adaptToWidth(45);
    float width = _scrollView.width - 2 * x;
    
    if (!self.isCharged) {
        
        NSString *titlePrefix = [self.detailModel isProgramSet] ? @"购买合集观看券" : @"购买观看券";
        NSString *title = [NSString stringWithFormat:@"%@ ￥%@", titlePrefix, [WVRComputeTool numToPriceNumber:self.detailModel.price]];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.titleLabel.font = kFontFitForSize(17);
        btn.backgroundColor = k_Color15;
        btn.layer.cornerRadius = adaptToWidth(4);
        btn.layer.masksToBounds = YES;
        
        [btn addTarget:self action:@selector(actionGotoBuy) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        btn.alpha = 0;
        height = 0;
        y = _imageView.bottomY;
    }
    [_scrollView addSubview:btn];
    _purchaseBtn = btn;
    
    kWeakSelf(self);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.scrollView).offset(x);
        make.top.mas_equalTo(y);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
}

- (void)createNameLabel {
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_layoutLength, _imageView.bottomY + _spaceY, SCREEN_WIDTH - 2 * _layoutLength, 20)];
    nameLabel.font = kBoldFontFitSize(18.5);
    nameLabel.textColor = k_Color3;
    nameLabel.text = _detailModel.title;
    nameLabel.numberOfLines = 0;
    
    [_scrollView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    float width = SCREEN_WIDTH - 2 * _layoutLength;
    CGSize size = [WVRComputeTool sizeOfString:_nameLabel.text Size:CGSizeMake(width, MAXFLOAT) Font:_nameLabel.font];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(nameLabel.superview).offset(_layoutLength);
        make.top.equalTo(_purchaseBtn.mas_bottom).offset(_layoutLength);
        make.height.mas_equalTo(size.height);
        make.width.mas_equalTo(size.width);
    }];
}

- (void)createCountLabel {
    
    // 播放次数
    YYLabel *countLabel = [[YYLabel alloc] initWithFrame:CGRectMake(_layoutLength, _nameLabel.bottomY + _layoutLength - 2, _nameLabel.width, 20)];
    
    NSString *str = [NSString stringWithFormat:@"  %@次播放", [WVRComputeTool numberToString:[_detailModel.playCount integerValue]]];
    UIFont *font = kFontFitForSize(13);
    UIImage *image = [UIImage imageNamed:@"icon_playCount"];
    
    NSMutableAttributedString *text = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:str
                                  attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHex:0x898989], NSFontAttributeName:font }]];
    countLabel.attributedText = text;
    CGSize sizeOriginal = CGSizeMake(200, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    
    CGSize size = layout.textBoundingSize;
    countLabel.textLayout = layout;
    countLabel.height = size.height;
    countLabel.width = size.width;
    
    [_scrollView addSubview:countLabel];
    _countLabel = countLabel;
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(_layoutLength);
        make.height.mas_equalTo(size.height);
        make.width.mas_equalTo(size.width);
    }];
}

- (void)createHavePurchasedLabelIfNeed {
    
    // 该付费节目仅能购买合集，此节目没有对应券（0704修改，此种情况也要显示已有观看券）
    // || ([self.detailModel contentPackageQueryDto] && [[[self.detailModel contentPackageQueryDto] packageType] == WVRPackageeTypeProgramSet])
    if (!self.detailModel.isChargeable || !self.isCharged) { return; }
    if (self.purchasedLabel) { return; }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, adaptToWidth(65), adaptToWidth(17))];
    label.text = @"已有观看券";
    label.font = kFontFitForSize(10);
    label.textColor = k_Color15;
    label.textAlignment = NSTextAlignmentCenter;
    
    label.layer.cornerRadius = label.height * 0.5;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = label.textColor.CGColor;
    label.layer.borderWidth = 0.5;
    
    [self.scrollView addSubview:label];
    _purchasedLabel = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.mas_right).offset(7);
        make.centerY.equalTo(self.countLabel);
        make.height.mas_equalTo(label.height);
        make.width.mas_equalTo(label.width);
    }];
}

- (void)createPublisherView {
    
    WVRPublisherView *publisherV = [[WVRPublisherView alloc] init];
    publisherV.cpCode = _detailModel.cpCode;
    publisherV.fansCount = _detailModel.fansCount;
    publisherV.isFollow = _detailModel.isFollow;
    publisherV.iconUrl = _detailModel.headPic;
    publisherV.name = _detailModel.name;
    
    [publisherV.button addTarget:self action:@selector(publisherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:publisherV];
    _publisherView = publisherV;
    
    [_publisherView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mBottomVTool.mBottomView.mas_bottom);
        make.left.equalTo(self.scrollView);
        make.height.mas_equalTo(_publisherView.height);
        make.width.mas_equalTo(_publisherView.width);
    }];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)createBottomToolWithY:(float)toolY {
    
    if (self.mBottomVTool) { return; }
    
    WVRTVItemModel * model = [[WVRTVItemModel alloc] init];
    model.detailType = self.detailType;
    model.parentCode = self.sid;
    model.code = self.sid;
    model.name = self.detailModel.displayName;
    model.programType = self.detailModel.programType;
    model.videoType = self.detailModel.videoType;
    model.duration = self.detailModel.duration;//[NSString stringWithFormat:@"%ld", [self.detailModel.duration integerValue]/1000]; // beta 现在后端给返回的duration单位是秒
    model.playCount = self.detailModel.playCount;
    model.thubImageUrl = self.detailModel.smallPic.length > 0 ? self.detailModel.smallPic : (self.detailModel.lunboPic.length > 0 ? self.detailModel.lunboPic : self.detailModel.bigPic);
    model.isChargeable = self.detailModel.isChargeable;
    model.downloadUrl = self.detailModel.downloadUrl;
    model.linkArrangeType = LINKARRANGETYPE_PROGRAM;
    [self shieldUDLRRenderType:model];
    self.mBottomVTool = [WVRDetailBottomVTool loadBottomView:model parentV:_scrollView];
    [self.mBottomVTool updateDownStatus:self.mVideoModel.downStatus];
    kWeakSelf(self);
    self.mBottomVTool.shareBlock = ^(NSInteger platform) {
        if (platform != kSharePlatformLink) {
            
            [weakself trackEventForShare];
        }
    };
    self.mBottomVTool.startDown = ^{
        
        [weakself downloadClick:nil];
    };
    self.mBottomVTool.didCollection = ^{
        
        [WVRProgramBIModel trackEventForDetailWithAction:BIDetailActionTypeCollectionDrama sid:weakself.sid name:weakself.detailModel.title];
    };
    
    [self.mBottomVTool.mBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.countLabel.mas_bottom).offset(_layoutLength);
    }];
}

#pragma mark - getter

- (WVRVideoDetailType)detailType {
    
    return WVRVideoDetailTypeVR;
}

- (NSString *)videoType {
    
    return VIDEO_TYPE_VR;
}

- (WVRDramaDetailViewModel *)gVideoDetailViewModel {
    
    if (!_tmpVideoDetailViewModel) {
        _tmpVideoDetailViewModel = [[WVRDramaDetailViewModel alloc] init];
    }
    return _tmpVideoDetailViewModel;
}

#pragma mark - overwrite func

- (void)syncScrubber {
    [super syncScrubber];
    
    [self.playStrategy checkTipForSyncScrubber];
}

//curIsLastNode

- (void)onVideoPrepared {
    [super onVideoPrepared];
    
    self.videoEntity.biEntity.curIsFirstNode = self.playStrategy.curIsFirstNode;
    self.videoEntity.biEntity.curIsLastNode = self.playStrategy.curIsLastNode;
}

- (void)onCompletion {
    
    BOOL isDeal = [self.playStrategy dealWithNodePlayCompletion];
    
    if (!isDeal) {
        [((WVRPlayerDramaUIManager *)[self playerUI]) updatePlayStatus:WVRPlayerToolVStatusDramaPlayEnd];
        [super onCompletion];
    }
}

- (void)userSeekTo:(long)position {
    
    [self.playStrategy checkTipForSeek:position];
}

- (void)actionRestart {
    
    [self.playStrategy setCurrentNodeForStart:self.detailModel.startNode];
    
    self.videoEntity.needParserURL = [self.playStrategy.currentNode playUrl];
    self.videoEntity.needParserURLDefinition = [self.playStrategy.currentNode definitionForPlayURL];
    
    self.videoEntity.biEntity.curIsFirstNode = self.playStrategy.curIsFirstNode;
    
    [self.vPlayer performSelector:@selector(setDramaStartPlay:) withObject:@(NO)];
    [self dealWithPlayUrl];
}

#pragma mark - WVRDramaPlayStrategyProtocol

- (void)playNextNode:(WVRDramaNodeModel *)node isUserSelect:(BOOL)isUserSelect {
    
    if (!node) {
#if (kAppEnvironmentTest == 1)
        SQToastInKeyWindow(@"node is nil");
#endif
        DDLogError(@"fatal error: node is nil - playNextNode:");
        return;
    }
    
    [self.vPlayer stop];
    
    self.videoEntity.needParserURL = [node playUrl];
    self.videoEntity.renderTypeStr = [node renderTypeForPlayURL];
    self.videoEntity.needParserURLDefinition = [node definitionForPlayURL];
    
    [self.playerUI updatePlayStatus:WVRPlayerToolVStatusSliding];
    [self dealWithPlayUrl];
    
    if (isUserSelect) {
        
        [WVRProgramBIModel trackEventForDramaSelect:[self biModel]];
    }
}

#pragma mark - action

- (void)shieldUDLRRenderType:(WVRTVItemModel *)model {
    
    WVRRenderType renderType = [WVRVideoEntity renderTypeForRenderTypeStr:self.detailModel.renderType];
    switch (renderType) {
        case MODE_RECTANGLE_STEREO:
        case MODE_RECTANGLE_STEREO_TD:
        case MODE_SPHERE_STEREO_LR:
        case MODE_SPHERE_STEREO_TD:
        case MODE_HALF_SPHERE_LR:
        case MODE_HALF_SPHERE_TD:
        case MODE_CYLINDER_STEREO_TD:
        case MODE_HALF_SPHERE:
            model.downloadUrl = nil;
            break;
            
        default:
            break;
    }
}

- (void)updateVideoModel {
    
    WVRVideoModel * dbVideoModel = [WVRVideoModel loadFromDBWithId:self.sid];
    if (dbVideoModel) {
        self.mVideoModel = dbVideoModel;
    } else {
        self.mVideoModel.downStatus = WVRVideoDownloadStatusDefault;
        self.mVideoModel.isDownload = NO;
    }
    self.mVideoModel.name = self.detailModel.displayName;
    self.mVideoModel.itemId = self.sid;
    self.mVideoModel.thubImage = self.detailModel.bigPic;
    self.mVideoModel.intrDesc = self.detailModel.introduction;
    self.mVideoModel.subTitle = self.detailModel.subtitle;
    self.mVideoModel.duration = (NSInteger)[self.detailModel.duration longLongValue];
    NSLog(@"downStatus: %ld", (long)self.mVideoModel.downStatus);
    
    [self.mVideoModel save];
}

- (void)uploadViewCount {       // 上传浏览次数
    
    [self uploadCountWithType:@"view"];
}

- (void)uploadPlayCount {
    
    [self uploadCountWithType:@"play"];
}

- (void)uploadCountWithType:(NSString *)type {       // 上传统计次数
    
    [WVRUploadViewCountHandle uploadViewInfoWithCode:_detailModel.sid programType:_detailModel.programType videoType:_detailModel.videoType type:type sec:nil title:nil];
}

- (void)purchaseBtnHideWithAnimation {
    
    if (self.purchaseBtn.height <= 0) { return; }
    
    [UIView animateWithDuration:0.26 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.purchaseBtn.height = 0;
        self.purchaseBtn.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self createHavePurchasedLabelIfNeed];
        [self.purchaseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }];
}

#pragma mark - action
// 返回
- (void)leftBarButtonClick {
    
    [WVRTrackEventMapping trackEvent:@"videoDetail" flag:@"back"];
    
    [super leftBarButtonClick];
}

- (void)publisherBtnClick:(UIButton *)sender {
    
    WVRPublisherListVC *vc = [[WVRPublisherListVC alloc] initWithCpCode:self.detailModel.cpCode];
    
    [self.navigationController pushViewController:vc animated:YES];
}

// 下载
- (void)downloadClick:(UIButton *)sender {
    
    SQToast(@"版权原因，暂不提供缓存");        // 互动剧不支持收费和下载
}

- (void)playAction {
    
    [WVRTrackEventMapping trackEvent:@"subjectDetail" flag:@"play"];
    
    [self uploadPlayCount];
    
    WVRVideoEntity *ve = [[WVRVideoEntity360 alloc] init];
    
    ve.needParserURL = _detailModel.playUrl;
    ve.needParserURLDefinition = [_detailModel definitionForPlayURL];
//    ve.playUrls = _detailModel.playUrlArray;
    
    ve.videoTitle = _detailModel.title;
    ve.sid = self.sid;
    ve.isChargeable = _detailModel.isChargeable;
    ve.freeTime = _detailModel.freeTime;
    ve.price = _detailModel.price;
    ve.biEntity.totalTime = [_detailModel.duration intValue];
    ve.biEntity.videoTag = self.detailModel.tags;
    ve.renderTypeStr = self.detailModel.renderType;
    ve.isFootball = [self.detailModel isFootball];
    ve.biEntity.contentType = self.detailModel.type;
    ve.detailModel = self.detailModel.detailModel;
    
    ve.biEntity.curIsFirstNode = self.playStrategy.curIsFirstNode;
    
    self.videoEntity = ve;
    [self startToPlay];
}

- (BOOL)reParserPlayUrl {
    
    BOOL canRetry = [self.videoEntity canTryNextPlayUrl];
    if (canRetry) {
        [self.videoEntity nextPlayUrlVE];
    }
    
    return canRetry;
}

#pragma mark - request

- (void)setUpRequestRAC {
    
    @weakify(self);
    [[self.gVideoDetailViewModel gSuccessSignal] subscribeNext:^(WVRVideoDetailViewModel *_Nullable x) {
        @strongify(self);
        [self detailDataSuccess];
    }];
    
    [[self.gVideoDetailViewModel gFailSignal] subscribeNext:^(WVRErrorViewModel *_Nullable x) {
        @strongify(self);
        [self detailDataFailed];
    }];
    [[RACObserve([WVRUserModel sharedInstance], isLogined) skip:1] subscribeNext:^(id  _Nullable x) {
        if ([x boolValue] == NO) {
            return;
        }
        @strongify(self);
        if (![self isCurrentViewControllerVisible]) {
            return;
        }
        [[self.gVideoDetailViewModel gSuccessSignal] subscribeNext:^(WVRVideoDetailViewModel *_Nullable x) {
            @strongify(self);
            [self detailReRequestSuccessForLogin];
        }];
        [[self.gVideoDetailViewModel gDetailCmd] execute:nil];
    }];
}

- (void)detailReRequestSuccessForLogin {
//    self.gVideoDetailViewModel.dataModel.programType = PROGRAMTYPE_DRAMA;
    self.detailModel = self.gVideoDetailViewModel.dataModel;
    self.detailBaseModel = self.gVideoDetailViewModel.dataModel;
    
    self.isCharged = ![self.detailModel isChargeable];    // 是否付费赋初始值
    self.publisherView.isFollow = self.detailModel.isFollow;
    [self queryForChargedAfterLogin];
}

// 查询收费视频是否已经付费
- (void)queryForChargedAfterLogin {
    
    if (self.isCharged) {
        
    } else {
        
        @weakify(self);
        RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                @strongify(self);
                BOOL isCharged = [input boolValue];
                self.isCharged = isCharged;
                
                return nil;
            }];
        }];
        
        RACCommand *failCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                WVRErrorViewModel *errorModel = input;
                NSLog(@"error: %@", errorModel.errorMsg);     // net error
                
                //                @strongify(self);
                //                [self networkFaild];
                return nil;
            }];
        }];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        param[@"goodNo"] = self.detailModel.code;
        param[@"goodType"] = @"recorded";
        param[@"cmd"] = cmd;
        param[@"failCmd"] = failCmd;
        
        [[WVRMediator sharedInstance] WVRMediator_CheckVideoIsPaied:param];
    }
}

- (void)requestData {
    
    [self showProgress];
    
    self.gVideoDetailViewModel.sid = self.sid;
    [self.gVideoDetailViewModel.gDetailCmd execute:nil];
}

- (void)detailDataSuccess {
    if (!self.gVideoDetailViewModel.dataModel) {
        [self detailNetworkFaild];
        return;
    }
//    self.gVideoDetailViewModel.dataModel.programType = PROGRAMTYPE_DRAMA;     // 后端已经返回该字段
    self.detailModel = self.gVideoDetailViewModel.dataModel;
    self.detailBaseModel = self.gVideoDetailViewModel.dataModel;
    
    self.isCharged = ![self.detailModel isChargeable];    // 是否付费赋初始值
    
    [self queryForCharged];
}

- (void)detailDataFailed {
    
    if (self.gVideoDetailViewModel.errorModel.errorCode.integerValue == 200) {
        
        // 节目已失效
        [self leftBarButtonClick];
        SQToastInKeyWindow(kToastProgramInvalid);
        
    } else {
        
        NSLog(@"error: %@", self.gVideoDetailViewModel.errorModel.errorMsg);     // net error
        [self detailNetworkFaild];                    // 主请求失败则请求失败
    }
}

// 查询收费视频是否已经付费
- (void)queryForCharged {
    
    if (self.isCharged) {
        
        [self drawUI];
    } else {
        
        @weakify(self);
        RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                @strongify(self);
                BOOL isCharged = [input boolValue];
                self.isCharged = isCharged;
                [self drawUI];
                
                return nil;
            }];
        }];
        
        RACCommand *failCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                WVRErrorViewModel *errorModel = input;
                NSLog(@"error: %@", errorModel.errorMsg);     // net
                @strongify(self);
                SQToast(kNoNetAlert);
                return nil;
            }];
        }];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        param[@"goodNo"] = self.detailModel.code;
        param[@"goodType"] = @"recorded";
        param[@"cmd"] = cmd;
        param[@"failCmd"] = failCmd;
        
        [[WVRMediator sharedInstance] WVRMediator_CheckVideoIsPaied:param];
    }
}

#pragma mark - Request Error

// 重新请求数据
- (void)re_requestData {
    
//    if (_netErrorView) { [_netErrorView removeFromSuperview]; }
    
    [self requestData];
}

// MARK: - BI

- (NSString *)currentPageId {
    
    return @"dramaDetails";
}

- (WVRProgramBIModel *)biModel {
    
    WVRProgramBIModel *model = [super biModel];
    
    model.currentDramaId = self.playStrategy.lastNode.code;
    model.currentDramaTitle = self.playStrategy.lastNode.title;
    
    model.dramaId = self.playStrategy.currentNode.code;
    model.dramaTitle = self.playStrategy.currentNode.title;
    
    return model;
}

- (NSDictionary *)videoInfo {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"info"] = self.detailModel.originString;
    dict[@"currentNode"] = self.playStrategy.currentNode.code;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (WVRDramaNodeModel *node in self.playStrategy.nodeTrack) {
        if (!node.code) { continue; }
        [arr addObject:node.code];
    }
    dict[@"nodeTrack"] = arr;
    
    return dict;
}

@end
