//
//  WVRVideoDetailVC.m
//  VRManager
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Snailvr. All rights reserved.

// VR详情页面

#import "WVRVideoDetailVC.h"
#import "WVRVideoDetailVCModel.h"

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
#import "WVRWasuDetailVC.h"
#import "UIAlertController+Extend.h"

#import "WVRVideoDetailViewModel.h"

#import "WVRMediator+AccountActions.h"
#import "WVRMediator+PayActions.h"
#import "WVRMediator+SettingActions.h"
#import "WVRUploadViewCountHandle.h"

@interface WVRVideoDetailVC () {
    
    float _layoutLength;
    float _spaceY;
}

@property (nonatomic, strong) WVRVideoDetailVCModel *detailModel;

@property (nonatomic, strong, readonly) WVRVideoDetailViewModel *gVideoDetailViewModel;

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

@property (nonatomic, assign) BOOL isGoWasu;

@end


@implementation WVRVideoDetailVC
@synthesize gVideoDetailViewModel = _tmpVideoDetailViewModel;

- (instancetype)initWithSid:(NSString *)sid {
    self = [super init];
    if (self) {
        
        [self setSid:sid];
    }
    return self;
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
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (_isGoWasu) {
        _isGoWasu = NO;
        NSMutableArray<UIViewController *> *tmpArr = [NSMutableArray array];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if (vc == self) {
                continue;
            }
            [tmpArr addObject:vc];
        }
        self.navigationController.viewControllers = tmpArr;
        
    } else if (self.navigationController) {
        
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
    
    [self.view insertSubview:scrollView atIndex:0];
    _scrollView = scrollView;
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
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
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_layoutLength, _imageView.bottomY + _spaceY, SCREEN_WIDTH - 2*_layoutLength, 20)];
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
    model.duration = self.detailModel.duration;
    model.playCount = self.detailModel.playCount;
    model.thubImageUrl = self.detailModel.smallPic.length>0 ? self.detailModel.smallPic: self.detailModel.lunboPic.length>0 ? self.detailModel.lunboPic:self.detailModel.bigPic;
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
        if (weakself.mVideoModel.downStatus == WVRVideoDownloadStatusDefault) {
            [weakself downloadClick:nil];
        } else {
            [weakself.view addSubview:[weakself createDownloadToastView]];
        }
    };
    self.mBottomVTool.didCollection = ^{
        
        [WVRProgramBIModel trackEventForDetailWithAction:BIDetailActionTypeCollectionVR sid:weakself.sid name:weakself.detailModel.title];
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

- (WVRVideoDetailViewModel *)gVideoDetailViewModel {
    
    if (!_tmpVideoDetailViewModel) {
        _tmpVideoDetailViewModel = [[WVRVideoDetailViewModel alloc] init];
    }
    return _tmpVideoDetailViewModel;
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
    }else{
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
    //暂时当下载开始后的下载按钮设置为下载完成状态.防止下载数据库重复插入同一个下载视频（可以在下载管理界面中去重操作就可以不在这里处理）
    if (self.mVideoModel.downStatus == WVRVideoDownloadStatusDefault) {
        [self updateDownViewWithStatus:WVRSQDownViewStatusDefault];
    } else {
        [self updateDownViewWithStatus:WVRSQDownViewStatusDown];
    }
//    }else if (self.mVideoModel.downStatus == WVRVideoDownloadStatusDown) {
//        [self updateDownViewWithStatus:WVRSQDownViewStatusDown];
//        
//    }else if (self.mVideoModel.downStatus == WVRVideoDownloadStatusDowning) {
//        [self updateDownViewWithStatus:WVRSQDownViewStatusDown];
//    }else if (self.mVideoModel.downStatus == WVRVideoDownloadStatusPause) {
//        [self updateDownViewWithStatus:WVRSQDownViewStatusDown];
//    }
//    else if (self.mVideoModel.downStatus == WVRVideoDownloadStatusDownFail) {
    
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
    
    if (_detailModel.downloadUrl.length == 0) {
        SQToast(@"版权原因，暂不提供缓存");
        return;
    }
    
    @weakify(self);
    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        // 解析链接
        [self parserDownloadUrl:_detailModel.downloadUrl];
        NSLog(@"DownloadItemClick");
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            return nil;
        }];
    }];
    NSDictionary * params = @{@"completeCmd":cmd};
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:params];
}

- (void)playAction {
    
    [WVRTrackEventMapping trackEvent:@"subjectDetail" flag:@"play"];
    
    [self uploadPlayCount];
    
    WVRVideoEntity *ve = [[WVRVideoEntity360 alloc] init];
    
    if (self.detailModel.isFootball) {
        
        ve.mediaDtos = _detailModel.mediaDtos;
        
    } else {
        
        ve.needParserURL = _detailModel.playUrl;
        ve.needParserURLDefinition = [_detailModel definitionForPlayURL];
        ve.playUrls = _detailModel.playUrlArray;
        
        ve.mediaDtos = nil;
    }
    
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
    
    self.gVideoDetailViewModel.code = self.sid;
    [self.gVideoDetailViewModel.gDetailCmd execute:nil];
}

- (void)detailDataSuccess {
    if (!self.gVideoDetailViewModel.dataModel) {
        [self detailNetworkFaild];
        return;
    }
    self.detailModel = self.gVideoDetailViewModel.dataModel;
    self.detailBaseModel = self.gVideoDetailViewModel.dataModel;
    
    self.isCharged = ![self.detailModel isChargeable];    // 是否付费赋初始值
    
    if ([self.detailModel.videoType isEqualToString:VIDEO_TYPE_3D]) {
        
        // fixbug 跳转到3D
        self.isGoWasu = YES;
        WVRWasuDetailVC *vc = [[WVRWasuDetailVC alloc] initWithSid:self.sid];
        vc.curPosition = self.curPosition;
        [self.navigationController pushViewController:vc animated:NO];
        return;
        
    } else {
        
        [self queryForCharged];
    }
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

#pragma mark - download

- (WVRVideoModel *)mVideoModel {
    if (!_mVideoModel) {
        _mVideoModel = [[WVRVideoModel alloc] init];
    }
    return _mVideoModel;
}

- (void)createDownView {
    
    [self.mSQDownView removeFromSuperview];
    self.mSQDownView = nil;
    self.mSQDownViewInfo = nil;
    
    __weak WVRVideoDetailVC * weakSelf = self;
    
    _mSQDownViewInfo = [WVRSQDownViewInfo new];
    _mSQDownViewInfo.startDownBlock = ^{
        [weakSelf downloadClick:nil];
    };
    _mSQDownViewInfo.pauseDownBlock = ^{
        [weakSelf.view addSubview:[weakSelf createDownloadToastView]];
    };
    _mSQDownViewInfo.stopDownBlock = ^{
        [weakSelf.view addSubview:[weakSelf createDownloadToastView]];
    };
    _mSQDownViewInfo.restartDownBlock = ^{
        [weakSelf startDownload];
    };
    
    self.mSQDownView = [[WVRSQDownView alloc] initWithFrame:CGRectMake(0, 0, 53, 33)];
    [self.mSQDownView updateTitle:nil downingTitle:@"已缓存" pauseTitle:nil downTitle:@"已缓存" downFailTitle:nil];
    [self.mSQDownView updateViewWithInfo:_mSQDownViewInfo];
}

- (void)loadDownView:(CGFloat)yFrame {
    
    if (!self.mSQDownView) {
        [self createDownView];
    }
    
    CGRect frame = self.mSQDownView.frame;
    frame.size.width = 53;
    frame.size.height = 33;
    frame.origin.x = SCREEN_WIDTH - frame.size.width - adaptToWidth(15);
    frame.origin.y = yFrame;
    self.mSQDownView.frame = frame;
    [self.mSQDownView updateViewFrame];
    [_scrollView addSubview:self.mSQDownView];
    [_scrollView bringSubviewToFront:self.mSQDownView];
}

- (void)updateDownViewWithStatus:(WVRSQDownViewStatus)downStatus {
    
    [self.mBottomVTool updateDownStatus:self.mVideoModel.downStatus];
    self.mSQDownViewInfo.downStatus = downStatus;
    [self.mSQDownView reloadData];
}

- (void)downloadVideoWithLink:(NSString *)link definition:(NSString *)definition {
    
    [WVRProgramBIModel trackEventForDetailWithAction:BIDetailActionTypeDownloadVR sid:self.sid name:self.detailModel.title];
    
    self.downloadBtn.enabled = NO;
    [self.downloadBtn setTitle:@"已缓存" forState:UIControlStateNormal];
    
    NSLog(@"下载清晰度: - %@", definition);
    SQHideProgress;
    WVRDownloadDto *dto = [_detailModel.downloadDtos firstObject];
    self.mVideoModel.renderType = [WVRVideoEntity renderTypeForStreamType:self.videoEntity.streamType definition:definition renderTypeStr:dto.renderType];
    self.mVideoModel.definition = definition;
    self.mVideoModel.renderTypeStr = dto.renderType;
    
    [self.mVideoModel save];
    
    NSString *tmpURL = [[link componentsSeparatedByString:@"?"] firstObject];
    NSString *subfix = [[tmpURL componentsSeparatedByString:@"."] lastObject];
    NSString *sid = [self.sid stringByAppendingPathExtension:subfix];
    [self prepareDownload:link sid:sid];
}

#pragma mark - download

- (void)prepareDownload:(NSString *)downLink sid:(NSString *)sid {
    
    self.mVideoModel.downLink = downLink;
    [self.view addSubview:[self createDownloadToastView]];
    [self startDownload];
}

- (void)startDownload {
    if (![self.mVideoModel pathToFile]) {
        SQToast(@"缓存失败，请重新缓存");
        return;
    }
    self.mVideoModel.downStatus = WVRVideoDownloadStatusPrepare;
    [self updateDownViewWithStatus:WVRSQDownViewStatusPrepare];
    self.mVideoModel.isDownload = YES;
    [self.mVideoModel save];
    [[WVRMediator sharedInstance] WVRMediator_LocalAddDownloadTask:@{@"videoModel":self.mVideoModel}];
}

- (BOOL)checkLogin {
    
    if ([[WVRUserModel sharedInstance] isisLogined]) {
        return YES;
    }
    
    @weakify(self);
    RACCommand *successCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            [self showProgress];
            [self parserDownloadUrl:self.detailModel.downloadUrl];
            
            return nil;
        }];
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"alertTitle"] = @"您需要登录才能缓存视频到本地\n确定登录吗？";
    dict[@"completeCmd"] = successCmd;
    
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:dict];
    
    return NO;
}

#pragma mark - download url parser

- (UIView *)loadingView {
    
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.frame];
        _loadingView.backgroundColor = [UIColor blackColor];
        _loadingView.alpha = 0.3;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenLoadingView)];
        [_loadingView addGestureRecognizer:tap];
        _loadingView.userInteractionEnabled = YES;
    }
    return _loadingView;
}

- (void)showLoadingView {
    [self.view addSubview:self.loadingView];
    [self.view bringSubviewToFront:self.loadingView];
    if (!self.mActivity) {
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake((SCREEN_WIDTH-adaptToWidth(100))/2, (SCREEN_HEIGHT-adaptToWidth(100))/2, 100, 100);
        self.mActivity = activity;
    }
    [self.mActivity startAnimating];
    [self.view addSubview:self.mActivity];
    [self.view bringSubviewToFront:self.mActivity];
}

- (void)hidenLoadingView {
    
    [self.loadingView removeFromSuperview];
    [self.mActivity stopAnimating];
    [self.mActivity removeFromSuperview];
}

- (void)parserDownloadUrl:(NSString *)url {
    
    kWeakSelf(self);
    [self showLoadingView];
    
    [WVRParseUrl parserUrl:url callback:^(WVRParserUrlResult *result) {
        
        [weakself performSelectorOnMainThread:@selector(hidenLoadingView) withObject:nil waitUntilDone:NO];
        
        if (!weakself) { return; }
        
        if (result.isSuccessed) {
            
            WVRDownloadDto *dto = [weakself.detailModel.downloadDtos firstObject];
            BOOL isNotCommon = ![WVRVideoEntity isCommonVideoForRenderType:dto.renderType];
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (WVRParserUrlElement *urlElement in result.urlElementList) {
                
                if (isNotCommon) {
                    // 特殊视频类型
                    if (urlElement.defiType != DefinitionTypeST && urlElement.defiType != DefinitionTypeHD) {
                        continue;
                    }
                    
                } else if (result.haveTDA_TDB) {
                    // 常规视频包含TDA和TDB链接
                    if (urlElement.defiType != DefinitionTypeTDA && urlElement.defiType != DefinitionTypeTDB) {
                        continue;
                    }
                    
                } else if (result.haveSDA_SDB) {
                    // 常规视频包含SDA和SDB链接
                    if (urlElement.defiType != DefinitionTypeSDA && urlElement.defiType != DefinitionTypeSDB) {
                        continue;
                    }
                    
                } else {
                    // 常规视频且包含SDA和SDB链接
                    if (urlElement.defiType == DefinitionTypeAUTO) {
                        continue;
                    }
                }
                
                if (nil == urlElement.definition || nil == urlElement.url) { continue; }
                NSDictionary *dict = @{ urlElement.definition : urlElement.url.absoluteString };
                
                [array addObject:dict];
            }
            
            weakself.parserdURLList = [array copy];
            DDLogInfo(@"下载链接 解析成功");
            
            [weakself showDownloadView];
        } else {
            
            DDLogError(@"下载链接 解析失败");
            SQToastInKeyWindow(@"下载地址解析失败");
        }
    }];
}

- (void)showDownloadView {
    
    // 开始下载提示
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    for (NSDictionary *dict in self.parserdURLList) {
        
        NSString *str = [dict.allKeys firstObject];
        NSString *title = [self exchageTypeString:str];
        NSString *link = [dict.allValues firstObject];
        NSString *definition = [dict.allKeys firstObject];
        
        [alertController addAction: [UIAlertAction actionWithTitle:title style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [weakself downloadVideoWithLink:link definition:definition];
        }]];
    }
    [alertController addAction: [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated:YES completion:nil];
}

- (NSString *)exchageTypeString:(NSString *)str {
    
    if ([str isEqualToString:kDefinition_HD]) { return @"原画"; }          // 4k
    if ([str isEqualToString:kDefinition_SD]) { return @"超清（专享）"; }   // 2K 八面体
    if ([str isEqualToString:kDefinition_ST]) { return @"高清"; }          // 2k 球面
    
    if ([str isEqualToString:kDefinition_SDA]) { return @"高清"; }
    if ([str isEqualToString:kDefinition_SDB]) { return @"超清（专享）"; }
    if ([str isEqualToString:kDefinition_TDA]) { return @"超清（专享）"; }
    if ([str isEqualToString:kDefinition_TDB]) { return @"超清（专享）"; }
    
    return @"";
}

#pragma mark - toast

- (UIView *)createDownloadToastView {
    
    WVRBottomToastViewInfo * info = [WVRBottomToastViewInfo new];
    info.title = @"该视频已加入缓存，可以前往本地查看";

    WVRBottomToastView * view = (WVRBottomToastView *)VIEW_WITH_NIB([WVRBottomToastView description]);
//    self.bottomToastView = view;
    view.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44);
    [view updateWithInfo:info];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [view addGestureRecognizer:tap];
    view.userInteractionEnabled = YES;
    [self performSelector:@selector(hideBottomToastV:) withObject:view afterDelay:3];
    
    return view;
}

- (void)hideBottomToastV:(UIView *)view {
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.y = SCREEN_HEIGHT;
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_LocalViewController:NO];
    
    vc.hidesBottomBarWhenPushed = YES;
    
//    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
