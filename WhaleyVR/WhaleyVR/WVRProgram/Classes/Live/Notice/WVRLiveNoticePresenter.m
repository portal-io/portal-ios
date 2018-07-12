//
//  WVRReserveController.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLiveNoticePresenter.h"
#import "WVRLiveReserveCell.h"
#import "WVRLiveNoticeViewModel.h"
//#import "WVRLoginViewController.h"
#import "WVRNavigationController.h"
//#import "WVRLoginTool.h"
#import "WVRGotoNextTool.h"

#import "SQCollectionView.h"
#import "WVRNullCollectionViewCell.h"
#import "SQRefreshHeader.h"
#import "WVRHomePageCollectionView.h"
#import "WVRSmallPlayerPresenter.h"

#define HEIGHT_COLLECTION ((70.0f))

@interface WVRLiveNoticePresenter ()

@property (nonatomic) WVRLiveNoticeViewModel * gLiveNoticeViewModel;


@property (nonatomic, strong) NSMutableDictionary * originDic;

@end


@implementation WVRLiveNoticePresenter
@page(([NSString stringWithFormat:@"%d%@",(int)1,LINKARRANGETYPE_LIVEORDERLIST]), NSStringFromClass([WVRLiveNoticePresenter class]))


- (instancetype)initWithParams:(id)params attchView:(id<WVRCollectionViewProtocol>)view
{
    self = [super init];
    if (self) {
        self.args = params;
        self.collectionViewDelegte = [SQCollectionViewDelegate new];
        self.gView = view;
        [self installRAC];
        [self addRefreshObserver];
    }
    return self;
}

- (void)addRefreshObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:NAME_NOTF_RESERVE_PRESENTER_REFRESH object:nil];
}

- (WVRLiveNoticeViewModel *)gLiveNoticeViewModel
{
    if (!_gLiveNoticeViewModel) {
        _gLiveNoticeViewModel = [[WVRLiveNoticeViewModel alloc] init];
    }
    return _gLiveNoticeViewModel;
}


- (void)fetchData
{
    [self requestInfo];
}

- (void)requestInfo
{
    if (self.originDic.count==0) {
        [self.gView showLoadingWithText:nil];
    }
    [self httpRequest];
}

- (void)requestInfo:(id)requestParams
{
    self.args = requestParams;
    [self requestInfo];
}

- (void)requestInfoForFirst:(id)requestParams
{
    if (self.originDic.count == 0) {
        [self requestInfo:requestParams];
    }
}

- (void) headerRefreshRequestInfo:(id)requestParams
{
    [self headerRefreshRequest:YES requestParams:requestParams? requestParams:self.args];
}

- (void)footerMoreRequestInfo:(id)requestParams
{
    [self footerMore];
}

- (void)headerRefreshRequest:(BOOL)firstRequest requestParams:(id)requestParams
{
    [self requestInfo];
}

- (void)footerMoreRequest:(BOOL)firstRequest requestParams:(id)requestParams
{
    [self footerMore];
}

- (void)parseInfoToOriginDic:(NSArray *)args
{
    if (!self.originDic) {
        self.originDic = [NSMutableDictionary dictionary];
    }
    [self.originDic removeAllObjects];
    WVRSectionModel * sectionModel = [[WVRSectionModel alloc] init];
    sectionModel.sectionType = WVRSectionModelTypeLiveNotice;
    sectionModel.itemModels = [NSMutableArray arrayWithArray:args];
    WVRBaseViewSection * sectionInfo = [self sectionInfo:sectionModel];
    self.originDic[@(0)] = sectionInfo;
    [self.gView setDelegate:self.collectionViewDelegte andDataSource:self.collectionViewDelegte];
    [self.collectionViewDelegte loadData:self.originDic];
    [self.gView reloadData];
}

- (void)httpRequest {
    self.gLiveNoticeViewModel.code = [self.args linkArrangeValue];
    [[self.gLiveNoticeViewModel getLiveNoticeListCmd] execute:nil];
}

//- (void)headerRefreshSuccessBlock:(WVRSectionModel*)sectionModel {
//    
//    [self.gView hidenLoading];
//    if (!self.collectionView.mj_footer) {
//        @weakify(self);
//        self.collectionView.mj_footer = [SQRefreshFooter footerWithRefreshingBlock:^{
//            @strongify(self);
//            [self footerMore];
//        }];
//    }
//    [self parseInfoToOriginDic:];
//    [self.gView stopHeaderRefresh];
//}

- (void)footerMore {
    [[self.gLiveNoticeViewModel getLiveNoticeListCmd] execute:nil];
}

- (void)footerMoreSuccessBlock:(WVRSectionModel*)sectionModel {
    [self.gView hidenLoading];
    if (self.originDic.count == 0) {
        [self.gView showNetErrorVWithreloadBlock:^{
            [self requestInfo];
        }];
    }
    [self.gView stopFooterMore:NO];
}


//@synthesize mCollectionV = _mCollectionV;
//
//+ (instancetype)createPresenter:(id)createArgs {
//    
//    WVRLiveNoticePresenter * presenter = [[WVRLiveNoticePresenter alloc] init];
//    presenter.cellNibNames = @[NSStringFromClass([WVRLiveReserveCell class])];
//    [presenter installRAC];
//    [presenter initCollectionView];
//    [presenter addRefreshObserver];
//    return presenter;
//}
//

//
//- (WVRHomePageCollectionView *)mCollectionV
//{
//    if (!_mCollectionV) {
//        _mCollectionV = (SQCollectionView*)[[WVRHomePageCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
//    }
//    return (WVRHomePageCollectionView*)_mCollectionV;
//}
//
- (void)installRAC
{
    @weakify(self);
    [[self.gLiveNoticeViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:x];
    }];
    [[self.gLiveNoticeViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self httpFailBlock:x];
    }];
    
}

//- (void)reserveSuccessBlock
//{
//    self.mCurReservecellInfo.itemModel.hasOrder = [NSString stringWithFormat:@"%d", ![self.mCurReservecellInfo.itemModel.hasOrder boolValue]];
//    NSString * curOrderC = self.mCurReservecellInfo.itemModel.liveOrderCount;
//    if ([self.mCurReservecellInfo.itemModel.hasOrder boolValue]) {
//        
//        self.mCurReservecellInfo.itemModel.liveOrderCount = [NSString stringWithFormat:@"%ld", [curOrderC integerValue] + 1];
//        
//    } else {
//        
//        self.mCurReservecellInfo.itemModel.liveOrderCount = [NSString stringWithFormat:@"%ld", [curOrderC integerValue] - 1];
//    }
////    [self.mCollectionV reloadData];
//    self.mCurReserveBtn.userInteractionEnabled = YES;
//    self.isReserving = NO;
//    if (self.successBlock) {
//        self.successBlock();
//    }
//}
//
//- (void)reserveFailBlock:(NSString*)msg
//{
//    SQToastInKeyWindow(msg);
////    [self.mCollectionV reloadData];
//    self.mCurReserveBtn.userInteractionEnabled = YES;
//    self.isReserving = NO;
//    if (self.failBlock) {
//        self.failBlock(msg);
//    }
//}
////
//- (void)reloadData {
//    
//    if (self.collectionVOriginDic.count == 0) {
//        [self requestInfo];
//    }
//}
//
//- (UIView *)getView {
//    
//    return self.mCollectionV;
//}
//
//- (void)initCollectionView {
//    
//    [super initCollectionView];
//    kWeakSelf(self);
//    SQRefreshHeader * refreshHeader = [SQRefreshHeader headerWithRefreshingBlock:^{
//        [weakself headerRefreshRequest];
//    }];
//    refreshHeader.stateLabel.hidden = YES;
//    self.mCollectionV.mj_header = refreshHeader;
//}
//
//
//- (void)requestInfo {
//    
//    [super requestInfo];
//    [self requestReserveHttp];
//}
//
//- (void)requestReserveHttp {
//    
//    SQShowProgressIn(self.mCollectionV);
//    [self headerRefreshRequest];
//}
//
//- (void)addRefreshObserver {
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefreshRequest) name:NAME_NOTF_RESERVE_PRESENTER_REFRESH object:nil];
//}
//
//- (void)onDestroy {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (void)headerRefreshRequest {
//    [(WVRHomePageCollectionView*)[self mCollectionV] clear];
//    [[self.gLiveNoticeViewModel getLiveNoticeListCmd] execute:nil];
//}
//
- (void)httpSuccessBlock:(NSArray*)args
{
    [self.gView hidenLoading];
    [self.gView stopHeaderRefresh];
    if (args.count==0) {
        @weakify(self);
        [self.gView showNullViewWithTitle:@"当前暂无直播预告，横划去看精彩回顾吧" icon:@"icon_live_reserve_empty" withreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
        return;
    }
    [self parseInfoToOriginDic:args];
}

- (void)httpFailBlock:(NSString*)msg
{
    [self.gView hidenLoading];
    [self.gView stopHeaderRefresh];
    if (self.originDic.count == 0) {
        @weakify(self);
        [self.gView showNetErrorVWithreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
    }else{
        SQToastInKeyWindow(kNoNetAlert);
    }
}

//
//- (void)updateCollectionView {
//    
//    [self.collectionDelegate loadData:self.collectionVOriginDic];
//    [self.mCollectionV reloadData];
//}
//
//- (WVRLiveReserveCellInfo*)getReserveCellInfo:(WVRLiveItemModel* )item {
//    
//    kWeakSelf(self);
//    WVRLiveReserveCellInfo * cellInfo = [WVRLiveReserveCellInfo new];
//    cellInfo.cellNibName = NSStringFromClass([WVRLiveReserveCell class]);
//    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(266.f));
//    cellInfo.itemModel = item;
//    __weak WVRLiveReserveCellInfo * weakCellInfo = cellInfo;
//    cellInfo.reserveBlock = ^(UIButton* button){
//        [weakself reserveBlock:button reserveCellInfo:weakCellInfo];
//    };
//    cellInfo.gotoNextBlock = ^(id args){
//        [weakself reserveCellInfoNextBlock:weakCellInfo];
//    };
//    return cellInfo;
//}
//
//- (void)reserveBlock:(UIButton*)button reserveCellInfo:(WVRLiveReserveCellInfo *)cellInfo {
//    
//    if (self.isReserving) {
//        SQToastInKeyWindow(@"直播预约中...");
//        return ;
//    }
//    self.mCurReservecellInfo = cellInfo;
//    self.mCurReserveBtn = button;
//    [self checkReserveStatus];
//}
//
//- (void)reserveCellInfoNextBlock:(WVRLiveReserveCellInfo *)cellInfo {
//    
//    kWeakSelf(self);
//    if (self.isReserving) {
//        SQToastInKeyWindow(@"直播预约中...");
//        return ;
//    }
//    __weak WVRLiveReserveCellInfo * weakCellInfo = cellInfo;
//    cellInfo.itemModel.reserveBlock = ^(void(^successBlock)(void),void(^failBlock)(NSString*), UIButton* btn){
//        weakself.successBlock = successBlock;
//        weakself.failBlock = failBlock;
//        weakCellInfo.reserveBlock(btn);
//    };
//    [WVRGotoNextTool gotoNextVC:cellInfo.itemModel nav:self.controller.navigationController];
//}
//
//- (void)goReserveLive {
//    
////    kWeakSelf(self);
//    self.mCurReserveBtn.userInteractionEnabled = NO;
//    self.isReserving = YES;
//    self.gLiveNoticeViewModel.code = self.mCurReservecellInfo.itemModel.code;
//    if ([self.mCurReservecellInfo.itemModel.hasOrder boolValue]){
//        [[self.gLiveNoticeViewModel getLiveNoticecancelCmd] execute:nil];
//    }else{
//            [[self.gLiveNoticeViewModel getLiveNoticeaddCmd] execute:nil];
//    }
//}
//
//- (void)checkReserveStatus {
//    
//    if ([self.mCurReservecellInfo.itemModel.hasOrder boolValue] ) {
//        [self shouldCanelReserveLive];
//    } else {
//        [self shouldReserveLive];
//    }
//}
//
//- (void)shouldCanelReserveLive {
//    
//    [self goReserveLive];
//}
//
//- (void)shouldReserveLive {
//    @weakify(self);
//    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        @strongify(self);
//        if (self.mCurReservecellInfo.itemModel.isChargeable) {
//            //            SQToastInKeyWindow(@"跳到详情");
//            [WVRGotoNextTool gotoNextVC:self.mCurReservecellInfo.itemModel nav:[UIViewController getCurrentVC].navigationController];
//        }else{
//            [self goReserveLive];
//        }
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            
//            return nil;
//        }];
//    }];
//    NSDictionary * params = @{@"completeCmd":cmd};
//    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:params];
//
//}
//
//- (SQCollectionViewSectionInfo*)getSectionInfo:(NSArray*)itemModels {
//    
//    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
//    NSMutableArray * cellInfos = [NSMutableArray array];
//    
//    for (WVRLiveItemModel * cur in itemModels) {
//        [cellInfos addObject:[self getReserveCellInfo:cur]];
//    }
//    sectionInfo.cellDataArray = cellInfos;
//    return sectionInfo;
//}
//
//- (void)backForResult:(id)info resultCode:(NSInteger)resultCode {
//    
//    
//}

@end
