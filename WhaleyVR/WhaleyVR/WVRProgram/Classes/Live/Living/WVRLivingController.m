//
//  WVRLivingController.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLivingController.h"
#import "WVRLiveCell.h"
#import "WVRGotoNextTool.h"
#import "SQRefreshHeader.h"
#import "WVRLiveListViewModel.h"
#import "WVRLiveItemModel.h"

@interface WVRLivingController ()

@property (nonatomic, strong) NSMutableDictionary * originDic;
//@property (nonatomic) WVRLivingModel * mLivingModel;

@property (nonatomic, strong) WVRLiveListViewModel * gLiveListViewModel;

@end


@implementation WVRLivingController

+ (instancetype)createViewController:(id)createArgs
{
    WVRLivingController * vc = [[WVRLivingController alloc] init];
    vc.createArgs = createArgs;
    
    return vc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self installRAC];
    [self requestInfo];
}

-(WVRLiveListViewModel *)gLiveListViewModel
{
    if (!_gLiveListViewModel) {
        _gLiveListViewModel = [[WVRLiveListViewModel alloc] init];
    }
    return _gLiveListViewModel;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gLiveListViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpLivingSuccessBlock:x];
    }];
    [[self.gLiveListViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self httpLivingFailBlock];
    }];
}


- (void)requestInfo
{
    [super requestInfo];
//    kWeakSelf(self);
    if (![self haveDataShow]) {
        [self showLoadingWithText:@""];
    }
    [[self.gLiveListViewModel getLiveListCmd] execute:nil];
//    if (!self.mLivingModel) {
//        self.mLivingModel = [WVRLivingModel new];
//    }
//    [self.mLivingModel http_recommendPageDetail:^(NSArray *array) {
//        [weakself httpLivingSuccessBlock:array];
//    } failBlock:^(NSString *errStr) {
//        [weakself httpLivingFailBlock];
//    }];
}

- (void)httpLivingSuccessBlock:(NSArray *)array
{
    [self hidenLoading];
    if (array.count == 0) {
        @weakify(self);
        [self.getEmptyView showNullViewWithTitle:@"暂时没有正在直播" icon:@"icon_live_direct_null" withreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
    }else{
        [self.getEmptyView setHidden:YES];
    }
    self.originDic[@(0)] = [self getSectionInfo:array];
//    [self updateCollectionView];
    [self.gCollectionView.mj_header endRefreshing];
}

- (void)httpLivingFailBlock
{
    [self hidenLoading];
    kWeakSelf(self);
    if (![self haveDataShow]) {
        [self.getEmptyView showNetErrorVWithreloadBlock:^{
            [weakself requestInfo];
        }];
    }else{
        SQToast(kNoNetAlert);
    }
    [self.gCollectionView.mj_header endRefreshing];
}

- (BOOL)haveDataShow
{
    SQCollectionViewSectionInfo * sectionInfo = self.originDic[@(0)];
    NSArray* cellInfos = sectionInfo.cellDataArray;
    if (cellInfos.count>0) {
        return YES;
    }else{
        return NO;
    }
}

- (SQCollectionViewSectionInfo*)getSectionInfo:(NSArray*)itemModels
{
    kWeakSelf(self);
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRLiveItemModel* itemModel in itemModels) {
        WVRLiveCellInfo * cellInfo = [WVRLiveCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRLiveCell class]);
        cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(261.0f));
        cellInfo.itemModel = itemModel;
        cellInfo.gotoNextBlock = ^(WVRLiveCellInfo * args){
            [weakself gotoDetailVC:itemModel];
        };
        [cellInfos addObject:cellInfo];
    }
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}

- (void)gotoDetailVC:(WVRLiveItemModel *)itemModel {
    
    WVRLiveMediaModel * mediaModel = [itemModel.liveMediaDtos firstObject];
    itemModel.playUrl = mediaModel.playUrl;
    [WVRGotoNextTool gotoNextVC:itemModel nav:self.navigationController];
}

@end
