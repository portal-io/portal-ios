//
//  WVRLaunchImageViewModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 开机广告数据请求

#import "WVRLaunchImageViewModel.h"
#import "WVRLaunchImageInfoUseCase.h"
#import "WVRLaunchFlowManager.h"

@interface WVRLaunchImageViewModel ()

@property (nonatomic, strong) WVRLaunchImageInfoUseCase *httpUC;

@end


@implementation WVRLaunchImageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.httpUC = [[WVRLaunchImageInfoUseCase alloc] init];
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    
    [[self.httpUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        self.dataModel = [self findModelByType:WVRRecommndAreaTypeLaunchAD models:x];    // 开机广告
        [WVRLaunchFlowManager shareInstance].recommendModels = x;
    }];
    
    [[self.httpUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
        [[WVRLaunchFlowManager shareInstance] setRecommendModels:[NSArray array]];
    }];
}

- (RACCommand *)httpCmd {
    
    return self.httpUC.getRequestCmd;
}

// WVRRecommndAreaType
/// 通过类型查找数据，如果找不到，就返回一个空Model，防止RAC无法监测变化
- (WVRRecommendItemModel *)findModelByType:(WVRRecommndAreaType)type models:(NSArray *)model {
    
    for (WVRRecommendItemModel *tmpModel in model) {
        if (tmpModel.recommendAreaType == type) {
            return tmpModel;
        }
    }
    
    return [[WVRRecommendItemModel alloc] init];
}

@end
