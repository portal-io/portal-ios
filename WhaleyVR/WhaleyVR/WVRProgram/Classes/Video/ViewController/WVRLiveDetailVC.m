//
//  WVRLiveDetailVC.m
//  WhaleyVR
//
//  Created by Snailvr on 16/8/5.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLiveDetailVC.h"
#import "WVRUMShareView.h"
#import "YYText.h"
//#import "WVRSQLiveDetailModel.h"
#import "SQDateTool.h"
#import "WVRLiveNoticeViewModel.h"

#import "WVRNavigationController.h"

#import "WVRComputeTool.h"

#import "WVRProgramBIModel.h"

#import "WVRPlayerVCLive.h"

#import "WVRMediator+AccountActions.h"
#import "WVRMediator+PayActions.h"

#import "WVRLiveDetailViewModel.h"

#import "WVRLiveNoticeViewModel.h"

#import "WVRMediator+WVRReactNative.h"

@interface WVRLiveDetailVC ()<UIScrollViewDelegate> {
    
    BOOL _isHaveVideo;
    BOOL _isGoLivePlayingPage;      // 一进来就是直播中状态了，直接跳转
}

@property (nonatomic, strong) WVRLiveItemModel *dataModel;

@property (nonatomic, weak) UIScrollView    *scrollView;
@property (nonatomic, weak) UIImageView     *imageView;
@property (nonatomic, weak) UIView          *contentView;
@property (nonatomic, weak) UILabel         *countLabel;
@property (nonatomic, weak) YYLabel         *timeLabel;
@property (nonatomic, weak) YYLabel         *addressLabel;
@property (nonatomic, weak) UILabel         *descLabel;
@property (nonatomic, weak) UIView          *line;
@property (nonatomic, weak) UILabel         *purchasedLabel;

@property (nonatomic, assign) float length;
@property (nonatomic, assign) BOOL isShoppingNow;

//@property (nonatomic, weak  ) WVRNetErrorView       *netErrorView;

//@property (nonatomic) WVRSQLiveDetailModel * mLiveDetailModel;

@property (nonatomic) UIButton * mReserveBtn;
@property (nonatomic) WVRLiveNoticeViewModel * gLiveNoticeViewModel;

@property (nonatomic, strong) UIButton * gShoppingBtn;

@property (nonatomic, strong) WVRLiveDetailViewModel * gLiveDetailViewModel;

@end


@implementation WVRLiveDetailVC

#pragma mark - 生命周期控制相关在父类

- (instancetype)initWithSid:(NSString *)sid {
    self = [super init];
    if (self) {
        
        [self setSid:sid];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBuySuccessNoti object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (_isGoLivePlayingPage) {
        
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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogInfo(@"");
}

#pragma mark - notification

- (void)dealWithBuySuccessNoti:(NSNotification *)noti {
    
    if (self.isCharged) { return; }
    NSString *coupon = noti.userInfo[@"goodsCode"];
    
    if ([coupon isEqualToString:self.detailBaseModel.couponDto.code] || [coupon isEqualToString:self.detailBaseModel.contentPackageQueryDto.couponDto.code]) {
        
        self.isCharged = YES;
        [self purchaseBtnHideWithAnimation];
//        [self.playerUI execPaymentSuccess];
    }
}

#pragma mark - UI

- (void)drawUI {
    
    if (!_dataModel) {
        [self navBackSetting];
        return;
    }
    
    if (self.scrollView) { return; }
    self.detailBaseModel = self.dataModel;
    
    [self trackEventForBrowseDetailPage];
    
    _length = adaptToWidth(15);
    
    [self navShareSetting];
    
    [self createScrollView];
    
    [self createImageView];
    
    [self createContentView];
    
//    [self playAction];
    
    [self createTimeLabel];
    [self createAddressLabel];
    [self createHavePurchasedLabelIfNeed];
    
    [self createDescLabel];
    
    if (_dataModel.guests.count > 0) {      // 阵容成员
        
        [self createLine];
        [self createMembers];
    }
    
    [self addShoppingBtn];
    
    [super drawUI];     // 自定义导航置顶
}

- (void)createScrollView {
    
    // 如果有需要的话，把scrollView放在imageView下方位置，改变他的y和高，然后把imageView/playerView独立出来
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
//    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)createImageView {
    
    float height = roundf(SCREEN_WIDTH / 18.f * 11);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    
    [imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:self.dataModel.thubImageUrl] placeholderImage:HOLDER_IMAGE options:SDWebImageRetryFailed progress:nil completed:nil];
    [self.view addSubview:imageView];
    _imageView = imageView;
}

- (void)createContentView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.bottomY, self.view.width, adaptToWidth(60))];
    contentView.backgroundColor = k_Color1;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [WVRAppModel fontFitForSize:13];
    label.textColor = [UIColor whiteColor];
    label.text = @"当前预约人数:";
    [label sizeToFit];
    label.x = _length;
    label.centerY = contentView.height / 2.f;
    [contentView addSubview:label];
    
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    // liveOrderCount       当前预约人数
    // liveOrdered          是否已预约
    // timeLeftSeconds      距离开播时间
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.x = label.bottomX + adaptToWidth(5);
    [_contentView addSubview:countLabel];
    _countLabel = countLabel;
    
    [self updateCountLabel:_dataModel.liveOrderCount];
    [contentView addSubview:[self createReserveBtn]];
    self.mReserveBtn.bottomX = self.view.width - adaptToWidth(15);
    self.mReserveBtn.centerY = label.centerY;
}

- (void)createTimeLabel {
    
    // 播放次数 或 开播时间
    YYLabel *timeLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, _contentView.bottomY + adaptToWidth(20), 60, 20)];
    
    UIFont *font = kFontFitForSize(13);
    
//    timeLabel.attributedText = [self lastTimeStr:_dataModel.beginTime];
    [self timeForSecond:(0 - self.dataModel.timeLeftSeconds)];
    
    timeLabel.top = _contentView.bottomY + fitToWidth(30.f);
    
    // 距离2017.02.24 09:25 开播还有 1 天
    
    NSString *str = [SQDateTool year_month_day_hour_minute:[_dataModel.beginTime doubleValue]];
    str = [NSString stringWithFormat:@"  %@", str];
    str = [NSString stringWithFormat:@"距离%@ 开播还有", str];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if (self.dataModel.timeLeftSeconds > 0) {
        
        [text appendAttributedString:[[NSAttributedString alloc]
                                      initWithString:str
                                      attributes:@{ NSForegroundColorAttributeName:k_Color3, NSFontAttributeName:font }]];
        NSAttributedString *time = [self timeForSecond:self.dataModel.timeLeftSeconds];
        
        [text appendAttributedString:time];
        timeLabel.attributedText = text;
        
    } else {
        
        text = [[NSMutableAttributedString alloc] initWithString:@"即将开播"];
    }
    CGSize sizeOriginal = CGSizeMake(self.view.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    
    timeLabel.size = layout.textBoundingSize;
    timeLabel.textLayout = layout;
    timeLabel.centerX = self.view.width / 2.f;
    
    [_scrollView addSubview:timeLabel];
    _timeLabel = timeLabel;
}

- (void)createAddressLabel {
    
    // 直播地址
    YYLabel *addressLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, _timeLabel.bottomY + adaptToWidth(8), self.view.width, 30)];
    
    UIFont *font = kFontFitForSize(13);
    
    UIImage *image = [UIImage imageNamed:@"icon_area_black"];
//    NSString *address = _dataModel.address;
//    if (address.length > 10) {
//        address = [address substringToIndex:10];
//    }
    NSString *str = [NSString stringWithFormat:@"  %@", _dataModel.address];
    
    NSMutableAttributedString *text = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:str
                                  attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHex:0x898989], NSFontAttributeName: font }]];
    
    addressLabel.attributedText = [text copy];
    
    CGSize sizeOriginal = CGSizeMake(self.view.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    addressLabel.size = layout.textBoundingSize;
    addressLabel.textLayout = layout;
    
    addressLabel.centerX = _timeLabel.centerX;
    
    [_scrollView addSubview:addressLabel];
    _addressLabel = addressLabel;
}

- (void)createHavePurchasedLabelIfNeed {
    
    // 该付费节目仅能购买合集，此节目没有对应券（0704修改，此种情况也要显示已有观看券）
    
    if (![WVRUserModel sharedInstance].isLogined) { return; }
    if (!self.dataModel.isChargeable || !self.dataModel.haveCharged) { return; }
    
    float width = adaptToWidth(65);
    float tmpWidth = (_addressLabel.width + 7 + width);
    _addressLabel.x = (self.view.width - tmpWidth) * 0.5;
    
    if (self.purchasedLabel) {
        
        _purchasedLabel.centerY = self.addressLabel.centerY;
        _purchasedLabel.x = self.addressLabel.bottomX + 7;
        
        return;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, adaptToWidth(17))];
    
    label.centerY = self.addressLabel.centerY;
    label.x = self.addressLabel.bottomX + 7;
    
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
}

- (void)createDescLabel {
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(_length, _addressLabel.bottomY + adaptToWidth(20), self.view.width - 2 * _length, 30)];
    NSString *string = [NSString stringWithFormat:@"%@：%@", @"简介", _dataModel.intrDesc];
    NSAttributedString *attributedString = [WVRUIEngine descStringWithString:string];
    
    descLabel.attributedText = attributedString;
    descLabel.size = [WVRComputeTool sizeOfString:attributedString Size:CGSizeMake(SCREEN_WIDTH-34, MAXFLOAT)];
    descLabel.numberOfLines = 0;
    [_scrollView addSubview:descLabel];
    _descLabel = descLabel;
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _descLabel.bottomY + adaptToWidth(30));
}

- (void)createLine {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _descLabel.bottomY + adaptToWidth(20), self.view.width, 1)];
    line.backgroundColor = kLineBGColor;
    [_scrollView addSubview:line];
    _line = line;
}

- (void)createMembers {
    
    NSArray *picArray = [_dataModel guestPics];
    NSArray *nameArray = [_dataModel guestNames];
    
    UILabel *memberTitle = [[UILabel alloc] initWithFrame:CGRectMake(_length, _line.bottomY + _length, 100, 25)];
    memberTitle.text = @"阵容成员：";
    memberTitle.font = kFontFitForSize(12.5);
    memberTitle.textColor = [UIColor blackColor];
    [_scrollView addSubview:memberTitle];
    
    float imgVWidth = roundf((SCREEN_WIDTH - 4* adaptToWidth(10) - 2*_length)/5.f);
    float imgVSpace = adaptToWidth(10);
    
    int i = 0;
    for (NSString *picURL in picArray) {
        
//        if (picURL.length < 1) { continue; }
        
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(_length + (imgVWidth+imgVSpace)*i, memberTitle.bottomY, imgVWidth, imgVWidth)];
        headView.contentMode = UIViewContentModeScaleAspectFill;
        headView.layer.cornerRadius = imgVWidth/2.0;
        headView.layer.masksToBounds = YES;
        [headView wvr_setImageWithURL:[NSURL URLWithUTF8String:picURL] placeholderImage:HOLDER_IMAGE];
        [_scrollView addSubview:headView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.x, headView.bottomY, headView.width, 25)];
        nameLabel.font = kFontFitForSize(12.5);
        nameLabel.textColor = [UIColor colorWithHex:0x898989];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = nameArray[i];
        [_scrollView addSubview:nameLabel];
        
        i += 1;
    }
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, memberTitle.bottomY + imgVWidth + adaptToWidth(30));
}

- (void)updateBarStatus:(CGFloat)alpha {
    
    if (alpha > 1) { alpha = 1; }
    
    self.bar.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    self.bar.tintColor = [UIColor colorWithWhite:1 - alpha alpha:1];
}

- (void)navShareSetting {
    
//    [self.bar.gradientLayer removeFromSuperlayer];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    UIImage *backimage = [[UIImage imageNamed:@"icon_manual_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backimage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    
    if (_dataModel.title.length) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, 35)];
        label.textAlignment = NSTextAlignmentLeft;
        NSAttributedString * att = [[NSAttributedString alloc] initWithString:_dataModel.title attributes:[NSDictionary dictionaryWithObjectsAndKeys:[WVRAppModel fontFitForSize:15], NSFontAttributeName, k_Color12, NSForegroundColorAttributeName, nil]];
        label.attributedText = att;
        
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:label];
        item.leftBarButtonItems = @[ backItem, titleItem ];
    } else {
        
        item.leftBarButtonItems = @[ backItem ];
    }
    
    UIImage *image = [[UIImage imageNamed:@"icon_detail_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIBarButtonItem *ShareItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarShareItemClick)];
    
    item.rightBarButtonItems = @[ ShareItem ];
    
    [self.bar pushNavigationItem:item animated:NO];
}

- (UIButton *)createReserveBtn {
    
    if (!self.mReserveBtn) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, adaptToWidth(87),adaptToWidth(39))];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = adaptToWidth(5);
        [btn setTitleColor:k_Color1 forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:k_Color12 size:btn.size] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[WVRAppModel fontFitForSize:15]];
        
        [btn addTarget:self action:@selector(reserveOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.mReserveBtn = btn;
        
    }
    self.hasOrder = self.dataModel.hasOrder;
    [self updateReserveBtn];
    
    return self.mReserveBtn;
}

- (void)reserveStatusUpdate {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_RESERVE_PRESENTER_REFRESH object:nil];
}

- (void)updateReserveBtn {
    
    [self updateReserveBtn:[self.hasOrder boolValue]];
}

- (void)updateReserveBtn:(BOOL)isOrder {
    
    self.mReserveBtn.userInteractionEnabled = YES;
    
    if (isOrder) {
        [self.mReserveBtn setTitle:@"已预约" forState:UIControlStateNormal];
        self.mReserveBtn.alpha = 0.8;
        [self removeShoppingBtn_only];
    } else {
        [self.mReserveBtn setTitle:@"立即预约" forState:UIControlStateNormal];
        self.mReserveBtn.alpha = 1;
    }
}

- (BOOL)checkLogin {
    
    if ([[WVRUserModel sharedInstance] isisLogined]) {
        return YES;
    } else {
//        kWeakSelf(self);
        [self toGoLogin];
//        [UIAlertController alertTitle:@"您需要登录才能预约\n确定登录吗？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
//            [weakself toGoLogin];
//        } cancleHandler:^(UIAlertAction *action) {
//            
//        } viewController:self];
    }
    return NO;
}

- (void)toGoLogin {
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        SQShowProgress;
        [self goReserveLive];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            return nil;
        }];
    }];
    NSDictionary *dict = @{ @"completeCmd":cmd,@"alertTitle": @"您需要登录才能预约\n确定登录吗？"};
    
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:dict];
}

- (void)reserveOnClick:(UIButton *)btn {

    if ([self.hasOrder boolValue]) {
        [self shouldCancelReserveLive];
    } else {
        [self shouldReserveLive];
    }
}

- (void)updateCountLabel:(NSString *)content {
    
    if (!content) {
        DDLogError(@"updateCountLabel error: content == null");
        return;
    }
    
    UIFont* font = [UIFont fontWithName:@"DIN Alternate" size:fitToWidth(30.f)];
//    countLabel.textColor = [UIColor whiteColor];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:content
                                  attributes:@{ NSForegroundColorAttributeName:k_Color12, NSFontAttributeName:font,NSKernAttributeName : @(2.f) }]];
    self.countLabel.attributedText = text;
    [self.countLabel sizeToFit];
    self.countLabel.centerY = self.contentView.height/2.f;
}

- (void)shouldCancelReserveLive {
    
    [self goReserveLive];
}

- (void)shouldReserveLive {
    
    if ([[WVRUserModel sharedInstance] isisLogined]) {

        [self checkGoodsChargeStatus];
    } else {
        @weakify(self);
        RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                @strongify(self);
                [self dealWithReserveLiveCheckLogin];
                
                return nil;
            }];
        }];
        NSDictionary *dict = @{ @"completeCmd":cmd ,@"alertTitle": @"您需要登录才能预约\n确定登录吗？"};
        
        [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:dict];
    }
}

- (void)dealWithReserveLiveCheckLogin {
    
    [self requestReserveStatus];
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            BOOL isCharged = [input boolValue];
            self.isCharged = isCharged;
            if (isCharged) {
                [self removeShoppingBtn_only];
            }
            
            return nil;
        }];
    }];
    
    [self requestProgramIsCharged:cmd];
}

- (void)checkGoodsChargeStatus {
    
    if (self.dataModel.isChargeable) {
        if (self.dataModel.haveCharged) {
            [self removeShoppingBtn];
        } else {
            [self goShopping];
        }
    } else {
        [self goReserveLive];
    }
}

// sec > 0 的时候使用
- (NSAttributedString *)timeForSecond:(long)sec {
    
    long day = sec / 3600 / 24;
    long hour = sec / 3600;
    long min = sec / 60;
    long lastSec = sec%60;
    NSString *str = nil;
    NSAttributedString *attStr = nil;
    if (day >= 1) {
        str = [NSString stringWithFormat:@" %ld 天", day];
        attStr = [self attributedTextStr:str range:NSMakeRange(0, str.length - 1)];
    } else if (hour >= 1) {
        str = [NSString stringWithFormat:@" %ld 小时", hour];
        attStr = [self attributedTextStr:str range:NSMakeRange(0, str.length - 2)];
    } else if (min > 0) {
        str = [NSString stringWithFormat:@" %ld 分钟", min];
        attStr = [self attributedTextStr:str range:NSMakeRange(0, str.length - 2)];
    } else {
        str = [NSString stringWithFormat:@" %ld 秒", lastSec];
        attStr = [self attributedTextStr:str range:NSMakeRange(0, str.length - 1)];
    }
    
    return attStr;
}

#pragma mark - setter

- (void)setIsCharged:(BOOL)isCharged {
    [super setIsCharged:isCharged];
    
    self.dataModel.haveCharged = isCharged;
}

#pragma mark - action

- (void)goReserveLive {
    
    SQShowProgress;
    self.mReserveBtn.userInteractionEnabled = NO;
    
    self.gLiveNoticeViewModel.code = self.dataModel.code;
    if ([self.hasOrder boolValue]) {
        [[self.gLiveNoticeViewModel getLiveNoticecancelCmd] execute:nil];
    } else {
        [[self.gLiveNoticeViewModel getLiveNoticeaddCmd] execute:nil];
    }
}

- (void)doNothing {
    
}

// 分享
- (void)rightBarShareItemClick {
    // 分享功能模块
    
    WVRUMShareView *shareView = [WVRUMShareView shareWithContainerView:self.view
                                       sID:self.sid
                                   iconUrl:self.dataModel.thubImageUrl
                                     title:_dataModel.name
                                     intro:_dataModel.intrDesc
                                     mobId:nil
                                 shareType:WVRShareTypeLive ];
    
    kWeakSelf(self);
    shareView.clickBlock = ^(kSharePlatform platform) {
        if (platform != kSharePlatformLink) {
            
            [WVRProgramBIModel trackEventForShare:[weakself biModel]];
        }
    };
}

#pragma mark - goto living

- (void)jumpToLivePlayingPage:(WVRLiveItemModel *)liveModel {
    
    _isGoLivePlayingPage = YES;
    
    WVRPlayerVCLive *viewController = [[WVRPlayerVCLive alloc] init];
    
    WVRVideoEntityLive *ve = [[WVRVideoEntityLive alloc] init];
    ve.sid = liveModel.linkArrangeValue;
    ve.videoTitle = liveModel.title;
    ve.icon = liveModel.thubImageUrl;
    ve.streamType = STREAM_VR_LIVE;
    
    if ([liveModel respondsToSelector:@selector(displayMode)]) {
        ve.displayMode = [(WVRLiveItemModel *)liveModel displayMode];
    }
    viewController.videoEntity = ve;
    
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - live ended

- (void)exitWithLivePlayEnded {
    
//    SQToastInKeyWindow(kToastLiveOver);
    [self.navigationController popViewControllerAnimated:NO];
    WVRItemModel * itemModel = [[WVRItemModel alloc] init];
    itemModel.linkArrangeValue = self.sid;
    itemModel.linkArrangeType = LINKARRANGETYPE_LIVE;
    itemModel.liveStatus = WVRLiveStatusEnd;
    [self gotoLiveCompleteVC:itemModel];
}

-(void)gotoLiveCompleteVC:( WVRItemModel * )liveModel
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    dict[@"pragramCode"] = liveModel.linkArrangeValue;
    WVRBaseViewController * vc = (WVRBaseViewController*)[[WVRMediator sharedInstance] WVRMediator_WVRReactNativeLiveCompleteVC:dict];
    vc.backDelegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)backForResult:(id)info resultCode:(NSInteger)resultCode
{
//    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - request

- (WVRLiveDetailViewModel *)gLiveDetailViewModel
{
    if (!_gLiveDetailViewModel) {
        _gLiveDetailViewModel = [[WVRLiveDetailViewModel alloc] init];
    }
    return _gLiveDetailViewModel;
}

- (WVRLiveNoticeViewModel *)gLiveNoticeViewModel
{
    if (!_gLiveNoticeViewModel) {
        _gLiveNoticeViewModel = [[WVRLiveNoticeViewModel alloc] init];
    }
    return _gLiveNoticeViewModel;
}

- (void)setUpRequestRAC {
    
    @weakify(self);
    [[self.gLiveDetailViewModel gSuccessSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self liveDetailSuccessBlock:x];
    }];
    [[self.gLiveDetailViewModel gFailSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self detailNetworkFaild];
    }];
    
    [[self.gLiveNoticeViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:x];
    }];
    [[self.gLiveNoticeViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        
    }];
    
    [[self.gLiveNoticeViewModel gAddCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self reserveSuccessBlock];
    }];
    [[self.gLiveNoticeViewModel gAddFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self reserveFailBlock:x];
    }];
    
    [[self.gLiveNoticeViewModel gCancleCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self reserveSuccessBlock];
    }];
    [[self.gLiveNoticeViewModel gCancleFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self reserveFailBlock:x];
    }];
}

- (void)reserveSuccessBlock {
    
    self.hasOrder = [NSString stringWithFormat:@"%d", ![self.hasOrder boolValue]];
    NSString *orderCount = self.countLabel.text;
    if (self.hasOrder.boolValue) {
        
        [WVRProgramBIModel trackEventForDetailWithAction:BIDetailActionTypeReserveLive sid:self.sid name:self.dataModel.title];
        
        orderCount = [NSString stringWithFormat:@"%lld", orderCount.longLongValue + 1];
    } else {
        orderCount = [NSString stringWithFormat:@"%lld", orderCount.longLongValue - 1];
    }
    [self updateCountLabel:orderCount];
    [self updateReserveBtn];
    [self reserveStatusUpdate];
    [self hideProgress];
}

- (void)reserveFailBlock:(NSString *)msg
{
    SQToastInKeyWindow(msg);
    [self hideProgress];
    self.mReserveBtn.userInteractionEnabled = YES;
}

- (void)liveDetailSuccessBlock:(WVRLiveItemModel*)args
{
    if (!args)
    {
        [self detailNetworkFaild];
        return;
    }
    if (args.liveStatus == WVRLiveStatusPlaying) {
        
        // 用户跳转进来的时候已经是直播中了，直接去直播界面
        [self jumpToLivePlayingPage:args];
        
    } else if (args.liveStatus == WVRLiveStatusEnd || (args.sid.length < 1)) {
        
        [self exitWithLivePlayEnded];
        
    } else {
        
        [self hideProgress];
        
        self.dataModel = args;
        
        [self requestProgramIsCharged];
        [self requestReserveStatus];
    }
}

- (void)requestData {
    
//    if (!self.mLiveDetailModel) {
//        self.mLiveDetailModel = [[WVRSQLiveDetailModel alloc] init];
//    }
    [self showProgress];
    self.gLiveDetailViewModel.code = self.sid;
    [self.gLiveDetailViewModel.gDetailCmd execute:nil];
}

- (void)requestProgramIsCharged {
    
    if (!self.dataModel.isChargeable) {     // 无需付费
        
        [self drawUI];
        return;
    }
    
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
    
    [self requestProgramIsCharged:cmd];
}

- (void)requestProgramIsCharged:(RACCommand *)complateCmd {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"goodNo"] = self.dataModel.code;
    param[@"goodType"] = @"live";
    param[@"cmd"] = complateCmd;
    
    [[WVRMediator sharedInstance] WVRMediator_CheckVideoIsPaied:param];
}

- (void)requestReserveStatus {
    
    [self showProgress];
    [[self.gLiveNoticeViewModel getLiveNoticeListCmd] execute:nil];

}

#pragma mark - Request Error

// 重新请求数据
- (void)re_requestData {
    
//    if (_netErrorView) { [_netErrorView removeFromSuperview]; }
    
    [self requestData];
}



#pragma mark - action

- (void)leftBarButtonClick {
    
    [WVRTrackEventMapping trackEvent:@"liveDetail" flag:@"back"];
    
    [super leftBarButtonClick];
}

- (void)goShopping {
    
    [self.view.window endEditing:YES];
    
    [self actionPause];
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSInteger payResult = [input[@"success"] integerValue];
            @strongify(self);
//            if (payResult==1 || payResult==3) {
////                [self toOrientation];
//            }
            BOOL success = (payResult==1);
            [self dealWithPaymentResult:success];
            
            return nil;
        }];
    }];
    
    //    @{ @"itemModel":WVRItemModel, @"streamType":WVRStreamType , @"cmd":RACCommand }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"streamType"] = @(self.videoEntity.streamType);
    dict[@"itemModel"] = self.dataModel;
    dict[@"cmd"] = cmd;
    
    [[WVRMediator sharedInstance] WVRMediator_PayForVideo:dict];
}

- (void)dealWithPaymentResult:(BOOL)isSuccess {
    
    self.isCharged = isSuccess;
    
    if (isSuccess) {
        [self removeShoppingBtn];
//        [self removeShoppingBtn_only];
//        [self requestReserveStatus];
    } else {
        
    }
    
    self.isShoppingNow = NO;
}

- (void)removeShoppingBtn_only {
    
    self.scrollView.height = self.scrollView.height + self.gShoppingBtn.height;
    [self.gShoppingBtn removeFromSuperview];
    
    [self createHavePurchasedLabelIfNeed];
}

- (void)removeShoppingBtn {
    
    self.scrollView.height = self.scrollView.height + self.gShoppingBtn.height;
    [self.gShoppingBtn removeFromSuperview];
    [self.mReserveBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    self.mReserveBtn.alpha = 1;
    
    [self createHavePurchasedLabelIfNeed];
    
    [self goReserveLive];
}

#pragma mark - pravite func

- (NSMutableAttributedString *)attributedTextStr:(NSString *)originStr range:(NSRange)range {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:originStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:15.0f] range:range];
    [str addAttribute:NSFontAttributeName value:kFontFitForSize(15) range:range];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0] range:NSMakeRange(6, 12)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:30.0] range:NSMakeRange(19, 6)];
    return str;
}

- (void)filterReserveCurLive {
    
    [[self.gLiveNoticeViewModel getLiveNoticeListCmd] execute:nil];

}

- (void)httpSuccessBlock:(NSArray *)array {
    SQHideProgress;
    for (WVRLiveItemModel* cur in array) {
        if ([cur.linkArrangeValue isEqualToString:self.dataModel.linkArrangeValue]) {
            self.hasOrder = cur.hasOrder;
            [self updateReserveBtn];
            break;
        }
    }
}

- (void)addShoppingBtn {
    
    if (!self.dataModel.isChargeable) { return; }
    if (self.dataModel.haveCharged) { return; }
    
//    [self.mReserveBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    self.mReserveBtn.alpha = 1;
    CGFloat btnHeight = fitToWidth(45);
    self.scrollView.height = self.scrollView.height - btnHeight;
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-btnHeight, SCREEN_WIDTH, btnHeight)];
    [btn addTarget:self action:@selector(shoppingNow) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat priceYuan = self.dataModel.price;
    
    NSString *titlePrefix = [self.dataModel isProgramSet] ? @"购买合集观看券" : @"购买观看券";
    NSString * buyBtnTitle = [NSString stringWithFormat:@"%@ ¥%@", titlePrefix, [WVRComputeTool numToPriceNumber:priceYuan]];
    
    [btn setTitle:buyBtnTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = k_Color15;
    self.gShoppingBtn = btn;
    [self.view addSubview:btn];
}

- (void)shoppingNow {
    
    _isShoppingNow = YES;
    [self goShopping];
}

#pragma mark - statusBar

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    return _isHaveVideo;   // YES   // does it have video
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}

#pragma mark - BI

/// 对应BI埋点的pageId字段，直播预告页面已重写该方法
- (NSString *)currentPageId {
    
    return @"livePrevue";
}

@end
