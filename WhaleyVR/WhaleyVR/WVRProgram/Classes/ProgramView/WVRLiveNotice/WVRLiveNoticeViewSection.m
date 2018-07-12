//
//  WVRBannerViewRouter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveNoticeViewSection.h"
#import "WVRSQBannerReusableHeader.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVRGotoNextTool.h"
#import "WVRLiveRecommendBannerCell.h"
#import "WVRLiveRecTitleHeader.h"
#import "WVRLiveRecReviewCell.h"
#import "WVRLiveRecReBannerCell.h"
#import "WVRSQFindSplitCell.h"
#import "WVRLiveItemModel.h"
#import "WVRLiveReserveCell.h"
#import "WVRLiveNoticeViewModel.h"
#import "WVRMediator+AccountActions.h"

#import "WVRProgramBIModel.h"

#define MIN_SPACE_ITEM (1.0f)

@interface WVRLiveNoticeViewSection()

@property (nonatomic) WVRLiveNoticeViewModel * gLiveNoticeViewModel;

@property (nonatomic) NSInteger mCurSectionIndex;
@property (nonatomic) BOOL isClickColletV;
@property (nonatomic) WVRLiveReserveCellInfo * mCurReservecellInfo;
@property (nonatomic) UIButton * mCurReserveBtn;
@property (nonatomic) BOOL isReserving;

@property (nonatomic, copy) void(^successBlock)(void);
@property (nonatomic, copy) void(^failBlock)(NSString * errStr);


@end

@implementation WVRLiveNoticeViewSection

#pragma mark - Banner section

@section(([NSString stringWithFormat:@"%d", (int)WVRSectionModelTypeLiveNotice]), NSStringFromClass([WVRLiveNoticeViewSection class]))

- (instancetype)init {
    self = [super init];
    if (self) {
        [self installRAC];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView {
    
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRSQFindSplitCell class], [WVRLiveReserveCell class]];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    NSArray* allHeaderClass = @[];
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
}

-(WVRLiveNoticeViewModel *)gLiveNoticeViewModel
{
    if (!_gLiveNoticeViewModel) {
        _gLiveNoticeViewModel = [[WVRLiveNoticeViewModel alloc] init];
    }
    return _gLiveNoticeViewModel;
}

- (void)installRAC
{
    @weakify(self);
    
    [[self.gLiveNoticeViewModel gAddCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self reserveSuccessBlock];
    }];
    [[self.gLiveNoticeViewModel gAddFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self reserveFailBlock:x];
    }];
    
    [[self.gLiveNoticeViewModel gCancleCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self reserveSuccessBlock];
    }];
    [[self.gLiveNoticeViewModel gCancleFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self reserveFailBlock:x];
    }];
}

- (WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel {
        
    WVRBaseViewSection * sectionInfo = self;
    NSMutableArray * cellInfos = [NSMutableArray array];

    for (WVRLiveItemModel * cur in sectionModel.itemModels) {
        [cellInfos addObject:[self getReserveCellInfo:cur]];
    }
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}

- (WVRLiveReserveCellInfo*)getReserveCellInfo:(WVRLiveItemModel* )item {

    kWeakSelf(self);
    WVRLiveReserveCellInfo * cellInfo = [WVRLiveReserveCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVRLiveReserveCell class]);
    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(266.f));
    cellInfo.itemModel = item;
    __weak WVRLiveReserveCellInfo * weakCellInfo = cellInfo;
    cellInfo.reserveBlock = ^(UIButton* button){
        [weakself reserveBlock:button reserveCellInfo:weakCellInfo];
    };
    cellInfo.gotoNextBlock = ^(id args){
        [weakself reserveCellInfoNextBlock:weakCellInfo];
    };
    return cellInfo;
}

- (void)reserveBlock:(UIButton*)button reserveCellInfo:(WVRLiveReserveCellInfo *)cellInfo {

    if (self.isReserving) {
        SQToastInKeyWindow(@"直播预约中...");
        return ;
    }
    self.mCurReservecellInfo = cellInfo;
    self.mCurReserveBtn = button;
    [self checkReserveStatus];
}

- (void)reserveCellInfoNextBlock:(WVRLiveReserveCellInfo *)cellInfo {

    kWeakSelf(self);
    if (self.isReserving) {
        SQToastInKeyWindow(@"直播预约中...");
        return ;
    }
    __weak WVRLiveReserveCellInfo * weakCellInfo = cellInfo;
    cellInfo.itemModel.reserveBlock = ^(void(^successBlock)(void),void(^failBlock)(NSString*), UIButton* btn){
        weakself.successBlock = successBlock;
        weakself.failBlock = failBlock;
        weakCellInfo.reserveBlock(btn);
    };
    [self gotoNextItemVC:cellInfo.itemModel];
}

- (void)goReserveLive {

//    kWeakSelf(self);
    self.mCurReserveBtn.userInteractionEnabled = NO;
    self.isReserving = YES;
    self.gLiveNoticeViewModel.code = self.mCurReservecellInfo.itemModel.code;
    if ([self.mCurReservecellInfo.itemModel.hasOrder boolValue]){
        [[self.gLiveNoticeViewModel getLiveNoticecancelCmd] execute:nil];
    }else{
            [[self.gLiveNoticeViewModel getLiveNoticeaddCmd] execute:nil];
    }
}

- (void)checkReserveStatus {

    if ([self.mCurReservecellInfo.itemModel.hasOrder boolValue] ) {
        [self shouldCanelReserveLive];
    } else {
        [self shouldReserveLive];
    }
}

- (void)shouldCanelReserveLive {

    [self goReserveLive];
}

- (void)shouldReserveLive {
    @weakify(self);
    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (self.mCurReservecellInfo.itemModel.isChargeable) {
            //            SQToastInKeyWindow(@"跳到详情");
            [WVRGotoNextTool gotoNextVC:self.mCurReservecellInfo.itemModel nav:[UIViewController getCurrentVC].navigationController];
        }else{
            [self goReserveLive];
        }
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

            return nil;
        }];
    }];
    NSDictionary * params = @{@"completeCmd":cmd};
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:params];

}

- (void)reserveSuccessBlock {
    
    self.mCurReservecellInfo.itemModel.hasOrder = [NSString stringWithFormat:@"%d", ![self.mCurReservecellInfo.itemModel.hasOrder boolValue]];
    NSString * curOrderC = self.mCurReservecellInfo.itemModel.liveOrderCount;
    if ([self.mCurReservecellInfo.itemModel.hasOrder boolValue]) {

        self.mCurReservecellInfo.itemModel.liveOrderCount = [NSString stringWithFormat:@"%ld", [curOrderC integerValue] + 1];
        
        [WVRProgramBIModel trackEventForDetailWithAction:BIDetailActionTypeReserveLive sid:self.mCurReservecellInfo.itemModel.sid name:self.mCurReservecellInfo.itemModel.title];
        
    } else {

        self.mCurReservecellInfo.itemModel.liveOrderCount = [NSString stringWithFormat:@"%ld", [curOrderC integerValue] - 1];
    }
    self.mCurReserveBtn.userInteractionEnabled = YES;
    self.isReserving = NO;
    if (self.successBlock) {
        self.successBlock();
    }
}

-(void)reserveFailBlock:(NSString*)msg
{
    SQToastInKeyWindow(msg);
    self.mCurReserveBtn.userInteractionEnabled = YES;
    self.isReserving = NO;
    if (self.failBlock) {
        self.failBlock(msg);
    }
}
@end
