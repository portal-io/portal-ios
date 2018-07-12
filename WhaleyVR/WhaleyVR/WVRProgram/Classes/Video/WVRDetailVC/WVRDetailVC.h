//
//  WVRDetailVC.h
//  WhaleyVR
//
//  Created by Snailvr on 16/9/9.
//  Copyright © 2016年 Snailvr. All rights reserved.
//
// 详情页基类，请勿直接使用

#import <UIKit/UIKit.h>
#import "WVRBaseViewController.h"
#import "WVRUIEngine.h"
#import "WVRItemModel.h"

#import "WVRDetailFooterView.h"
#import "WVRPlayerTool.h"

#import "WVRSQLiteManager.h"

#import "WVRUMShareView.h"
#import "WVRPlayerHelper.h"

#import "WVRDetailBottomVTool.h"

#import "WVRNavigationBar.h"

#import "WVRPlayerDetailUIManager.h"
@class WVRVideoEntity, WVRProgramBIModel;

@interface WVRDetailVC : WVRBaseViewController <WVRPlayerHelperDelegate>

@property (nonatomic, assign) BOOL shouldScreenFull;

@property (nonatomic, strong) WVRDetailNavigationBar *bar;
@property (nonatomic, copy) NSString *sid;                          // linkArrangeValue、code

- (void)buildData;
- (void)drawUI;
- (void)navBackSetting;
- (void)navShareSetting;
- (void)recordHistory;
- (void)detailNetworkFaild;
- (void)requestData;

#pragma mark - download

@property (nonatomic, strong) WVRItemModel *detailBaseModel;

@property (nonatomic, weak  ) UIButton  *downloadBtn;

@property (nonatomic, strong) NSArray<NSDictionary *>   *parserdURLList;

@property (nonatomic, assign) BOOL isCharged;                // 已付费

@property (nonatomic, strong) WVRPlayerHelper *vPlayer;

@property (nonatomic, strong, readonly) WVRPlayerDetailUIManager *playerUI;

#pragma mark - player

@property (strong, nonatomic) WVRVideoEntity *videoEntity;

@property (nonatomic, weak) UIView *playerContentView;
@property (nonatomic, assign) NSInteger errorCode;

//@property (nonatomic, assign) BOOL isGoCache;

@property (nonatomic, strong) NSDictionary *unityBackParam;

@property (nonatomic, assign) long curPosition;
@property (nonatomic, copy) NSString *curDefinition;

- (void)startToPlay;        // 暴露给子类的方法，调用之前要先给videoEntity赋值
- (void)actionResume;
- (void)actionPause;
- (void)actionGotoBuy;

- (void)purchaseBtnHideWithAnimation;

// 子类实现上传次数方法
- (void)uploadViewCount;
- (void)uploadPlayCount;


- (void)leftBarButtonClick;
- (void)rightBarShareItemClick;

// 电视剧 播放失败后尝试另外一个URL
- (BOOL)reParserPlayUrl;

- (void)playNextVideo;      // 电视剧，自动播放下一个

//- (NSInteger)playerStatus;
//- (long)totalPosition;
//- (void)showLoadingView;
//- (void)hidenLoadingView;

- (void)watch_online_record:(BOOL)isComin;

- (void)trackEventForBrowseDetailPage;

- (void)trackEventForShare;

- (void)dealWithPlayUrl;

- (void)dealWithDetailData;

- (void)syncScrubber;

- (WVRProgramBIModel *)biModel;

/// for unity
- (NSDictionary *)videoInfo;

- (void)checkPlayerStatusWhenBackFromOtherPage;

@end
