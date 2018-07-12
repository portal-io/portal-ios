//
//  WVRLaunchImageVC.m
//  VRManager
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 启动图（全景） 、引导页、广告页
// 3.4.3版本新增有效期和显示频率的限制

#import "WVRLaunchImageVC.h"
#import "UnityAppController.h"
#import "WVRFilePathTool.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import "WVRItemModel.h"
#import <WhaleyVRPlayer/WVRPicture.h>
#import "UIImage+Extend.h"
#import "WVRCircleProgressButton.h"

#import "WVRLaunchImageViewModel.h"
#import "WVRProgramBIModel.h"
#import "WVRSQLiteManager.h"

#import "WVRLaunchLoginView.h"

#import "WVRWhaleyHTTPManager.h"
#import "WVRLaunchFlowManager.h"

@interface WVRLaunchImageVC () <UIScrollViewDelegate>

@property (nonatomic, weak) UIImageView         *imageView;             // 闪屏图
@property (nonatomic, weak) UIScrollView        *guideView;             // 引导图
@property (nonatomic, weak) UIView              *panoramaView;          // 全景图

@property (nonatomic, weak) UIPageControl       *pageControl;

@property (nonatomic, strong) NSArray           *bootImageArray;        // 引导页图片数组

@property (nonatomic, weak) WVRCircleProgressButton   *jumpButton;            // 广告图跳过按钮

//@property (nonatomic, strong) WVRLaunchImageViewModel *viewModel;

@property (nonatomic, weak) WVRRecommendItemModel *dataModel;

@property (atomic, assign) BOOL jumpButtonIsClicked;

@end


@implementation WVRLaunchImageVC

static NSString *const kLaunchImageName = @"WhaleyVR.App.LaunchImage";
static NSString *const kLaunchImageKey  = @"kLaunchImage";

static WVRLaunchImageVC *_kLaunchImageVC = nil;
static WVRRecommendItemModel *_kLaunchDataModel = nil;

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];       // attention
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self buildData];           // 初始化界面数据
    
    [self drawUI];              // 如果是后台进前台  只显示闪屏即可
    
//    [self requestForImageURL];
    
    [self showPanoramaImage];
}

- (void)dealloc {
    
    [self stopPanorama];
    
    DDLogInfo(@"WVRLaunchImageVC dealloc");
}

#pragma mark - status bar

// 设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

#pragma mark - build data

//- (void)registRAC {
//
//    [self viewModel];
//
//    @weakify(self);
//    [[[RACObserve(self.viewModel, dataModel) skip:1] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
//
//        @strongify(self);
//        [self httpSuccess];
//    }];
//
//    [[RACObserve(self.viewModel, errorModel) skip:1] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
//
//        @strongify(self);
//        [self httpFailed];
//    }];
//}

//- (WVRLaunchImageViewModel *)viewModel {
//    if (!_viewModel) {
//        _viewModel = [[WVRLaunchImageViewModel alloc] init];
////        [_viewModel ]
//    }
//    return _viewModel;
//}

- (void)buildData {
    
//    [self registRAC];
    
//    if (!_bootImageArray) {
//
//        _bootImageArray = [NSArray arrayWithObjects:@"guideImage1.png", @"guideImage2.png", @"guideImage3.png", nil];
//    }
}

- (void)drawUI {
    
    // 闪屏页层
    UIImageView *img = [[UIImageView alloc] initWithFrame:self.view.bounds];
    img.userInteractionEnabled = YES;
    img.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [img addGestureRecognizer:tapGesture];
    
    [self.view addSubview:img];
    
    _imageView = img;
    
    if (_onlyShowLaunchImage) {         // 后台进前台  只显示闪屏即可
        
        _onlyShowLaunchImage = NO;
        [self showLaunchImage];
        
        return;
    }
    
    // 全景图
    UIView *pView = [[UIView alloc] init];
    
    pView.frame = self.view.bounds;
    [self.view addSubview:pView];
    
    _panoramaView = pView;
}

#pragma mark - page

- (void)showLaunchImage {
    
    self.dataModel = [[WVRLaunchFlowManager shareInstance] findModelByType:WVRRecommndAreaTypeLaunchAD];
    
    if (!self.dataModel.picUrl_.length) {
        
        [self displayMainVC];
        return;
    }
    
    // 先通过showRate字段判断是否符合展示条件，否则直接进入下一个流程
    switch (self.dataModel.showRate) {
            
        case WVRLaunchRecommendShowRateDaily: {
            
            NSTimeInterval t = [[WVRSQLiteManager sharedManager] lastShowTimeForADCode:self.dataModel.code adType:kBootAdTypeAd];
            long days = [NSDate getTimeDifferenceFormTimeInterval:t];
            if (days == 0) {
                
                [self displayMainVC];
                return;
            }
        }
            break;
            
        case WVRLaunchRecommendShowRateOnce: {
            
            NSTimeInterval t = [[WVRSQLiteManager sharedManager] lastShowTimeForADCode:self.dataModel.code adType:kBootAdTypeAd];
            if (t > 0) {
                
                [self displayMainVC];
                return;
            }
        }
            break;
// 在default中处理
//        case WVRLaunchRecommendShowRateEvery:
//            break;
        default:
            
            break;
    }
    
//    [self.imageView wvr_setImageWithURL:[NSURL URLWithString:self.dataModel.picUrl_]];
    
    if (nil != [WVRLaunchFlowManager shareInstance].tmpImageView.image) {
        
        [self showLaunchImageAfterCheck];
        
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (nil == [WVRLaunchFlowManager shareInstance].tmpImageView.image) {
                
                [self displayMainVC];
            } else {
                [self showLaunchImageAfterCheck];
            }
        });
    }
}

- (void)showLaunchImageAfterCheck {
    
    self.imageView.image = [WVRLaunchFlowManager shareInstance].tmpImageView.image;
    
    WVRCircleProgressButton *drawCircleBtn = [[WVRCircleProgressButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-adaptToWidth(60) - adaptToWidth(30), SCREEN_HEIGHT - adaptToWidth(60) - adaptToWidth(30), adaptToWidth(50), adaptToWidth(50))];
    drawCircleBtn.lineWidth = 2;
    [drawCircleBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [drawCircleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    drawCircleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [drawCircleBtn addTarget:self action:@selector(jumpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_imageView addSubview:drawCircleBtn];
    _jumpButton = drawCircleBtn;
    
    [drawCircleBtn startAnimationDuration:3 completionBlock:^{}];
    [self performSelector:@selector(jumpButtonClick:) withObject:nil afterDelay:3.f];
    
    [[WVRSQLiteManager sharedManager] saveADWithCode:self.dataModel.code adType:kBootAdTypeAd];
}

// 显示全景图
- (void)showPanoramaImage {
    
    if (!_panoramaView) {
        return;
    }
    
    [UIView setAnimationsEnabled:YES];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PanoramaLaunchImage.jpg" ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    WVRPicture *pano = [[WVRPicture alloc] initWithContainerView:_panoramaView MainController:self];
    [pano updateTexture:image ?: [UIImage new]];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch_icon_logo"]];
    logo.centerX = SCREEN_WIDTH * 0.5;
    logo.y = SCREEN_HEIGHT;
    logo.alpha = 0;
    [_panoramaView addSubview:logo];
    
    float lengthY = adaptToWidth(150);
    UIImageView *text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch_icon_door"]];
    text.centerX = logo.centerX;
    text.y = logo.height + lengthY + adaptToWidth(8);
    text.alpha = 0;
    [_panoramaView addSubview:text];
    
    {
        // 3秒后加载主界面
        double delayInSeconds = 2.f;
        __weak typeof(self) weakSelf = self;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {

            [weakSelf stopPanorama];
            [weakSelf showGuidePage];
        });
    }
    
    [UIView animateWithDuration:1.0 delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        logo.alpha = 1;
        logo.y = lengthY;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            text.alpha = 1;
        }];
    }];
}

// 停止
- (void)stopPanorama {
    
    if (_panoramaView) {
        
        [_panoramaView removeFromSuperview];
    }
}

// 显示引导页
- (void)showGuidePage {
    
    [self showLaunchImage];
    
    // warning 为了保证流程正常运行 暂时把此代码放在这里
    [WVRFilePathTool removeCachesInNewAppVersion];              // 新版本特性 清空界面缓存数据
    
    return;
    // 3.1.0版本需求，抛弃此步骤
    
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//
//    BOOL notNewVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:appVersion] boolValue];
//    if (notNewVersion) {
//
//        [self showLaunchImage];
//        return;
//    }
//
//    // 引导页层   // scrollView + guideImage
//
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:scrollView];
//    _guideView = scrollView;
//
//    scrollView.bounces = NO;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.pagingEnabled = YES;
//    scrollView.delegate = self;
//    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * [_bootImageArray count], SCREEN_HEIGHT);
//
//    for (int i = 0 ; i < [_bootImageArray count]; i++)
//    {
//        UIImageView *bootImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        bootImageView.userInteractionEnabled = YES;
//        NSString *path = [[NSBundle mainBundle] pathForResource:[_bootImageArray objectAtIndex:i] ofType:nil];
//        [bootImageView setImage:[UIImage imageWithContentsOfFile:path]];
//        [scrollView addSubview:bootImageView];
//    }
//
//    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, adaptToWidth(80), adaptToWidth(18))];
//    pageControl.numberOfPages = _bootImageArray.count;
//    pageControl.userInteractionEnabled = NO;
//    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.4];
//    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    pageControl.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT - adaptToWidth(115));
//
//    [self.view addSubview:pageControl];
//    _pageControl = pageControl;
//
//
//    UIButton *jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    jumpButton.bounds = CGRectMake(0, 0, SCREEN_WIDTH/2.0, adaptToWidth(65));
//    UIImage *image = [UIImage imageNamed:@"launch_button_enter"];
//    [jumpButton setImage:image forState:UIControlStateNormal];
//    jumpButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    jumpButton.center = CGPointMake(SCREEN_WIDTH * 2.5, SCREEN_HEIGHT - adaptToWidth(69));
//
//    [jumpButton addTarget:self action:@selector(hideGuildView:) forControlEvents:UIControlEventTouchUpInside];
//
//    [scrollView addSubview:jumpButton];

//    // warning 为了保证流程正常运行 暂时把此代码放在这里
//    [WVRFilePathTool removeCachesInNewAppVersion];              // 新版本特性 清空界面缓存数据
}

#pragma mark - action

- (void)displayMainVC {
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        
        UnityAppController *delegate = (UnityAppController *)[UIApplication sharedApplication].delegate;
        [delegate displayMainController];
    }
}

- (void)hidePanoramaView:(UIButton *)sender {
    
    [self stopPanorama];
    [self showGuidePage];
}

- (void)hideGuildView:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _pageControl.alpha = 0.f;
        _guideView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [_pageControl removeFromSuperview];
        [_guideView removeFromSuperview];
        [self showLaunchImage];
    }];
}

//+ (UIImage *)launchImageFromLocalPath {
//
//    NSString *path = [WVRFilePathTool getDocumentWithName:kLaunchImageName];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    UIImage *image = [UIImage imageWithData:data];
//
//    return image;
//}
//
//- (void)removeCacheImage {
//
//    NSString *path = [WVRFilePathTool getDocumentWithName:kLaunchImageName];
//
//    [WVRFilePathTool removeFileAtPath:path];
//
//    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kLaunchImageKey];
//}

// 轻击广告页（图片）手势触发方法
- (void)tapGesture:(UITapGestureRecognizer *)sender {
    
    if (!self.dataModel) { return; }
    
    [WVRProgramBIModel trackEventForAD:[self biModel:NO]];
    
    UnityAppController *delegate = (UnityAppController *)[UIApplication sharedApplication].delegate;
    [delegate displayMainController:self.dataModel];
}

- (void)jumpButtonClick:(UIButton *)sender {
    
    if (self.jumpButtonIsClicked) {
        return;
    }
    self.jumpButtonIsClicked = YES;
    
    __weak typeof(self) weakSelf = self;
    
    float changeInSeconds = 0.4;
    
    dispatch_time_t changeTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(changeInSeconds * NSEC_PER_SEC));
    
    dispatch_after(changeTime, dispatch_get_main_queue(), ^(void) {
        
        if (!weakSelf) { return; }
        
        // 用户主动点击关闭
        if (sender) {
            [WVRProgramBIModel trackEventForAD:[self biModel:YES]];
        }
        
        [UIView animateWithDuration:changeInSeconds animations:^{
            
            weakSelf.imageView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [weakSelf.imageView removeFromSuperview];
            [weakSelf displayMainVC];
        }];
    });
}

//MARK: - use with onlyShowLaunchImage

+ (BOOL)canShowLaunchImage {
    
    NSString *path = [WVRFilePathTool getDocumentWithName:kLaunchImageName];
    BOOL haveImg = [WVRFilePathTool fileExistsAtPath:path];
    
    if (haveImg) { return YES; }
    
    // 没有对应图片 要清除存储字段
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kLaunchImageKey];
    
    return NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    
    _pageControl.currentPage = roundf(scrollView.contentOffset.x/scrollView.width);
}

#pragma mark - request

//- (void)requestForImageURL {
//
//    _kLaunchImageVC = self;
//
//    [self.viewModel.httpCmd execute:nil];
//}

//- (void)httpSuccess {
//
//    WVRRecommendItemModel *model = _viewModel.dataModel;
//    if (model.picUrl_.length > 0) {
//        self.jumpParam = model;
//        [self downloadImage:model.picUrl_];
//    } else {
//        [self removeCacheImage];
//    }
//
//    _kLaunchImageVC = nil;
//}
//
//- (void)httpFailed {
//
//    DDLogInfo(@"%@", _viewModel.errorModel.errorMsg);
//
//    _kLaunchImageVC = nil;
//}

//- (void)downloadImage:(NSString *)url {
//
//    // 判断本地是否已经存在，防止重复下载
//    NSString *localURL = [[NSUserDefaults standardUserDefaults] valueForKey:kLaunchImageKey];
//    if ([localURL isEqualToString:url]) {
//        NSLog(@"%@ —— launch Image is Exist", localURL);
//        return;
//    }
//    [self removeCacheImage];    // 清理掉无用数据
//
//    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//    [downloader downloadImageWithURL:[NSURL URLWithUTF8String:url]
//                             options:SDWebImageDownloaderLowPriority
//                            progress:nil
//                           completed:^(UIImage *image, NSData *imageData, NSError *error, BOOL finished) {
//                               if (image && finished) {
//
//                                   [imageData writeToFile:[WVRFilePathTool getDocumentWithName:kLaunchImageName] atomically:NO];
//
//                                   [[NSUserDefaults standardUserDefaults] setValue:url forKey:kLaunchImageKey];
//
//                                   NSLog(@"LaunchImage 下载/更新成功");
//                               }
//                           }];
//}

#pragma mark - orientation

- (BOOL)shouldAutorotate {
    
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

// MARK: - BI

- (WVRProgramBIModel *)biModel:(BOOL)isClose {
    WVRProgramBIModel *model = [[WVRProgramBIModel alloc] init];
    
    model.biPageId = self.dataModel.sid;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (isClose) {
        
        dict[@"eventId"] = @"close_ad";
    } else {
        dict[@"eventId"] = @"onClick_ad";
    }
    
    dict[@"pageType"] = [NSString stringWithFormat:@"%d", (int)self.dataModel.recommendAreaType];
    dict[@"showTpye"] = [NSString stringWithFormat:@"%d", (int)self.dataModel.showRate];
    
    model.otherParams = dict;
    return model;
}

@end


