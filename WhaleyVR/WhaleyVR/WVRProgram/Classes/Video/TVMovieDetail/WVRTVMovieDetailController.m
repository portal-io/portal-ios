//
//  WVRTVMovieDetailController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVMovieDetailController.h"
#import "WVRTVDetailView.h"
//#import "WVRCollectionVCModel.h"
//#import "WVRLoginTool.h"
#import "WVRTVVideoDetailViewModel.h"

@interface WVRTVMovieDetailController ()

@property (nonatomic, strong) WVRTVVideoDetailViewModel * gTVVideoDetailViewModel;

@end


@implementation WVRTVMovieDetailController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navBackSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (WVRTVItemModel *)shouldCollectionModel {
    self.httpItemModel.programType = PROGRAMTYPE_MORETV_MOVIE;
    self.httpItemModel.parentCode = self.httpItemModel.code;
    return self.httpItemModel;
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
        [self moviehttpSuccessBlock:x];
    }];
    [[self.gTVVideoDetailViewModel gFailSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self networkFaild:x];
    }];
}

#pragma mark - request

- (void)requestData
{
    self.sid = [self.createArgs linkArrangeValue];
    SQShowProgress;
    self.gTVVideoDetailViewModel.code = [self.createArgs linkArrangeValue];
    [[self.gTVVideoDetailViewModel gDetailCmd] execute:nil];
}

- (void)moviehttpSuccessBlock:(WVRTVItemModel*)itemModel
{
    if (!itemModel) {
        [self networkFaild:nil];
        return;
    }
    self.httpItemModel = itemModel;
    // 是电影的时候，没有parentCode，把code赋值给parentCode以便收藏电影使用
    self.httpItemModel.parentCode = self.httpItemModel.code;
    self.httpItemModel.programType = [self.createArgs programType];
    self.httpItemModel.linkArrangeType = [self.createArgs linkArrangeType];
//    [self requestCollectionStatus];
    [self loadSubView:self.httpItemModel];
}


@end
