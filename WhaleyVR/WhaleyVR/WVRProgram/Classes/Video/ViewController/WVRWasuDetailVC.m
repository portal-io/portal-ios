//
//  WVRWasuDetailVC.m
//  VRManager
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 华数3D电影 页面

#import "WVRWasuDetailVC.h"
#import "WVRReachabilityModel.h"
#import "WVRVideoDetailVCModel.h"
#import "WVRScoreLabel.h"
#import "WVRDetailTagView.h"
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
#import "WVRVideoEntityLocal.h"
#import "WVRVideoEntityWasuMovie.h"

#import "WVRProgramBIModel.h"

#import "WVRVideoDetailViewModel.h"
#import "UIAlertController+Extend.h"

#import "WVRMediator+PayActions.h"
#import "WVRUploadViewCountHandle.h"

@interface WVRWasuDetailVC () {
    
    float _layoutLength;
    float _spaceY;
}

@property (nonatomic, strong) WVRVideoDetailVCModel *detailModel;

@property (nonatomic, strong, readonly) WVRVideoDetailViewModel *gVideoDetailViewModel;

//@property (nonatomic, weak) WVRNetErrorView       *netErrorView;

@property (nonatomic, weak) UIScrollView          *scrollView;

@property (nonatomic) WVRSQDownViewInfo * mSQDownViewInfo;
@property (nonatomic) WVRSQDownView * mSQDownView;
@property (nonatomic) WVRVideoModel * mVideoModel;

@property (nonatomic) UIActivityIndicatorView * mSubActivity;

@property (nonatomic) WVRDetailBottomVTool* mBottomVTool;

@property (nonatomic, weak) WVRPublisherView *publisherView;

@end


@implementation WVRWasuDetailVC
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
    
    [_publisherView viewWillAppear];
}

- (void)buildData {
    [super buildData];
    
    _layoutLength = adaptToWidth(15);
    _spaceY = adaptToWidth(20);
}

- (void)dealloc {
    
    DDLogInfo(@"");
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
    
    // 如果有需要的话，把scrollView放在imageView下方位置，改变他的y和高，然后把imageView/playerView独立出来
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEIGHT_BOTTOMV);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view insertSubview:scrollView atIndex:0];
    _scrollView = scrollView;
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.playerContentView.bounds];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:imageView aboveSubview:scrollView];
    
    [self playAction];      // 开始播放
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_layoutLength, imageView.bottomY + _spaceY, SCREEN_WIDTH - 2*kCellTitleDistance, 20)];
    titleLabel.font = kBoldFontFitSize(18.5);
    titleLabel.textColor = k_Color3;
    titleLabel.text = _detailModel.title;
    titleLabel.numberOfLines = 0;
    
    [scrollView addSubview:titleLabel];
    
    // 电影评分
    {
        WVRScoreLabel *score = [[WVRScoreLabel alloc] initWithScore:_detailModel.score];
        score.bottomX = SCREEN_WIDTH - adaptToWidth(15);
        score.y = titleLabel.y;
        
        [scrollView addSubview:score];
        
        titleLabel.width = SCREEN_WIDTH - score.width - 3*adaptToWidth(15);
    }
    
    titleLabel.text = _detailModel.title;
    titleLabel.size = [WVRComputeTool sizeOfString:titleLabel.text Size:CGSizeMake(titleLabel.width, MAXFLOAT) Font:titleLabel.font];
    
    // 播放次数
    YYLabel *countLabel = [[YYLabel alloc] initWithFrame:CGRectMake(_layoutLength, titleLabel.bottomY + _layoutLength - 2, titleLabel.width, 20)];
    
    NSString *str = [NSString stringWithFormat:@"  %@次播放", [WVRComputeTool numberToString:[_detailModel.playCount longLongValue]]];
    UIFont *font = kFontFitForSize(13);
    UIImage *image = [UIImage imageNamed:@"icon_playCount"];
    
    NSMutableAttributedString *text = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:str
                                  attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHex:0x898989], NSFontAttributeName:font }]];
    countLabel.attributedText = text;
    CGSize sizeOriginal = CGSizeMake(200, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    
    countLabel.size = layout.textBoundingSize;
    countLabel.textLayout = layout;
    
    [scrollView addSubview:countLabel];
    
    
    float tagX = countLabel.bottomX + adaptToWidth(27);
    if (!_detailModel.playCount) {
        countLabel.hidden = YES;        // 没请求到数据，就不显示
        tagX = countLabel.x;
    }
    
    [self createDurationLabelOrTagsWithX:tagX centerY:countLabel.centerY];
    
    float descY = countLabel.bottomY + 2 * _spaceY;
    
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_layoutLength, countLabel.bottomY + _spaceY, SCREEN_WIDTH - 2 * _layoutLength, 1)];
        line.backgroundColor = kLineBGColor;
        [scrollView addSubview:line];
        
        // infoView
        WVRDetailTagView *infoView = [[WVRDetailTagView alloc] initWithModel:_detailModel];
        infoView.y = descY;
        [scrollView addSubview:infoView];
        
        descY = infoView.bottomY + _spaceY;
    }
    [self createDescViewWithY:descY];
    
    [self createBottomTool];
    
    [self dealWithDetailData];
    
    [super drawUI];     // navBar置顶
}

- (void)createDurationLabelOrTagsWithX:(float)x centerY:(float)centerY {
    
    if (self.detailType == WVRVideoDetailTypeVR) {
        
        UILabel *durationLabel = [[UILabel alloc] init];
        durationLabel.font = kFontFitForSize(13.5);
        durationLabel.textColor = [UIColor colorWithHex:0x898989];
        NSString *str = [WVRComputeTool durationToString:_detailModel.duration.longLongValue];
        str = [NSString stringWithFormat:@"时长：%@", str];
        durationLabel.text = str;
        [durationLabel sizeToFit];
        
        durationLabel.x = x - adaptToWidth(8);
        durationLabel.centerY = centerY;
        
        [_scrollView addSubview:durationLabel];
        
        // 分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(durationLabel.x - adaptToWidth(10), durationLabel.y, 0.8, durationLabel.height)];
        line.backgroundColor = k_Color9;
        
        [_scrollView addSubview:line];
        
    } else {
        
        for (NSString *tag in _detailModel.tags_) {
            
            WVRTagLabel *tagLabel = [[WVRTagLabel alloc] initWithText:tag];
            tagLabel.x = x;
            tagLabel.centerY = centerY;
            
            [_scrollView addSubview:tagLabel];
            x += (adaptToWidth(15.f) + tagLabel.width);
        }
    }
}

- (void)createDescViewWithY:(float)descY {
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(_layoutLength, descY, SCREEN_WIDTH - 2*_layoutLength, 30)];
    descLabel.textAlignment = NSTextAlignmentCenter;
    NSString *string = [NSString stringWithFormat:@"简介：%@", _detailModel.introduction];
    NSAttributedString *attributedString = [WVRUIEngine descStringWithString:string];
    
    descLabel.attributedText = attributedString;
    descLabel.size = [WVRComputeTool sizeOfString:attributedString Size:CGSizeMake(SCREEN_WIDTH - 2 * _layoutLength, MAXFLOAT)];
    descLabel.numberOfLines = 0;
    [_scrollView addSubview:descLabel];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, descLabel.bottomY + adaptToWidth(30));
}

- (void)createBottomTool {
    
    if (!self.mBottomVTool) {
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
        self.mBottomVTool = [WVRDetailBottomVTool loadBottomView:model parentV:self.view];
        [self.mBottomVTool updateDownStatus:self.mVideoModel.downStatus];
        kWeakSelf(self);
        self.mBottomVTool.shareBlock = ^(NSInteger platform) {
            if (platform != kSharePlatformLink) {
                
                [weakself trackEventForShare];
            }
        };
        self.mBottomVTool.didCollection = ^{
            
            [WVRProgramBIModel trackEventForDetailWithAction:BIDetailActionTypeCollectionVR sid:weakself.sid name:weakself.detailModel.title];
        };
        self.mBottomVTool.startDown = ^{
            
            [weakself downloadClick:nil];
        };
    }
}

#pragma mark - getter

- (WVRVideoDetailType)detailType {
    
    return WVRVideoDetailType3DMovie;
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

- (void)uploadViewCount {       // 上传浏览次数
    
    [self uploadCountWithType:@"view"];
}

- (void)uploadPlayCount {
    
    [self uploadCountWithType:@"play"];
}

- (void)uploadCountWithType:(NSString *)type {       // 上传统计次数
    
    [WVRUploadViewCountHandle uploadViewInfoWithCode:_detailModel.sid programType:_detailModel.programType videoType:_detailModel.videoType type:type sec:nil title:nil];
}

#pragma mark - action
// 返回
- (void)leftBarButtonClick {
    
    [WVRTrackEventMapping trackEvent:@"movieDetail" flag:@"back"];
    
    [super leftBarButtonClick];
}

- (void)publisherBtnClick:(UIButton *)sender {
    
    WVRPublisherListVC *vc = [[WVRPublisherListVC alloc] initWithCpCode:self.detailModel.cpCode];
    
    [self.navigationController pushViewController:vc animated:YES];
}

// 下载
- (void)downloadClick:(UIButton *)sender {
    
    SQToast(@"版权原因，暂不提供缓存");
}

- (void)playAction {
    
    [WVRTrackEventMapping trackEvent:@"subjectDetail" flag:@"play"];
    
    [self uploadPlayCount];
    
    WVRVideoEntity *ve = [[WVRVideoEntity360 alloc] init];
    
    NSString *path = [WVRPlayerTool wasuMovieRealPlayUrlWithUrl:_detailModel.playUrl];
    
    // fixbug 11609
    [NSThread sleepForTimeInterval:0.5];
    
    if (nil == path) {
        
        DDLogError(@"链接解析失败");
        
        path = @"";
    }
    ve = [[WVRVideoEntityWasuMovie alloc] init];
    
    ve.needParserURL = path;
    
    ve.videoTitle = _detailModel.title;
    ve.sid = self.sid;
    ve.isChargeable = _detailModel.isChargeable;
    ve.freeTime = _detailModel.freeTime;
    ve.price = _detailModel.price;
    ve.biEntity.totalTime = [_detailModel.duration intValue];
    ve.biEntity.videoTag = self.detailModel.tags;
    ve.renderTypeStr = self.detailModel.renderType;
    ve.biEntity.contentType = self.detailModel.type;
    ve.detailModel = self.detailModel.detailModel;
    
    self.videoEntity = ve;
    [self startToPlay];
}

- (BOOL)reParserPlayUrl {
    
    BOOL canRetry = self.videoEntity.canTryNextPlayUrl;
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
}

- (void)requestData {
    
    [self showProgress];
    
    self.gVideoDetailViewModel.code = self.sid;
    [self.gVideoDetailViewModel.gDetailCmd execute:nil];
}

- (void)detailDataSuccess {
    if(!self.gVideoDetailViewModel.dataModel)
    {
        [self detailNetworkFaild];
        return;
    }
    self.detailModel = self.gVideoDetailViewModel.dataModel;
    self.detailBaseModel = self.gVideoDetailViewModel.dataModel;
    
    self.isCharged = ![self.detailModel isChargeable];    // 是否付费赋初始值
    
    [self queryForCharged];
}

- (void)detailDataFailed {
    
    if ([self.gVideoDetailViewModel.errorModel.errorCode isEqualToString:@"200"]) {
        
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
    
    // 备注：华数视频不支持购买
    
    self.isCharged = YES;
    
    [self drawUI];
}

#pragma mark - Request Error

// 重新请求数据
- (void)re_requestData {
    
//    if (_netErrorView) { [_netErrorView removeFromSuperview]; }
    
    [self requestData];
}

#pragma mark - 华数电影不支持下载

#pragma mark - download

- (WVRVideoModel *)mVideoModel {
    if (!_mVideoModel) {
        _mVideoModel = [[WVRVideoModel alloc] init];
    }
    return _mVideoModel;
}

@end


@implementation WVRTagLabel

- (instancetype)initWithText:(NSString *)text {
    
    self = [super init];
    
    if (self) {
        
        if (text.length > 0) {
            self.text = [NSString stringWithFormat:@"#%@", text];
        } else {
            self.text = @" ";
        }
        self.font = kFontFitForSize(13.f);
        self.textColor = [UIColor colorWithHex:0x29A1F7 alpha:0.6];
        self.textAlignment = NSTextAlignmentCenter;
        
        CGSize size = [WVRComputeTool sizeOfString:self.text Size:CGSizeMake(300, 500) Font:self.font];
        self.bounds = CGRectMake(0, 0, size.width, size.height + 4);
        
        if (text.length > 0) {
            
//            UIColor *color = [UIColor colorWithHex:0x2F99F6];
//            self.layer.borderColor = color.CGColor;
//            self.layer.borderWidth = 0.5;
            self.backgroundColor = [UIColor clearColor];    //[color colorWithAlphaComponent:0.05];
            
//            self.layer.cornerRadius = self.height/2.0;
//            self.clipsToBounds = YES;
        }
    }
    
    return self;
}

@end
