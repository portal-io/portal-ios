//
//  WVRMyReservationPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyReservationPresenter.h"
#import "SQTableView.h"
#import "SQRefreshHeader.h"
#import "SQTableViewDelegate.h"

#import "WVRNullCollectionViewCell.h"
#import "WVRMyReserveCell.h"
#import "WVRGotoNextTool.h"
#import "WVRLiveItemModel.h"

//#import "WVRInAppPurchaseManager.h"
#import "WVRSectionModel.h"
#import "WVRMediator+PayActions.h"
#import "WVRMyReservationViewModel.h"
#import "WVRErrorViewModel.h"
#import "WVRBaseViewCProtocol.h"

@interface WVRMyReservationPresenter ()

@property (nonatomic, weak) id<WVRBaseViewCProtocol> gView;
@property (nonatomic) SQTableView* tableView;
@property (nonatomic) SQTableViewDelegate * tableVDelegate;
@property (nonatomic) NSMutableDictionary * originDic;

@property (nonatomic) WVRNullCollectionViewCell * mNullView;


@property (nonatomic, strong) WVRMyReservationViewModel * gMyReservationViewModel;

@end
@implementation WVRMyReservationPresenter
//+ (instancetype)createPresenter:(id)createArgs {
//
//    WVRMyReservationPresenter * presenter = [[WVRMyReservationPresenter alloc] init];
//    presenter.controller = createArgs;
//    [presenter installRAC];
//    [presenter loadSubViews];
//    return presenter;
//}

- (instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view
{
    self = [super init];
    if (self) {
        
        self.gView = view;
        [self installRAC];
    }
    return self;
}

-(WVRMyReservationViewModel *)gMyReservationViewModel
{
    if (!_gMyReservationViewModel) {
        _gMyReservationViewModel = [[WVRMyReservationViewModel alloc] init];
    }
    return _gMyReservationViewModel;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gMyReservationViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:x];
    }];
    [[self.gMyReservationViewModel mFailSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[WVRErrorViewModel class]]) {
            [self httpFialBlock:[(WVRErrorViewModel*)x errorMsg]];
        }else if([x isKindOfClass:[NSString class]]){
            [self httpFialBlock:x];
        }
        
    }];
}

- (void)loadSubViews {
    kWeakSelf(self);
    SQRefreshHeader * refreshHeader = [SQRefreshHeader headerWithRefreshingBlock:^{
        [weakself requestInfo];
    }];
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
}

- (void)fetchData {
    [self requestInfo];
}

- (SQTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[SQTableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self.tableVDelegate;
        _tableView.dataSource = self.tableVDelegate;
    }
    return _tableView;
}

- (SQTableViewDelegate *)tableVDelegate {
    
    if (!_tableVDelegate) {
        _tableVDelegate = [SQTableViewDelegate new];
    }
    return _tableVDelegate;
}

- (void)requestInfo {
    
    if (!self.originDic) {
        self.originDic = [NSMutableDictionary new];
    }
    if (self.originDic.count == 0) {
        [self.gView showLoadingWithText:@""];
    }
    [self requestReserveHttp];
}

- (void)requestReserveHttp {
    
    [self headerRefreshRequest];
}

- (void)headerRefreshRequest {
    
    [[self.gMyReservationViewModel getMyReservationCmd] execute:nil];
}

- (void)httpSuccessBlock:(NSArray<WVRItemModel*> *)models {
    
    [self requestForListItemCharged:models];
}

- (void)updateUI:(NSArray *)array {
    [self.gView hidenLoading];
    if (array.count==0) {
        @weakify(self);
        [self.gView showNullViewWithTitle:@"暂无预约节目" icon:@"icon_cach_video_empty" withreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
        return;
    }
    SQTableViewSectionInfo * sectionInfo = [self getSectionInfo:array];
    self.originDic[@(0)] = sectionInfo;
    [self updateTableView];
    [self.tableView.mj_header endRefreshing];
}

- (void)requestForListItemCharged:(NSArray *)items {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSArray *  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            [self dealWithCheckGoodPayList:input items:items];
            
            return nil;
        }];
    }];
    NSMutableArray * params = [[NSMutableArray alloc] init];
    for (WVRItemModel* item in items) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        dic[@"goodNo"] = item.code;
        dic[@"goodType"] = @"live";
        [params addObject:dic];
    }
    param[@"cmd"] = cmd;
    param[@"items"] = params;
    
    [[WVRMediator sharedInstance] WVRMediator_CheckVideosIsPaied:param];
}

- (void)dealWithCheckGoodPayList:(NSArray *)list items:(NSArray *)items {
    
    int count = 0;
    for (NSDictionary *resDic in list) {

        if (items.count > count) {
            int isCharged = [resDic[@"result"] intValue];
            NSString *goodsNo = resDic[@"goodsNo"];
            WVRItemModel *itemModel = [items objectAtIndex:count];

            if ([goodsNo isEqualToString:itemModel.code]) {

                itemModel.packageItemCharged = @(isCharged);
            }
        }

        count += 1;
    }
    [self updateUI:items];
}


- (void)httpFialBlock:(NSString *)errMsg {
    [self.gView hidenLoading];
    [self.tableView.mj_header endRefreshing];
    if (self.originDic.count != 0) {
        SQToastInKeyWindow(kNoNetAlert);
        return;
    }
    [self.gView detailLoadFail:nil];
}

- (SQTableViewSectionInfo*)getSectionInfo:(NSArray*)itemModels {
    
    kWeakSelf(self);
    SQTableViewSectionInfo * sectionInfo = [SQTableViewSectionInfo new];
    NSMutableArray * cellInfos = [NSMutableArray array];
    
    for (WVRLiveItemModel * cur in itemModels) {
        WVRMyReserveCellInfo * cellInfo = [WVRMyReserveCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRMyReserveCell class]);
        cellInfo.cellHeight = fitToWidth(126.f);
        cellInfo.itemModel = cur;
        cellInfo.gotoNextBlock = ^(WVRMyReserveCellInfo* args){
            [weakself cellInfoNextBlock:args.itemModel];
        };
        [cellInfos addObject:cellInfo];
    }
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}

- (void)cellInfoNextBlock:(WVRItemModel*)itemModel {
    
//    if (itemModel.liveStatus == WVRLiveStatusEnd) {
//        SQToastInKeyWindow(@"该直播已结束，去看看精彩回顾吧～");
//    } else {
        [WVRGotoNextTool gotoNextVC:itemModel nav:[UIViewController getCurrentVC].navigationController];
//    }
}

- (void)updateTableView {
    
    kWeakSelf(self);
    [self.tableVDelegate loadData:^NSDictionary *{
        return weakself.originDic;
    }];
    [self.tableView reloadData];
}


- (UIView *)getView {
    
    return self.tableView;
}
@end
