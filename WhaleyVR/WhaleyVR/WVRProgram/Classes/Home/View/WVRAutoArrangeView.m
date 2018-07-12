//
//  WVRRecommendPageView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAutoArrangeView.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
//#import ".h"
#import "WVRSQClassifyCell.h"
#import "WVRSQFindUIStyleHeader.h"
#import "WVRGotoNextTool.h"
#import "WVR3DArrangeCell.h"
#import "WVRAutoArrangeViewModel.h"

@interface WVRAutoArrangeView ()

@property (nonatomic) WVRAutoArrangeViewModel *gAutoArrangeViewModel;

@property (nonatomic) NSMutableDictionary * mModelDic;
@property (nonatomic) NSMutableDictionary * mOriginDic;
@property (nonatomic) SQCollectionViewDelegate * mDelegate;

@property (nonatomic) WVRSectionModel * mSectionModel;
@property (nonatomic) WVRAutoArrangeViewInfo * mVInfo;


@end


@implementation WVRAutoArrangeView

+ (instancetype)createWithInfo:(WVRAutoArrangeViewInfo *)vInfo {
    
    WVRAutoArrangeView * pageV = [[WVRAutoArrangeView alloc] initWithFrame:vInfo.frame collectionViewLayout:[UICollectionViewFlowLayout new] withVInfo:vInfo];
    
    return pageV;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withVInfo:(WVRAutoArrangeViewInfo *)vInfo {
    
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.mVInfo = vInfo;
        NSLog(@"videoType: %@", self.mVInfo.sectionModel.videoType);
        self.mSectionModel = [WVRSectionModel new];
        self.mSectionModel.linkArrangeValue = vInfo.sectionModel.linkArrangeValue;
//        self.mAutoArrangeModel = [WVRAutoArrangeModel new];
        self.mOriginDic = [NSMutableDictionary dictionary];
        kWeakSelf(self);
        self.backgroundColor = UIColorFromRGB(0xebeff2);
        self.mj_header = [SQRefreshHeader headerWithRefreshingBlock:^{
            
            [weakself headerRefreshRequest];
        }];
        self.mj_footer = [SQRefreshFooter footerWithRefreshingBlock:^{
            
            [weakself footerMoreRequest];
        }];
        
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([WVRSQClassifyCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WVRSQClassifyCell class])];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([WVR3DArrangeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WVR3DArrangeCell class])];
        SQCollectionViewDelegate * delegate = [SQCollectionViewDelegate new];
        self.delegate = delegate;
        self.dataSource = delegate;
        self.mDelegate = delegate;
//        WVRNetErrorView *view = [WVRNetErrorView errorViewForViewReCallBlock:^{
//            [weakself.mErrorView removeFromSuperview];
//            [weakself headerRefreshRequest];
//        } withParentFrame:self.frame];
//        self.mErrorView = view;
        [self installRAC];
    }
    return self;
}

-(WVRAutoArrangeViewModel *)gAutoArrangeViewModel
{
    if (!_gAutoArrangeViewModel) {
        _gAutoArrangeViewModel = [[WVRAutoArrangeViewModel alloc] init];
    }
    return _gAutoArrangeViewModel;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gAutoArrangeViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self headerRefreshSuccessBlock:x];
    }];
    [[self.gAutoArrangeViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self networkFaild];
    }];
}



- (void)requestInfo {
    
    if (self.mSectionModel.itemModels.count == 0) {
        [self headerRefreshRequest];
    }
}

- (void)headerRefreshRequest {
    
    if (self.mSectionModel.itemModels.count == 0) {
        SQShowProgress;
    }
//    if (self.mVInfo.sectionModel.type == WVRSectionModelTypeTV) {
//        [self httpTVRequest];
//    }else{
        [self httpRequest];
//    }
}

- (void)httpRequest {
    
    self.gAutoArrangeViewModel.code = self.mVInfo.sectionModel.linkArrangeValue;
    [[self.gAutoArrangeViewModel getAutoArrangeCmd] execute:nil];
//    kWeakSelf(self);
//    [self.mAutoArrangeModel http_recommendPage:self.mVInfo.sectionModel.linkArrangeValue successBlock:^(NSDictionary *args) {
//        [weakself headerRefreshSuccessBlock:args];
//    } failBlock:^(NSString *args) {
//        SQHideProgress;
//        [weakself networkFaild];
//    }];
}

- (void)httpTVRequest {
    
//    kWeakSelf(self);
//    [self.mAutoArrangeModel http_recommendTVPage:self.mVInfo.sectionModel.linkArrangeValue successBlock:^(NSDictionary *args) {
//        [weakself headerRefreshSuccessBlock:args];
//    } failBlock:^(NSString *args) {
//        SQHideProgress;
//        [weakself networkFaild];
//    }];
}

- (void)headerRefreshSuccessBlock:(WVRSectionModel*)args {
    
    SQHideProgress;
    self.mSectionModel = args;
    if (self.mSectionModel.itemModels.count==0) {
        [self networkFaild];
        return ;
    }
    self.mOriginDic[@(0)] = [self getSectionInfo];
    [self updateCollectionView];
    [self endRefresh];
}


- (void)updateCollectionView {
    
    [self.mDelegate loadData:self.mOriginDic];
    [self reloadData];
}

- (void)footerMoreRequest {
    
    
    if (self.mSectionModel.pageNum == self.mSectionModel.totalPages-1) {
        [self endRefreshNoMore];
        return;
    }
    if (self.mSectionModel.itemModels.count==0) {
        SQShowProgress;
    }
//    if (self.mVInfo.sectionModel.sectionType == WVRSectionModelTypeTV) {
//        [self httpTVMoreRequest];
//    }else{
        [self httpMoreRequest];
//    }
}

- (void)httpMoreRequest {
    
    [[self.gAutoArrangeViewModel getAutoArrangeMoreCmd] execute:nil];
    //
//    kWeakSelf(self);
//    [self.mAutoArrangeModel http_recommendPageMore:self.mVInfo.sectionModel.linkArrangeValue successBlock:^(NSDictionary *args) {
//        [weakself footerMoreSuccessBlock:args];
//    } failBlock:^(NSString *args) {
//        SQHideProgress;
//        [weakself networkFaild];
//    }];
}

//- (void)httpTVMoreRequest
//{
//    kWeakSelf(self);
//    [self.mAutoArrangeModel http_recommendTVPageMore:self.mVInfo.sectionModel.linkArrangeValue successBlock:^(NSDictionary *args) {
//        [weakself footerMoreSuccessBlock:args];
//    } failBlock:^(NSString *args) {
//        SQHideProgress;
//        [weakself networkFaild];
//    }];
//}

- (void)footerMoreSuccessBlock:(WVRSectionModel*)args {
    
    SQHideProgress;
    self.mSectionModel = args;
    self.mOriginDic[@(0)] = [self getSectionInfo];
    [self updateCollectionView];
    if (self.mSectionModel.pageNum == self.mSectionModel.totalPages) {
        [self endRefreshNoMore];
    }else{
        [self endRefresh];
    }
}

- (void)endRefresh {
    
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)endRefreshNoMore {
    
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)networkFaild {
    [self.mj_header endRefreshing];
    if (self.mSectionModel.itemModels.count==0) {
//        [self deta];
    }
}

- (SQCollectionViewSectionInfo*)getSectionInfo {
    
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    
    NSMutableArray * cellInfos = [NSMutableArray array];
//    if (self.mVInfo.sectionModel.videoType_ != WVRModelVideoTypeVR) {
        for (WVRItemModel* model in self.mSectionModel.itemModels) {
            if (model.videoType_ != WVRModelVideoTypeVR) {
                [cellInfos addObject:[self get3DArrangeCellInfo:model]];
            }else{
                [cellInfos addObject:[self getVRArrangeCellInfo:model]];
            }
        }
//    }else{
//        for (WVRItemModel* model in self.mSectionModel.itemModels) {
//            [cellInfos addObject:[self getVRArrangeCellInfo:model]];
//        }
    
//    }
    
    
    sectionInfo.cellDataArray = cellInfos;
    
    return sectionInfo;
}

- (WVR3DArrangeCellInfo*)get3DArrangeCellInfo:(WVRItemModel* )model {
    
    kWeakSelf(self);
    WVR3DArrangeCellInfo * cellInfo = [WVR3DArrangeCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVR3DArrangeCell class]);
    cellInfo.cellSize = CGSizeMake(WIDTH_3DANDTV_CELL, fitToWidth(HEIGHT_3DARRANGE_CELL));
    cellInfo.gotoNextBlock = ^(id args){
        [weakself gotoDetail:model];
    };
    cellInfo.videoModel = [WVRVideoModel new];
    cellInfo.videoModel.name = model.name;
    cellInfo.videoModel.itemId = model.code;
    cellInfo.videoModel.thubImage = model.thubImageUrl;
    cellInfo.videoModel.subTitle = model.subTitle;
    cellInfo.videoModel.intrDesc = model.intrDesc;
    
    return cellInfo;
}

- (WVRSQClassifyCellInfo*)getVRArrangeCellInfo:(WVRItemModel *)model {
    
    kWeakSelf(self);
    WVRSQClassifyCellInfo * clafCellInfo = [WVRSQClassifyCellInfo new];
    clafCellInfo.cellNibName = NSStringFromClass([WVRSQClassifyCell class]);
    
    clafCellInfo.cellSize = CGSizeMake(WIDTH_DEFAULT_CELL, fitToWidth(HEIGHT_DEFAULT_CELL));
    
    clafCellInfo.gotoNextBlock = ^(id args){
        [weakself gotoDetail:model];
    };
    clafCellInfo.args = model;
//    clafCellInfo.videoModel = [WVRVideoModel new];
//    clafCellInfo.videoModel.name = model.name;
//    clafCellInfo.videoModel.itemId = model.code;
//    clafCellInfo.videoModel.thubImage = model.thubImageUrl;
//    clafCellInfo.videoModel.subTitle = model.subTitle;
//    clafCellInfo.videoModel.intrDesc = model.intrDesc;
    return clafCellInfo;
}

- (void)gotoDetail:(WVRItemModel*)itemModel {
    
    [WVRGotoNextTool gotoNextVC:itemModel nav:self.mVInfo.viewController.navigationController];
}

@end


@implementation WVRAutoArrangeViewInfo

@end
