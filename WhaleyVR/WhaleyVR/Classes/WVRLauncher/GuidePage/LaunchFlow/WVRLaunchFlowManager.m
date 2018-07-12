//
//  WVRLaunchFlowManager.m
//  WhaleyVR
//
//  Created by Bruce on 2018/1/19.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 启动流程管理
// (应用启动阶段)启动-广告位-(应用内展示阶段)强制升级提示-活动海报-推荐升级提示-内容推荐浮层

#import "WVRLaunchFlowManager.h"
#import "WVREventPoster.h"
#import "WVRContentRecommendationSupernatant.h"
#import "WVRCheckVersionTool.h"
#import "WVRWhaleyHTTPManager.h"

typedef NS_ENUM(NSInteger, WVRLaunchFlowStep) {
    
    WVRLaunchFlowStepPoster,        // 活动海报
    WVRLaunchFlowStepUpdate,        // 版本更新提示
    WVRLaunchFlowStepRecommend,     // 内容推荐悬浮层
    WVRLaunchFlowStepDestroy,       // 步骤执行完毕，释放对象
};

@interface WVRLaunchFlowManager () {
    id _rac_handler;
}

@property (atomic, assign) BOOL waitForNextStep;

/// 当前要、正在展示的步骤
@property (nonatomic, assign) WVRLaunchFlowStep shouldShowStep;

@end


@implementation WVRLaunchFlowManager

static WVRLaunchFlowManager *k_LaunchFlow_manager = nil;
#define kLaunchFlowWaitForNextStep @"kLaunchFlowWaitForNextStep"

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        k_LaunchFlow_manager = [[WVRLaunchFlowManager alloc] initWithConfig:nil];
    });
    return k_LaunchFlow_manager;
}

- (instancetype)initWithConfig:(NSDictionary *)config {
    self = [super init];
    if (self) {
        [self addNotificationObserve];
    }
    return self;
}

- (void)addNotificationObserve {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedWaitForNextStepNoti:) name:kLaunchFlowWaitForNextStep object:nil];
}

- (UIImageView *)tmpImageView {
    if (!_tmpImageView) {
        _tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MIN(SCREEN_WIDTH, SCREEN_HEIGHT), MAX(SCREEN_WIDTH, SCREEN_HEIGHT))];
    }
    return _tmpImageView;
}

- (void)receivedWaitForNextStepNoti:(NSNotification *)noti {
    
    self.waitForNextStep = YES;
}

// 初始化所需数据（网络请求）
- (void)buildData {
    
    [self requestForLaunchADInfo];
    
    [WVRCheckVersionTool checkHaveNewVersion];
}

- (void)requestForLaunchADInfo {
    
    NSString *ver = [[kAppVersion componentsSeparatedByString:@"_"] firstObject];
    
    NSString *url = [NSString stringWithFormat:@"newVR-service/appservice/recommendPage/findPageByCode/WelcomePage/ios/%@?v=1", ver];
    
    kWeakSelf(self);
    [WVRWhaleyHTTPManager GETService:url withParams:nil completionBlock:^(NSDictionary *responseObj, NSError *error) {
        
        NSDictionary *data = responseObj[@"data"];
        NSArray *recommendAreas = data[@"recommendAreas"];
        
        NSMutableArray *resultArr = [NSMutableArray array];
        
        for (NSDictionary *recommend in recommendAreas) {
            
            NSArray *recommendElements = recommend[@"recommendElements"];
            NSDictionary *element = [recommendElements firstObject];
            
            WVRRecommendItemModel *result = [WVRRecommendItemModel yy_modelWithDictionary:element];
            result.recommendAreaType = [recommend[@"type"] integerValue];
            if (result) {
                [resultArr addObject:result];
            }
        }
        [weakself dealWithDataArray:resultArr];
    }];
}

- (void)dealWithDataArray:(NSArray *)resultArr {
    
    self.recommendModels = resultArr;
    
    WVRRecommendItemModel *dataModel = [self findModelByType:WVRRecommndAreaTypeLaunchAD];
    
    if (dataModel.picUrl_.length) {
        
        [self.tmpImageView wvr_setImageWithURL:[NSURL URLWithString:dataModel.picUrl_]];
    }
}

/// 展示第二阶段（应用内展示阶段）
- (void)shouldShowSecondStage {
    
    if (self.recommendModels) {
        
        [self dealWithSecondStage];
    } else {
        
        @weakify(self);
        __block RACDisposable *handler = [[[RACObserve(self, recommendModels) skip:1] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self);
            [self dealWithSecondStage];
            [handler dispose];
        }];
        _rac_handler = handler;
    }
}

- (void)shouldShowNextStep {
    
    switch (self.shouldShowStep) {
        case WVRLaunchFlowStepPoster: {
            [self dealWithSecondStage];
        }
            break;
            
        case WVRLaunchFlowStepUpdate: {
            [self dealWithUpdateVersion];
        }
            break;
            
        case WVRLaunchFlowStepRecommend: {
            [self dealWithContentRecommend];
        }
            break;
        default:
            [self destroyInstance];
            break;
    }
}

- (BOOL)checkValidStatus {
    
    // 如果当前用户已经进入横屏状态，就不展示提示，否则界面会错乱
    
    float max_width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    if (SCREEN_WIDTH == max_width) {
        [self destroyInstance];
        return NO;
    }
    return YES;
}

- (void)dealWithSecondStage {
    
    if (![self checkValidStatus]) {
        return;
    }
    
    // 先展示活动海报，没有就进行下一步
    WVRRecommendItemModel *model = [self findModelByType:WVRRecommndAreaTypePoster];
    
    if (model.recommendAreaType == WVRRecommndAreaTypePoster && model.code) {
        
        [self dealWithActivityPoster:model];
        
    } else {
        // 没有相关信息或者不在有效期 执行下一步
        [self dealWithUpdateVersion];
    }
}

- (void)dealWithActivityPoster:(WVRRecommendItemModel *)model {
    
    self.shouldShowStep = WVRLaunchFlowStepUpdate;
    
    WVREventPoster *poster = [[WVREventPoster alloc] initWithModel:model];
    
    [poster show];
}

// 版本更新提示
- (void)dealWithUpdateVersion {
    
    if (![self checkValidStatus]) {
        return;
    }
    
    self.shouldShowStep = WVRLaunchFlowStepRecommend;
    
    [WVRCheckVersionTool shouldShowUpdateTip];
}

/// 内容推荐浮层
- (void)dealWithContentRecommend {
    
    if (![self checkValidStatus]) {
        return;
    }
    
    // 展示活动海报，没有就结束
    WVRRecommendItemModel *model = [self findModelByType:WVRRecommndAreaTypeSupernatant];
    
    self.shouldShowStep = WVRLaunchFlowStepDestroy;
    
    if (model.recommendAreaType == WVRRecommndAreaTypeSupernatant && model.code) {
        
        WVRContentRecommendationSupernatant *view = [[WVRContentRecommendationSupernatant alloc] initWithModel:model];
        
        [view show];
        
    } else {
        // 没有相关信息或者不在有效期 执行下一步
        [self destroyInstance];
    }
}

// WVRRecommndAreaType
/// 通过类型查找数据，如果找不到，就返回一个空Model，防止RAC无法监测变化
- (WVRRecommendItemModel *)findModelByType:(WVRRecommndAreaType)type {
    
    for (WVRRecommendItemModel *tmpModel in self.recommendModels) {
        if (tmpModel.recommendAreaType == type) {
            return tmpModel;
        }
    }
    
    return [[WVRRecommendItemModel alloc] init];
}

/// 流程完成，可销对象
- (void)destroyInstance {
    
    self.recommendModels = nil;
    k_LaunchFlow_manager = nil;
    _tmpImageView = nil;
}

@end
