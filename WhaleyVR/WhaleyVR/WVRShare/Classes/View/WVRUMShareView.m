//
//  MyUMShareView.m
//  VRManager
//
//  Created by Snailvr on 16/7/5.
//  Copyright © 2016年 Snailvr. All rights reserved.

// WVRShare

#import "WVRUMShareView.h"

#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "WVRShareConst.h"
#import "WVRAppContextHeader.h"
#import "UIView+Extend.h"
#import "Masonry.h"
#import "NSURL+Extend.h"
#import "WVRTrackEventMapping.h"
#import "WVRWidgetToastHeader.h"

//#import <MobLink/MobLink.h>

#define  shareItemId @"MyUMShareViewCellIdentifier"

@interface WVRUMShareView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
}

@property (nonatomic, copy) NSString            * mobLinkId;

@property (nonatomic, weak) UIView              * mainView;
@property (nonatomic, weak) UIButton            * cancelBtn;
@property (nonatomic, weak) UICollectionView    * mCollectionV;

@property (nonatomic, copy) NSString    *sid;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *content;
@property (nonatomic, copy) NSString    *shareURL;
@property (nonatomic, copy) NSString    *shareImgURL;
@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation WVRUMShareView

+ (WVRUMShareView *)shareForAbout {
    
    UIView *containerView = kRootViewController.view;
    
    WVRUMShareView *shareV = [[WVRUMShareView alloc] initWithFrame:containerView.bounds];
    
    shareV.shareURL = [WVRUserModel aboutUsShareLink];
    shareV.shareType = WVRShareTypeAboutUs;
    if (!shareV.imageView) {
        shareV.imageView = [[UIImageView alloc] init];
    }
    shareV.imageView.image = [UIImage imageNamed:@"aboutUS_logo_share"];
    
    shareV.title   = @"微鲸VR，专注于虚拟现实的全生态企业";
    shareV.content = @"微鲸VR集硬件、软件、平台于一体，是国内领先的VR科技企业。";
    // weibo: 微鲸VR专注于虚拟现实，是集硬件、软件、平台于一体的全生态企业，处于国内领先地位，在多领域已展开商业化应用。#微鲸VR#@微鲸VR
    
    [shareV drawUI];
    
    [containerView addSubview:shareV];
    
    [shareV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.size.equalTo(shareV.superview);
    }];
    
    return shareV;
}

+ (WVRUMShareView *)shareWithContainerView:(UIView *)containerView
                                  sID:(NSString *)sid
                              iconUrl:(NSString *)url
                                title:(NSString *)title
                                intro:(NSString *)intro
                             shareURL:(NSString *)shareURL
                            shareType:(WVRShareType)type {
    
    CGRect frame = containerView.bounds;
    if (!containerView) { frame = kRootViewController.view.bounds; }
    
    WVRUMShareView *shareV = [[WVRUMShareView alloc] initWithFrame:containerView.bounds];
    
    if ([url containsString:@"/zoom"]) {
        url = [[url componentsSeparatedByString:@"/zoom"] firstObject];
    }
    [shareV drawUI];
    
    shareV.sid       = sid;
    shareV.content   = intro.length>0? intro:@"众多人气综艺、音乐、体育内容每周更新VR版，只在微鲸VR ~";
    
    if (type == WVRShareTypeSpecialTopic) {
        
        shareV.title = [NSString stringWithFormat:@"VR专区丨 %@", title];
        
    } else if (type == WVRShareTypeNews) {
        
        shareV.title = [NSString stringWithFormat:@"VR资讯丨 %@", title];
        
    } else if (type == WVRShareTypeH5) {
        
        shareV.title = title;
        
    } else if (type == WVRShareTypeMoreTV) {
        
        shareV.title = [NSString stringWithFormat:@"电视剧丨 %@", title];
        
    } else if (type == WVRShareTypeMoreMovie) {
        
        shareV.title = [NSString stringWithFormat:@"电影丨 %@", title];
        
    } else if (type != WVRShareTypeWhaley) {
        
        shareV.title = [NSString stringWithFormat:@"VR全景丨 %@", title];
        
    } else {
        
        shareV.title   = @"微鲸VR丨海量独家内容重磅来袭";
        shareV.content = @"VR版《蒙面唱将猜猜猜》正在热播，1秒带你去现场！更多独家全景视频每天更新，还有明星演唱会、多项体育赛事登陆VR直播！";
    }
    
    shareV.imageView = [[UIImageView alloc] init];
    shareV.shareType = type;
    
    if (url.length < 1) {
        
        shareV.imageView.image = [UIImage imageNamed:@"app_icon"];
        
    } else {
        
        NSURL *tmp = [NSURL URLWithUTF8String:url];
        shareV.shareImgURL = tmp.absoluteString;
    }
    
    if ([shareV.content length] < 1) {
        shareV.content = @"微鲸VR-虚拟现实的任意门";
    }
    
    if (shareURL.length > 0) {
        shareV.shareURL = shareURL;
        NSURL *tmp = [NSURL URLWithUTF8String:url];
        shareV.shareImgURL = tmp.absoluteString;
    }
    
    [containerView addSubview:shareV];        // 传入nil此行代码则无效
    
    [shareV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.size.equalTo(shareV.superview);
    }];
    
    return shareV;
}

+ (WVRUMShareView *)shareWithContainerView:(UIView *)containerView sID:(NSString *)sid iconUrl:(NSString *)url title:(NSString *)title intro:(NSString *)intro mobId:(NSString *)mobId shareType:(WVRShareType)type {
    
    WVRUMShareView *shareV = [WVRUMShareView shareWithContainerView:containerView sID:sid iconUrl:url title:title intro:intro shareURL:nil shareType:type];
    shareV.mobLinkId = mobId;
    
    return shareV;
}

#pragma mark - getter

- (NSArray *)shareTypes {
    
//        // 0 新浪微博 1 QQ好友 2 微信好友 3 QQ空间 4 微信朋友圈 5 复制链接
//        0UMSocialPlatformType_Sina,
//        1UMSocialPlatformType_WechatSession,
//        2UMSocialPlatformType_WechatTimeLine,
//        4UMSocialPlatformType_QQ,
//        5UMSocialPlatformType_Qzone,
//        @[ @0, @4, @5, @"CustomPlatform"];
    
    return @[ @0, @4, @1, @5, @2, @"CustomPlatform" ];
}

- (NSArray *)shareIconArray {
    
//  [NSArray arrayWithObjects:@"share_icon_sina", @"share_icon_qq", @"share_icon_qzone",  @"share_icon_link", nil];//暂时去掉微信相关
    
    return [NSArray arrayWithObjects:@"share_icon_sina", @"share_icon_qq",  @"share_icon_wechat", @"share_icon_qzone", @"share_icon_friends", @"share_icon_link", nil];
}

- (NSArray *)pressShareIconArray {
    
//  [NSArray arrayWithObjects:@"share_icon_sina_press", @"share_icon_qq_press", @"share_icon_qzone_press", @"share_icon_link_press", nil];
    
    return [NSArray arrayWithObjects:@"share_icon_sina_press", @"share_icon_qq_press",  @"share_icon_wechat_press", @"share_icon_qzone_press", @"share_icon_friends_press", @"share_icon_link_press", nil];
}

#pragma mark - UI

- (void)drawUI {
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 225)];
    mainView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:mainView];
    _mainView = mainView;
    
    _mainView.backgroundColor = [UIColor redColor];
    _mainView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addMainViewCont:_mainView inSec:self];
    
    UIButton *cancelBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn_ setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn_ setFrame:CGRectMake(0, 225 - 66, SCREEN_WIDTH, 66)];
    
    [cancelBtn_ addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn_ setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [cancelBtn_ setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [_mainView addSubview:cancelBtn_];
    _cancelBtn = cancelBtn_;
    _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self addCanlBtnViewCont:_cancelBtn inSec:_mainView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:shareItemId];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    [_mainView addSubview:collectionView];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mCollectionV = collectionView;
    
    [self addCollectionViewCont:collectionView inSec:_mainView];

    // usingSpringWithDamping:0.2 // 类似弹簧振动效果 0~1
    // initialSpringVelocity:10.0 // 初始速度
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _mainView.y = SCREEN_HEIGHT - 225;
                         [weakself setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2f]];
                         
                     } completion:^(BOOL finished) {
                         
                         weakself.userInteractionEnabled = YES;
                     }];
}

#pragma mark - action

// 为了方便开放的API
// 0 新浪微博 1 QQ好友 2 微信好友 3 QQ空间 4 微信朋友圈 5 复制链接
- (void)shareToIndex:(kSharePlatform)index {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    
    [self shareBtnClicked:button];
}

- (void)shareBtnClicked:(UIButton *)button {
    
    NSString *shareUrl = [self shareUrlForShareType:_shareType];
    
    kSharePlatform sharePlatform = button.tag;
    
    if (self.clickBlock) {
        self.clickBlock(sharePlatform);
    }
    
    UIImage *shareImage = [self imageCompressWithSimple:_imageView.image scale:120/_imageView.image.size.width];
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    switch (sharePlatform) {
        case kSharePlatformSina: { // 新浪微博
            
            [WVRTrackEventMapping recommendCellExtendShareWeibo:_sid];
            shareImage = [self imageCompressWithSimple:_imageView.image scale:((SCREEN_WIDTH-60)/_imageView.image.size.width)];
            
            if (_shareType == WVRShareTypeWhaley) { _title = _content; }
            
            NSString *shareText = nil;
            
            shareText = [NSString stringWithFormat:@"%@ %@ %@", _title, shareUrl.length > 0 ? shareUrl : @"", @"精彩就在@微鲸VR"];
            if (self.shareType == WVRShareTypeAboutUs) {
                shareText = @"微鲸VR专注于虚拟现实，是集硬件、软件、平台于一体的全生态企业，处于国内领先地位，在多领域已展开商业化应用。#微鲸VR#@微鲸VR";
            }
            
            messageObject.text = shareText;
            
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            [shareObject setShareImage:_shareImgURL.length>0 ? _shareImgURL : shareImage];
            messageObject.shareObject = shareObject;
        }
            break;
            
        case kSharePlatformQQ: {        // QQ好友
            
            [WVRTrackEventMapping recommendCellExtendShareQQ:_sid];
        }
            break;
        case kSharePlatformWechat: {    // 微信好友
            
            [WVRTrackEventMapping recommendCellExtendShareWechat:_sid];
        }
            break;
        case kSharePlatformQzone: {  // QQ空间
            
            [WVRTrackEventMapping recommendCellExtendShareQQ:_sid];
        }
            break;
        case kSharePlatformFriends: {  // 微信朋友圈
            
            [WVRTrackEventMapping recommendCellExtendShareMoments:_sid];
            if (_shareType == WVRShareTypeWhaley) {
                _title = @"微鲸VR丨VR版《蒙面唱将猜猜猜》正在热播，更多独家全景视频每天更新！";
            }
        }
            break;
        case kSharePlatformLink: {                       // 复制链接
            
            [WVRTrackEventMapping recommendCellExtendShareChain:_sid];
            UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
            
            pastboad.string = shareUrl.length > 0 ? shareUrl: kShareUrl;
            
            if (!_isH5CallShare) {
                
                SQToastInKeyWindow(@"复制成功");
            }
            
            [self removeFromSuperview];
            if (self.completionBlock) {
                self.completionBlock(kSharePlatformLink, YES);
            }
            
            return;
        }
            
        default:
            break;
    }
    
    if (sharePlatform != kSharePlatformSina) {      // 除了新浪，其他平台的分享格式是一样的
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_title descr:_content thumImage:_shareImgURL.length>0 ? _shareImgURL : shareImage];
        [shareObject setWebpageUrl:shareUrl];
        
        messageObject.shareObject = shareObject;
    }
    
    NSInteger platformType = [[[self shareTypes] objectAtIndex:sharePlatform] integerValue];
    
    __weak typeof(self) weakSelf = self;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.window.rootViewController completion:^(id data, NSError *error) {
        
        NSString *message = nil;
        if (!error) {
            message = @"分享成功";
        } else {
            DDLogError(@"%@", [NSString stringWithFormat:@"分享失败原因Code: %d\n", (int)error.code]);
            message = @"分享失败";
        }
        
        int idx = [self platformExchageToWeb:(int)sharePlatform];
        NSNumber *status = @1;
        if (error) status = @0;
        if (error.code == 2009) status = @2;
        
        NSDictionary *dict = @{ @"platform" : @(idx),
                                @"status" : status };
        if (weakSelf.shareType == WVRShareTypeH5 || weakSelf.shareType == WVRShareTypeNews) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebShareDoneNotification object:weakSelf userInfo:dict];
        }
        
        if (!_isH5CallShare) {
            
            SQToastInKeyWindow(message);
        }
        if (weakSelf.completionBlock) {
            weakSelf.completionBlock(sharePlatform, error == nil);
        }
    }];
    
    [self removeFromSuperview];
}

- (NSString *)shareUrlForShareType:(WVRShareType)shareType {
    
    NSString *shareUrl = nil;
    
    switch (shareType) {
            
        case WVRShareTypeH5:
        case WVRShareTypeNews:
        case WVRShareTypeAboutUs:
            shareUrl = _shareURL;
            
            break;
        case WVRShareTypeVideoDetails:
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst shareVideoDetailsUrl]];
            
            break;
        case WVRShareType3DMovie:
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst share3DMovieDetailsUrl]];
            
            break;
        case WVRShareTypeLive:
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst shareLiveUrl]];
            
            break;
        case WVRShareTypeSpecialTopic:
            
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst shareSpecialTopicUrl]];
            
            break;
        case WVRShareTypeSpecialProgramPackage:
            
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst shareSpecialProgramPackageUrl]];
            
            break;
        case WVRShareTypeSpecialTopicDetails:
            
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst shareSpecialTopicDetailsUrl]];
            
            break;
        case WVRShareTypeMoreTV:
            
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst shareSpecialMoreTVUrl]];
            
            break;
        case WVRShareTypeMoreMovie:
            
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst share3DMovieDetailsUrl]];
            
            break;
        case WVRShareTypeWhaley:
            shareUrl = [NSString stringWithFormat:@"%@", kShareWhaleyUrl];
            
            break;
            
        case WVRShareTypeDrama:
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst shareInteractionDramaUrl]];
            break;
        
        case WVRShareType2018SpringTopic:
            
            shareUrl = [self appPageShareUrlWithBase:[WVRShareConst share2018SpringTopicUrl]];
            
            break;
        default:
            shareUrl = [NSString stringWithFormat:@"%@", kShareWhaleyUrl];
            break;
    }
    
    return shareUrl;
}

- (NSString *)appPageShareUrlWithBase:(NSString *)baseUrl {
    
    NSString *url = [baseUrl stringByAppendingString:_sid.length ? _sid : @""];
    if (_mobLinkId.length > 0) {
        NSString *str = [@"&mobId=" stringByAppendingString:_mobLinkId];
        url = [url stringByAppendingString:str];
    }
    
    return url;
}

- (int)platformExchageToWeb:(int)iosPlatform {
    
    if (iosPlatform == kSharePlatformQQ) {
        return 1;
    } else if (iosPlatform == kSharePlatformSina) {
        
        return 2;
    } else if (iosPlatform == kSharePlatformWechat) {
        
        return 3;
    } else if (iosPlatform == kSharePlatformFriends) {
        
        return 4;
    } else if (iosPlatform == kSharePlatformQzone) {
        
        return 5;
    } else if (iosPlatform == kSharePlatformLink) {
        
        return 6;
    }
    
    return 1;
    NSLog(@"未约定的分享平台");
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareItemId forIndexPath:indexPath];
    
    UIButton *shareIconBtn = nil;
    for (UIButton *btn in cell.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            shareIconBtn = btn;
        }
    }
    UIImage *icon = [UIImage imageNamed:[[self shareIconArray] objectAtIndex:indexPath.row]];
    UIImage *pressIcon = [UIImage imageNamed:[[self pressShareIconArray] objectAtIndex:indexPath.row]];
    
    if (nil == shareIconBtn) {
        
        shareIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareIconBtn.tag = 121;
        shareIconBtn.frame = CGRectMake((cell.width-106*88/100)/2.f, (cell.height-88)/2.f, 106*88/100.f, 88);
        
        [shareIconBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:shareIconBtn];
        shareIconBtn.translatesAutoresizingMaskIntoConstraints = NO;
    }
    [shareIconBtn setImage:icon forState:UIControlStateNormal];
    [shareIconBtn setImage:pressIcon forState:UIControlStateHighlighted];
    shareIconBtn.tag = indexPath.row;
    
    [self addShareBtnViewCont:shareIconBtn inSec:cell];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[self shareIconArray] count];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return (CGSize){ SCREEN_WIDTH/3, 88};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

#pragma mark - custom func

- (UILabel*)myLabel:(CGRect)rect txtColor:(UIColor*)color font:(UIFont*)fnt txtAlign:(NSTextAlignment)align {
    
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.textColor = color;
    label.font = fnt;
    label.textAlignment = align;
    
    return label;
}

#pragma mark - 手势

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    if (!CGRectContainsPoint(_mainView.frame, point)) {
   
        [self cancelAction:nil];
    }
}

#pragma mark - cancel

- (void)cancelAction:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    [weakSelf setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:0.5f // 动画时长
                          delay:0    // 动画延迟
                        options:UIViewAnimationOptionTransitionCurlDown|UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         
                         _mainView.y = SCREEN_HEIGHT;
                         weakSelf.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         [weakSelf removeFromSuperview];
                     }];
    
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

#pragma mark - 图片压缩分享

- (UIImage *)imageCompressWithSimple:(UIImage *)image scale:(float)scale {
    
    UIImage *newImage = image;
    
    // 压缩图片
    CGFloat scaledWidth = newImage.size.width * scale;
    CGFloat scaledHeight = newImage.size.height * scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight)); // thiswillcrop
    [newImage drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSData * resultImage = UIImageJPEGRepresentation(finalImage,0.5);
    if (resultImage.length >= 32000) {
        resultImage = UIImageJPEGRepresentation(finalImage,0.25);
    }
    return [UIImage imageWithData:resultImage];
}

#pragma mark - layout 

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.mCollectionV.collectionViewLayout invalidateLayout];
}

- (void)addCollectionViewCont:(UIView *)firstsView inSec:(UIView *)secondView {
    
    //view_3(蓝色)left 距离 self.view left
    NSLayoutConstraint *view_3LeftToSuperViewLeft = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:secondView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                multiplier:1
                                                                                  constant:0];
    
    //view_3(蓝色)right 距离 self.view right
    NSLayoutConstraint *view_3RightToSuperViewRight = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                   attribute:NSLayoutAttributeRight
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:secondView
                                                                                   attribute:NSLayoutAttributeRight
                                                                                  multiplier:1
                                                                                    constant:0];
    
        NSLayoutConstraint * heightCons = [NSLayoutConstraint constraintWithItem:firstsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:180];
        [firstsView addConstraints:@[heightCons]];
        [firstsView layoutIfNeeded];
    //    //view_3(蓝色)Bottom 距离 self.view bottom
    NSLayoutConstraint *view_3BottomToSuperViewBottom = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:secondView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1
                                                                                      constant:-66];
    //添加约束，因为view_1、2、3是同层次关系，且他们公有的父视图都是self.view，所以这里把约束都添加到self.view上即可
    [secondView addConstraints:@[view_3LeftToSuperViewLeft,view_3RightToSuperViewRight,view_3BottomToSuperViewBottom]];
    
    [secondView layoutIfNeeded];
    [(UICollectionView*)firstsView reloadData];
}

- (void)addCanlBtnViewCont:(UIView *)firstsView inSec:(UIView *)secondView {
    
    //view_3(蓝色)left 距离 self.view left
    NSLayoutConstraint *view_3LeftToSuperViewLeft = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:secondView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                multiplier:1
                                                                                  constant:0];
    
    //view_3(蓝色)right 距离 self.view right
    NSLayoutConstraint *view_3RightToSuperViewRight = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                   attribute:NSLayoutAttributeRight
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:secondView
                                                                                   attribute:NSLayoutAttributeRight
                                                                                  multiplier:1
                                                                                    constant:0];
    
    NSLayoutConstraint * heightCons = [NSLayoutConstraint constraintWithItem:firstsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:66];
    [firstsView addConstraints:@[heightCons]];
    [firstsView layoutIfNeeded];
    //    //view_3(蓝色)Bottom 距离 self.view bottom
        NSLayoutConstraint *view_3BottomToSuperViewBottom = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                         attribute:NSLayoutAttributeBottom
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:secondView
                                                                                         attribute:NSLayoutAttributeBottom
                                                                                        multiplier:1
                                                                                          constant:0];
    //添加约束，因为view_1、2、3是同层次关系，且他们公有的父视图都是self.view，所以这里把约束都添加到self.view上即可
    [secondView addConstraints:@[view_3LeftToSuperViewLeft,view_3RightToSuperViewRight,view_3BottomToSuperViewBottom]];
    
    [secondView layoutIfNeeded];
}

- (void)addMainViewCont:(UIView *)firstsView inSec:(UIView *)secondView {
    
    //view_3(蓝色)left 距离 self.view left
    NSLayoutConstraint *view_3LeftToSuperViewLeft = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:secondView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                multiplier:1
                                                                                  constant:0];
    
    //view_3(蓝色)right 距离 self.view right
    NSLayoutConstraint *view_3RightToSuperViewRight = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                   attribute:NSLayoutAttributeRight
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:secondView
                                                                                   attribute:NSLayoutAttributeRight
                                                                                  multiplier:1
                                                                                    constant:0];
    
    NSLayoutConstraint * heightCons = [NSLayoutConstraint constraintWithItem:firstsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:225];
    [firstsView addConstraints:@[heightCons]];
    [firstsView layoutIfNeeded];
    //    //view_3(蓝色)Bottom 距离 self.view bottom
    NSLayoutConstraint *view_3BottomToSuperViewBottom = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:secondView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1
                                                                                      constant:0];
    //添加约束，因为view_1、2、3是同层次关系，且他们公有的父视图都是self.view，所以这里把约束都添加到self.view上即可
    [secondView addConstraints:@[view_3LeftToSuperViewLeft,view_3RightToSuperViewRight,view_3BottomToSuperViewBottom]];
    
    [secondView layoutIfNeeded];
}

- (void)addShareBtnViewCont:(UIView *)firstsView inSec:(UIView *)secondView {
    
//    view_3(蓝色)left 距离 self.view left
    NSLayoutConstraint *view_3LeftToSuperViewLeft = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:secondView
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                multiplier:1
                                                                                  constant:0];
    
    //view_3(蓝色)right 距离 self.view right
    NSLayoutConstraint *view_3RightToSuperViewRight = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                   attribute:NSLayoutAttributeCenterY
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:secondView
                                                                                   attribute:NSLayoutAttributeCenterY
                                                                                  multiplier:1
                                                                                    constant:0];
    
    NSLayoutConstraint * heightCons = [NSLayoutConstraint constraintWithItem:firstsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:88];
    NSLayoutConstraint * wCons = [NSLayoutConstraint constraintWithItem:firstsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:88];
    [firstsView addConstraints:@[ heightCons, wCons ]];
    [firstsView layoutIfNeeded];
    //    //view_3(蓝色)Bottom 距离 self.view bottom
    
    //添加约束，因为view_1、2、3是同层次关系，且他们公有的父视图都是self.view，所以这里把约束都添加到self.view上即可
    [secondView addConstraints:@[ view_3LeftToSuperViewLeft, view_3RightToSuperViewRight ]];
    
    [secondView layoutIfNeeded];
}

@end
