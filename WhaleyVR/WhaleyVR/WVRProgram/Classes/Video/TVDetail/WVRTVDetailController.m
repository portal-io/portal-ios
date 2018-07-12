//
//  WVRTVDetailController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVDetailController.h"
#import "WVRTVVideoDetailViewModel.h"

@interface WVRTVDetailController () {
    NSInteger _currentEpisode;
}

@property (nonatomic) WVRTVItemModel * mParentModel;

@property (nonatomic, strong) WVRTVVideoDetailViewModel * gTVVideoDetailViewModel;

@end


@implementation WVRTVDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self navBackSetting];
}

- (WVRTVVideoDetailViewModel *)gTVVideoDetailViewModel
{
    if (!_gTVVideoDetailViewModel) {
        _gTVVideoDetailViewModel = [[WVRTVVideoDetailViewModel alloc] init];
    }
    return _gTVVideoDetailViewModel;
}

- (void)setUpRequestRAC {
    
    @weakify(self);
    [[self.gTVVideoDetailViewModel gSuccessSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpDetailSuccessBlock:x];
    }];
    [[self.gTVVideoDetailViewModel gFailSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self networkFaild:x];
    }];
    
    [[self.gTVVideoDetailViewModel gTVItemSuccessSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpItemSuccessBlock:x];
    }];
    [[self.gTVVideoDetailViewModel gTVSeriesSuccessSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSeriesInfoSuccessBlock:x];
    }];
    [[self.gTVVideoDetailViewModel gTVSelectSuccessSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self selectItemHttpUIBlock:x];
    }];

}

- (WVRTVItemModel *)shouldCollectionModel {
    self.mParentModel.programType = PROGRAMTYPE_MORETV_TV;
    self.mParentModel.linkArrangeType = LINKARRANGETYPE_MORETVPROGRAM;
    self.mParentModel.parentCode = self.mParentModel.code;
    return self.mParentModel;
}

- (void)requestData {
    

    SQShowProgress;
    self.gTVVideoDetailViewModel.code = [self.createArgs linkArrangeValue];
    [[self.gTVVideoDetailViewModel gDetailCmd] execute:nil];

}

- (void)httpDetailSuccessBlock:(WVRTVItemModel *)tvitemModel {
    if (!tvitemModel) {
        [self networkFaild:nil];
        return;
    }
    self.httpItemModel = tvitemModel;
    if (!tvitemModel.tvSeries) {//是详情,再去请求一遍系列
        [self requestSeriesInfo:tvitemModel.parentCode];
        self.sid = tvitemModel.code;
    }else{//是系列再去请求一遍详情
        [self initParentModel:tvitemModel];
        [self httpItemRequest];
    }
}

#pragma mark - 某个详情

- (void)httpItemRequest {
    
    WVRTVItemModel * firtsModel = [self.httpItemModel.tvSeries firstObject];
    self.httpItemModel.parentCode = self.httpItemModel.code;
    self.httpItemModel.code = firtsModel.code;
    self.sid = self.httpItemModel.code;
    SQShowProgress;
    self.gTVVideoDetailViewModel.code = self.httpItemModel.code;
    [self.gTVVideoDetailViewModel.gTVItemDetailCmd execute:nil];

}

- (void)httpItemSuccessBlock:(WVRTVItemModel*)model {
    if (!model) {
        [self networkFaild:@""];
        return;
    }
    SQHideProgress;
    self.httpItemModel.code = model.code;
    // 是系列的时候，没有parentCode，把code赋值给parentCode以便收藏系列使用
    self.httpItemModel.name = model.name;
    self.httpItemModel.playCount = model.playCount;
    if (model.thubImageUrl) {
        self.httpItemModel.thubImageUrl = model.thubImageUrl;
    }
    if (model.intrDesc) {
        self.httpItemModel.intrDesc = model.intrDesc;
    }
    self.httpItemModel.curEpisode = model.curEpisode;
    self.httpItemModel.playUrlModels = model.playUrlModels;
    self.httpItemModel.programType = [self.createArgs programType];
    self.httpItemModel.linkArrangeType = [self.createArgs linkArrangeType];
    self.mParentModel.programType = PROGRAMTYPE_MORETV_TV;
    [self loadSubView:self.httpItemModel];

}

#pragma mark - 系列

- (void)requestSeriesInfo:(NSString*)parentCode {
    
    SQShowProgress;
    self.gTVVideoDetailViewModel.code = parentCode;
    [self.gTVVideoDetailViewModel.gTVseriesDetailCmd execute:nil];

}

- (void)httpSeriesInfoSuccessBlock:(WVRTVItemModel*)tvitemModel {
    if (!tvitemModel) {
        [self networkFaild:@""];
        return;
    }
    [self initParentModel:tvitemModel];
    SQHideProgress;
    if (!self.httpItemModel.intrDesc) {
        self.httpItemModel.intrDesc = tvitemModel.intrDesc;
    }
    self.httpItemModel.tvSeries = tvitemModel.tvSeries;
    if (!self.httpItemModel.thubImageUrl) {
        self.httpItemModel.thubImageUrl = tvitemModel.thubImageUrl;
    }
    self.httpItemModel.programType = [self.createArgs programType];
    self.httpItemModel.linkArrangeType = [self.createArgs linkArrangeType];
    [self loadSubView:self.httpItemModel];

}

- (void)initParentModel:(WVRTVItemModel*)model {
    
    if (!self.mParentModel) {
        self.mParentModel = [WVRTVItemModel new];
    }
    self.mParentModel.code = model.code;
    self.mParentModel.name = model.name;
    self.mParentModel.playCount = model.playCount;
    self.mParentModel.intrDesc = model.intrDesc;
    self.mParentModel.thubImageUrl = model.thubImageUrl;
    self.mParentModel.actors = model.actors;;
    self.mParentModel.area = model.area;
    self.mParentModel.year = model.year;
    self.mParentModel.director = model.director;
    self.mParentModel.duration = model.duration;
    self.mParentModel.programType = PROGRAMTYPE_MORETV_TV;
}


// 剧集选择
- (void)didSelectItemModel:(WVRTVItemModel *)itemModel {
    
    [WVRTrackEventMapping trackEvent:@"subjectDetail" flag:@"play"];
    
    [self httpSelectItemRequest];
}

#pragma mark - 某个详情

- (void)httpSelectItemRequest {
    
    SQShowProgress;
    [self watch_online_record:NO];
    self.gTVVideoDetailViewModel.code = self.httpItemModel.code;
    [self.gTVVideoDetailViewModel.gTVSelectItemDetailCmd execute:nil];
}

- (void)selectItemHttpUIBlock:(WVRTVItemModel*)model {
    
    SQHideProgress;
    self.httpItemModel.playCount = model.playCount;
    self.httpItemModel.thubImageUrl = model.thubImageUrl;
    self.httpItemModel.playUrl = model.playUrl;
    self.httpItemModel.name = model.name;
    self.httpItemModel.curEpisode = model.curEpisode;
    self.httpItemModel.playUrlModels = model.playUrlModels;
    if (model.thubImageUrl) {
        self.httpItemModel.thubImageUrl = model.thubImageUrl;
    }
    if (model.intrDesc) {
        self.httpItemModel.intrDesc = model.intrDesc;
    }
    [self.mtvDetailV reloadData];
    [self recordHistory];
    [self valuationForVideoEntityWithModel:self.httpItemModel];
    
    [self uploadPlayCount];
    [self startToPlay];
}

- (void)playNextVideo {
    
    [self.videoEntity nextVideoEntity];
    [self.mtvDetailV selectNextItem];
    [self httpSelectItemRequest];

}

@end
