//
//  WVRGiftPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftPresenter.h"
#import "WVRGiftRewardViewModel.h"
#import "WVRGiftTempViewModel.h"
#import "WVRCollectionViewAdapter.h"
#import "WVRCollectionViewModel.h"
#import "WVRGiftCollectionCell.h"
#import "SQZeroSpaceCollVFlowLayout.h"
#import "WVRRewardMCollectionCell.h"
#import "WVRCurrencyCostViewModel.h"
#import "WVRWebSocketMsg.h"
#import "WVRMediator+Danmu.h"
#import "WVRMediator+Currency.h"

#import "WVRProgramBIModel.h"

@interface WVRGiftPresenter()<WVRPageViewDelegate, WVRPageViewDataSource>

@property (nonatomic, assign) NSInteger gPageIndex;

@property (nonatomic, weak) WVRGiftTempView * gGiftView;
@property (nonatomic, strong) NSMutableArray * gGiftViewAdapters;
@property (nonatomic, strong) NSMutableArray * gGiftOriginDics;

@property (nonatomic, strong) WVRCollectionViewAdapter * gMembersViewAdapter;
@property (nonatomic, strong) NSMutableDictionary * gMembersOriginDic;

@property (nonatomic, weak) WVRGiftCollectionCellViewModel * gChooseGiftViewModel;
@property (nonatomic, weak) WVRRewardMCollectionCellViewModel * gChooseMemberViewModel;

@property (nonatomic, strong) WVRGiftRewardViewModel * gGiftRewardViewModel;

@property (nonatomic, strong) WVRGiftTempViewModel * gGiftTempViewModel;
@property (nonatomic, strong) NSArray * gGiftTempModels;

@property (nonatomic, strong) WVRGiftPresenterParams * gParams;

@property (nonatomic, strong) WVRCurrencyCostViewModel * gCurrencyCostViewModel;

@property (nonatomic, weak) UIView * containView;

@property (nonatomic, weak) UIView * gDanmuCell;

@end

@implementation WVRGiftPresenter

-(instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view
{
    self = [super initWithParams:params attchView:view];
    if (self) {
//        [self gGiftOriginDics];
//        [self installRAC];
    }
    return self;
}

-(WVRGiftViewModel *)gGiftViewModel
{
    if (!_gGiftViewModel) {
        _gGiftViewModel = [[WVRGiftViewModel alloc] init];
        @weakify(self);
        _gGiftViewModel.gSendGiftCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            [self sendGift];
            return [RACSignal empty];
        }];
        _gGiftViewModel.gSendMemberCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            [self sendMemberGift];
            return [RACSignal empty];
        }];
        _gGiftViewModel.gGoRechargeCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            [self goRecharge];
            return [RACSignal empty];
        }];
        RAC(_gGiftViewModel,wCurrencyBalance) = RACObserve([WVRUserModel sharedInstance], wcBalance);
    }
    return _gGiftViewModel;
}

-(NSMutableArray *)gGiftOriginDics
{
    if (!_gGiftOriginDics) {
        _gGiftOriginDics = [[NSMutableArray alloc] init];
    }
    return _gGiftOriginDics;
}

-(NSMutableArray *)gGiftViewAdapters
{
    if (!_gGiftViewAdapters) {
        _gGiftViewAdapters = [[NSMutableArray alloc] init];
    }
    return _gGiftViewAdapters;
}

-(WVRGiftTempView *)gGiftView
{
    if (!_gGiftView) {
        _gGiftView = (WVRGiftTempView*)VIEW_WITH_NIB(@"WVRGiftTempView");
        _gGiftView.hidden = YES;
        [_gGiftView bindViewModel:self.gGiftViewModel];
        _gGiftView.gGiftPageView.delegate = self;
        _gGiftView.gGiftPageView.dataSource = self;
    }
    return _gGiftView;
}

-(WVRCurrencyCostViewModel *)gCurrencyCostViewModel
{
    if (!_gCurrencyCostViewModel) {
        _gCurrencyCostViewModel = [[WVRCurrencyCostViewModel alloc] init];
    }
    return _gCurrencyCostViewModel;
}

-(BOOL)checkCanSendGift:(WVRGiftModel* )giftModel
{
    NSInteger wCurrencyBalance = self.gGiftViewModel.wCurrencyBalance;
    if (wCurrencyBalance<[giftModel.price integerValue]) {
        SQToastBottomIn(@"余额不足，请充值", self.gGiftView);
        return NO;
    }
    if (giftModel.giftCode.length==0) {
        SQToastBottomIn(@"还未选择礼物",self.gGiftView);
        return NO;
    }
    return YES;
}

-(void)sendGift{
    WVRGiftModel* cur = self.gChooseGiftViewModel.args;
    if (![self checkCanSendGift:cur]) {
        return;
    }
    self.gCurrencyCostViewModel.buyParams = cur.giftCode;
    self.gCurrencyCostViewModel.bizParams = self.gParams.programCode;
    [[self.gCurrencyCostViewModel getCurrencyCostCmd] execute:nil];
    self.gGiftViewModel.wCurrencyBalance -= [cur.price integerValue];
    [self updateChooseGiftItem:nil];
}

-(void)sendMemberGift{
    WVRGiftModel* cur = self.gChooseGiftViewModel.args;
    if (![self checkCanSendGift:cur]) {
        return;
    }
    WVRProgramMemberModel * member = self.gChooseMemberViewModel.args;
    self.gCurrencyCostViewModel.buyParams = cur.giftCode;
    self.gCurrencyCostViewModel.bizParams = [NSString stringWithFormat:@"%@,%@", self.gParams.programCode, member.memberCode];
    [[self.gCurrencyCostViewModel getCurrencyCostCmd] execute:nil];
    self.gGiftViewModel.wCurrencyBalance -= [cur.price integerValue];
    [self updateChooseGiftItem:nil];
}

-(void)goRecharge
{
    UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_CurrencyConfigViewController];
    WVRNavigationController * nv = [[WVRNavigationController alloc] initWithRootViewController:vc];
    UIViewController * curVC = [UIViewController getCurrentVC];
    
    [curVC.navigationController presentViewController:nv animated:YES completion:nil];
}

-(UIView*)bindContainerView:(UIView*)view
{
    self.containView = view;
    [view addSubview:self.gGiftView];
    [self.gGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.height.mas_equalTo(408.f);
        make.bottom.equalTo(view);
    }];
    return self.gGiftView;
}

-(void)reloadData
{
    [self.gGiftView.gProgramMembersView registerNib:[UINib nibWithNibName:@"WVRRewardMCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"WVRRewardMCollectionCell"];
    self.gGiftView.gProgramMembersView.delegate = self.gMembersViewAdapter;
    self.gGiftView.gProgramMembersView.dataSource = self.gMembersViewAdapter;
    [self.gMembersViewAdapter loadData:self.gMembersOriginDic];
    
    //    if (self.gGiftTempModels.count>0) {
    [self parserGiftTempModels:self.gGiftTempModels];
    //    }else{
    //        @weakify(self);
    //        [self.gGiftRewardViewModel.mCompleteSignal subscribeNext:^(id  _Nullable x) {
    //            @strongify(self);
    //            [self parserMembersModels:x];
    //        }];
    //        [self.gGiftTempViewModel.mCompleteSignal subscribeNext:^(id  _Nullable x) {
    //            @strongify(self);
    //            self.gGiftTempModels = x;
    //            [self parserGiftTempModels:self.gGiftTempModels];
    //        }];
    //        [[self.gGiftTempViewModel getGiftTemoCmd] execute:nil];
    //    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.gGiftView.gProgramMembersView reloadData];
        [self.gGiftView.gGiftPageView reloadData];
    });
}

-(void)setParams:(WVRGiftPresenterParams*)params
{
    self.gParams = params;
    [self installRAC];
}

-(WVRCollectionViewAdapter *)gMembersViewAdapter
{
    if (!_gMembersViewAdapter) {
        _gMembersViewAdapter = [[WVRCollectionViewAdapter alloc] init];
    }
    return _gMembersViewAdapter;
}

-(NSMutableDictionary *)gMembersOriginDic
{
    if(!_gMembersOriginDic){
        _gMembersOriginDic = [[NSMutableDictionary alloc] init];
    }
    return _gMembersOriginDic;
}

-(WVRGiftRewardViewModel *)gGiftRewardViewModel
{
    if (!_gGiftRewardViewModel) {
        _gGiftRewardViewModel = [[WVRGiftRewardViewModel alloc] init];
    }
    return _gGiftRewardViewModel;
}

-(WVRGiftTempViewModel *)gGiftTempViewModel
{
    if (!_gGiftTempViewModel) {
        _gGiftTempViewModel = [[WVRGiftTempViewModel alloc] init];
    }
    return _gGiftTempViewModel;
}

-(void)installRAC
{
    RAC(self.gGiftRewardViewModel, code) = RACObserve(self.gParams, programCode);
    RAC(self.gGiftTempViewModel, tempCode) = RACObserve(self.gParams, tempCode);
    @weakify(self);
    [self.gGiftRewardViewModel.mCompleteSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self parserMembersModels:x];
    }];
    [self.gGiftTempViewModel.mCompleteSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gGiftTempModels = x;
    }];
//    RAC(self.gGiftViewModel, isPortrait) = RACObserve(self, isPortrait);
    [RACObserve(self.gGiftViewModel, toPageIndex) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self scrollViewToIndex:self.gGiftViewModel.toPageIndex];
    }];
    [RACObserve(self, viewIsHiden) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gGiftView.hidden = self.viewIsHiden;
        self.gDanmuCell.hidden = self.viewIsHiden;
        [self updateChooseMemberItem:self.gChooseMemberViewModel];
        [self updateChooseGiftItem:nil];
    }];
    [self installCurrencyCostRAC];
    void(^danmuBlock)(UIView* view) = ^(UIView * view) {
        [self receiveGiftDanmuBlock:view];
    };
    [[WVRMediator sharedInstance] WVRMediator_SetReceiveGiftDanmuBlockParams:@{@"receiveGiftDanmuMsgCallback":danmuBlock}];
}

-(void)receiveGiftDanmuBlock:(UIView* )view
{
    if (!view.superview) {
        self.gDanmuCell = view;
        self.gDanmuCell.hidden = self.viewIsHiden;
        [self.containView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containView);
            make.height.mas_equalTo(view.height);
            make.width.mas_equalTo(view.width);
            make.bottom.equalTo(self.gGiftView.mas_top);
        }];
    }else{
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.containView);
            make.height.mas_equalTo(view.height);
            make.width.mas_equalTo(view.width);
//            make.bottom.equalTo(self.gGiftView.mas_top);
        }];
    }
    
}

- (void)installCurrencyCostRAC {
//    @weakify(self);
    [self.gCurrencyCostViewModel.mCompleteSignal subscribeNext:^(id  _Nullable x) {
        [[WVRMediator sharedInstance] WVRMediator_GetUserWCBalance];
//        @strongify(self);
        // 11706 横屏直播节目，送出礼物后，需要弹出toast提示
        UIViewController *vc = [UIViewController getCurrentVC];
        if (vc.view.width > vc.view.height) {
            SQToastInKeyWindow(@"礼物已送出");
        }
        
        /// 礼物发送事件埋点
        [WVRProgramBIModel trackEventForInteraction:BIInteractionTypeGift biModel:[self biModel]];
    }];
    [self.gCurrencyCostViewModel.mFailSignal subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
        SQToastInKeyWindow(@"礼物未送出");
    }];
}

-(void)parserMembersModels:(NSArray<WVRProgramMemberModel*>*)models
{
    SQCollectionViewSectionInfo * viewModel = [[SQCollectionViewSectionInfo alloc] init];
    //    viewModel.edgeInsets = UIEdgeInsetsMake(fitToWidth(0), fitToWidth(2), fitToWidth(0), fitToWidth(2));
    NSMutableArray * cellViewModels = [[NSMutableArray alloc] init];
    for (WVRProgramMemberModel* cur in models) {
        WVRRewardMCollectionCellViewModel * cellViewModel = [[WVRRewardMCollectionCellViewModel alloc] init];
        cellViewModel.cellNibName = @"WVRRewardMCollectionCell";
        cellViewModel.args = cur;
        cellViewModel.cellSize = CGSizeMake(62, 73);
        @weakify(self);
        cellViewModel.gotoNextBlock = ^(WVRRewardMCollectionCellViewModel * viewModel) {
            @strongify(self);
            [self updateChooseMemberItem:viewModel];
        };
        [cellViewModels addObject:cellViewModel];
    }
    if (cellViewModels.count > 0) {
        self.gGiftViewModel.enableProgramMembers = YES;
    } else {
        self.gGiftViewModel.enableProgramMembers = NO;
    }
    viewModel.cellDataArray = cellViewModels;
    self.gMembersOriginDic[@(0)] = viewModel;
}

-(void)updateChooseMemberItem:(WVRRewardMCollectionCellViewModel*)viewModel
{
    if(viewModel.isSelected){
        
    }else{
        for (WVRRewardMCollectionCellViewModel * cur in [self.gMembersOriginDic[@(0)] cellDataArray]) {
            cur.isSelected = NO;
        }
    }
    viewModel.isSelected = !viewModel.isSelected;
    if (viewModel.isSelected) {
        self.gGiftViewModel.memberName = ((WVRProgramMemberModel*)viewModel.args).memberName;
    }
    self.gGiftViewModel.enableSendMember = viewModel.isSelected;
    self.gChooseMemberViewModel = viewModel;
}

-(void)parserGiftTempModels:(NSArray<WVRGiftModel*>*)models
{
    [self.gGiftOriginDics removeAllObjects];
    [self.gGiftViewAdapters removeAllObjects];
    NSInteger pageSize = self.isPortrait? COUNT_PRO_ITEM_PAGE:COUNT_HOR_ITEM_PAGE;
    NSInteger pageCount = models.count/pageSize;
    NSInteger otherSize = models.count%pageSize;
    
    for (int pageNum = 0 ; pageNum <= pageCount; pageNum++) {
        NSInteger curSize = pageSize;
        if (pageNum == pageCount) {
            curSize = otherSize;
        }
        if (curSize != 0) {
            NSRange range = NSMakeRange(pageNum*pageSize, curSize);
            NSArray * pageModels = [models objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            SQCollectionViewSectionInfo * sectionInfo = [self parserGiftItemTempModels:pageModels];
            if (sectionInfo) {
                NSMutableDictionary * pageDic = [[NSMutableDictionary alloc] init];
                pageDic[@(0)] = sectionInfo;
                [self.gGiftOriginDics addObject:pageDic];
                [self.gGiftViewAdapters addObject:[[WVRCollectionViewAdapter alloc] init]];
            }
        }
    }
    if (self.isPortrait) {
        if (pageSize > models.count) {      // 防止数组越界
            pageSize = models.count;
        }
        NSRange range = NSMakeRange(0 * pageSize, pageSize);
        NSArray * pageModels = [models objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        if (pageModels.count <= 4) {
            self.gGiftViewModel.pageViewHeight = HEIGHT_PORTRAIT_PAGE;
        } else {
            self.gGiftViewModel.pageViewHeight = HEIGHT_HOR_PAGE;
        }
    } else {
        self.gGiftViewModel.pageViewHeight = HEIGHT_PORTRAIT_PAGE;
    }
    self.gGiftViewModel.pageCount = self.gGiftOriginDics.count;
//    self.gGiftViewModel.curPageIndex = 0;
}

-(SQCollectionViewSectionInfo*)parserGiftItemTempModels:(NSArray<WVRGiftModel*>*)models
{
    SQCollectionViewSectionInfo * viewModel = [[SQCollectionViewSectionInfo alloc] init];
    NSMutableArray * cellViewModels = [[NSMutableArray alloc] init];
    for (WVRGiftModel* cur in models) {
        WVRGiftCollectionCellViewModel * cellViewModel = [[WVRGiftCollectionCellViewModel alloc] init];
        cellViewModel.cellNibName = @"WVRGiftCollectionCell";
        cellViewModel.args = cur;
        NSInteger row = self.isPortrait? (COUNT_PRO_ITEM_PAGE/2):COUNT_HOR_ITEM_PAGE;
        int cellHeight = self.isPortrait? 127:HEIGHT_PORTRAIT_PAGE;
        int cellWidth = (int)self.gGiftView.gGiftPageView.width/row;
        cellViewModel.cellSize = CGSizeMake(cellWidth, cellHeight);
        @weakify(self);
        cellViewModel.gotoNextBlock = ^(WVRGiftCollectionCellViewModel * viewModel) {
            @strongify(self);
            [self updateChooseGiftItem:viewModel];
        };
        [cellViewModels addObject:cellViewModel];
    }
    viewModel.cellDataArray = cellViewModels;
//    self.gGiftTempCollectionOriginDic[@(0)] = viewModel;
    return viewModel;
}

-(void)updateChooseGiftItem:(WVRGiftCollectionCellViewModel*)viewModel
{
    if(viewModel.isSelected){
        
    }else{
        for (NSDictionary* pageDic in self.gGiftOriginDics) {
            for (WVRGiftCollectionCellViewModel * cur in [pageDic[@(0)] cellDataArray]) {
                cur.isSelected = NO;
            }
        }
    }
    viewModel.isSelected = !viewModel.isSelected;
    self.gGiftViewModel.enableSendGift = viewModel.isSelected;
    self.gChooseGiftViewModel = viewModel;
}

-(void)fetchData
{
    if (self.gParams.showMembers && self.gParams.programCode.length > 0) {
        [[self.gGiftRewardViewModel getProgramMembersCmd] execute:nil];
    }
    if (self.gParams.showGifts && self.gParams.tempCode.length > 0) {
        [[self.gGiftTempViewModel getGiftTemoCmd] execute:nil];
    }
}

-(NSInteger)numberOfPage:(WVRPageView *)pageView
{
    return self.gGiftOriginDics.count;
}

-(UIView *)subView:(WVRPageView *)pageView forIndex:(NSInteger)index
{
    UICollectionView * view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[SQZeroSpaceCollVFlowLayout new]];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    [view registerNib:[UINib nibWithNibName:@"WVRGiftCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"WVRGiftCollectionCell"];
    if (self.gGiftViewAdapters.count>index) {
        WVRCollectionViewAdapter * viewAdapter = self.gGiftViewAdapters[index];
        view.delegate = viewAdapter;
        view.dataSource = viewAdapter;
        [viewAdapter loadData:self.gGiftOriginDics[index]];
    }
    [view reloadData];
    return view;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    NSLog(@"did scroll index :%d", (int)index);
    self.gPageIndex = index;
    self.gGiftViewModel.curPageIndex = index;
}

- (void)scrollViewToIndex:(NSInteger)index
{
    float xx = self.gGiftView.gGiftPageView.frame.size.width * index;
    [self.gGiftView.gGiftPageView scrollRectToVisible:CGRectMake(xx, 0, self.gGiftView.gGiftPageView.frame.size.width, self.gGiftView.gGiftPageView.frame.size.height) animated:YES];
}

// MARK: - BI

- (WVRProgramBIModel *)biModel {
    
    WVRProgramBIModel *model = [[WVRProgramBIModel alloc] init];
    
    model.biPageId = self.gParams.programCode;
    model.biPageName = self.gParams.videoName;
    
    return model;
}

@end


@implementation WVRGiftPresenterParams

@end

