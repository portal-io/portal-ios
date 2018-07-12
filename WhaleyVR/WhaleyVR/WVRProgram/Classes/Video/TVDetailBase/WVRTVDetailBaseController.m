//
//  WVRTVDetailBaseController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVDetailBaseController.h"
#import "WVRVideoEntityMoreTV.h"
#import "WVRCollectionViewModel.h"
#import "WVRUploadViewCountHandle.h"

@interface WVRTVDetailBaseController ()

@property (nonatomic, strong) WVRCollectionViewModel * gCollectionViewModel;

@end


@implementation WVRTVDetailBaseController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self installRAC];
    }
    return self;
}

- (WVRTVItemModel *)shouldCollectionModel {
    
    return self.httpItemModel;
}

- (void)requestData {
    
    self.sid = [self.createArgs linkArrangeValue];
}

- (void)loadSubView:(WVRTVItemModel *)itemModel {
    
    [self trackEventForBrowseDetailPage];
    
    WVRTVDetailViewInfo * vInfo = [WVRTVDetailViewInfo new];
    vInfo.frame = self.view.bounds;
    vInfo.itemModel = itemModel;
    vInfo.parentModel = [self shouldCollectionModel];
    WVRTVDetailView* tvDV = [WVRTVDetailView createWithInfo:vInfo];
    tvDV.delegate = (id)self;
    self.mtvDetailV = tvDV;
    [self.view addSubview:tvDV];
    
    [super drawUI];
    
    [self playAction];      // 开始播放
    
    [self dealWithDetailData];
}

- (WVRCollectionViewModel *)gCollectionViewModel
{
    if (!_gCollectionViewModel) {
        _gCollectionViewModel = [[WVRCollectionViewModel alloc] init];
    }
    return _gCollectionViewModel;
}

- (void)installRAC {
    
}

- (void)networkFaild:(NSString*)errMsg {
    
    self.bar.hidden = NO;
    SQHideProgress;
    [self detailNetworkFaild];
}

- (void)didSelectItemModel:(WVRTVItemModel *)itemModel {
    
}

#pragma mark - play

- (void)playAction {
    
//    [WVRTrackEventMapping trackEvent:@"subjectDetail" flag:@"play"];
    
    [self valuationForVideoEntityWithModel:self.httpItemModel];
    
    [self uploadPlayCount];
    
    [self startToPlay];
}

- (void)uploadViewCount {       // 上传浏览次数
    
    [self uploadCountWithType:@"view"];
}

- (void)uploadPlayCount {
    
    [self uploadCountWithType:@"play"];
}

- (void)uploadCountWithType:(NSString *)type {       // 上传统计次数
    
    [WVRUploadViewCountHandle uploadViewInfoWithCode:self.videoEntity.sid programType:@"moretv_tv" videoType:@"moretv_2d" type:type sec:nil title:nil];
}

- (BOOL)reParserPlayUrl {
    
    BOOL canRetry = self.videoEntity.canTryNextPlayUrl;
    if (canRetry) {
        [self.videoEntity nextPlayUrlVE];
    }
    
    return canRetry;
}

- (void)valuationForVideoEntityWithModel:(WVRTVItemModel *)model {
    
    WVRVideoEntityMoreTV *ve = (WVRVideoEntityMoreTV *)self.videoEntity;
        
    if (nil == ve || ![ve isKindOfClass:[WVRVideoEntityMoreTV class]]) {
        ve = [[WVRVideoEntityMoreTV alloc] init];
    }
    ve.videoTitle = model.title;
    ve.sid = model.sid;
    ve.isChargeable = model.isChargeable;
    ve.price = model.price;
    ve.biEntity.totalTime = model.duration.intValue;
    ve.code = model.code;
    ve.detailModel = model.detailModel;
    
    ve.needParserURL = [model.playUrlArray firstObject];
    ve.playUrls = model.playUrlArray;
    ve.detailItemModels = model.tvSeries;
    ve.biEntity.contentType = model.type;
    
    self.videoEntity = ve;
}

- (NSString *)videoFormat {
    
    return @"2d";
}

- (NSString *)biPageName {
    
    return self.httpItemModel.title;
}

- (NSString *)biPageId {
    
    return self.httpItemModel.sid;
}

- (NSString *)biContentType {
    
    return self.httpItemModel.type;
}

@end
