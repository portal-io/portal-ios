//
//  WVRAllChannelPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAllChannelPresenter.h"
#import "WVRAllChannelViewModel.h"
#import "WVRItemModel.h"
#import "WVRViewModelDispatcher.h"
#import "WVRBaseViewSection.h"
#import "WVRSectionModel.h"

#import "WVRAllChannelCProtocol.h"

@interface WVRAllChannelPresenter ()

@property (nonatomic, weak) id<WVRAllChannelCProtocol> gView;

@property (nonatomic, strong) SQCollectionViewDelegate * gDelegate;

@property (nonatomic, strong) NSMutableDictionary * gOriginDic;

@property (nonatomic, strong) WVRAllChannelViewModel* gViewModel ;

@end


@implementation WVRAllChannelPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self installRAC];
    }
    return self;
}

- (instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view {
    self = [super initWithParams:params attchView:view];
    
    if (self) {
        [self installRAC];
    }
    return self;
}

-(NSMutableDictionary *)gOriginDic
{
    if (!_gOriginDic) {
        _gOriginDic = [[NSMutableDictionary alloc] init];
    }
    return _gOriginDic;
}

-(WVRAllChannelViewModel *)gViewModel
{
    if (!_gViewModel) {
        _gViewModel = [[WVRAllChannelViewModel alloc] init];
    }
    return _gViewModel;
}

-(SQCollectionViewDelegate *)gDelegate
{
    if (!_gDelegate) {
        _gDelegate = [[SQCollectionViewDelegate alloc] init];
    }
    return _gDelegate;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self successBlock:x];
    }];
    [[self.gViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self failBlock:x];
    }];
}

- (void)fetchData {
    
    //    if (!self.mViewModel) {
    
    //    }
    if (self.gOriginDic.count == 0) {
        [self.gView showLoadingWithText:nil];
    }
    [[self.gViewModel getAllChannelCmd] execute:nil];
}

-(void)fetchRefreshData
{
    [self fetchData];
}

- (void)headerRequestInfo {

    [[self.gViewModel getAllChannelCmd] execute:nil];
}

- (void)successBlock:(NSArray<WVRItemModel *> *)originData {
    [self.gView hidenLoading];
    [self.gView stopHeaderRefresh];
    if (originData.count == 0) {
        @weakify(self);
        [self.gView showNullViewWithTitle:nil icon:nil withreloadBlock:^{
            @strongify(self);
            [self fetchData];
        }];
        return;
    }
    
    WVRSectionModel * sectionModel = [WVRSectionModel new];
    sectionModel.sectionType = WVRSectionModelTypeAllChannel;
    sectionModel.itemModels = [NSMutableArray arrayWithArray:originData];
    
    WVRCollectionViewSectionInfo* sectionInfo = [self sectionInfo:sectionModel];
    self.gOriginDic[@(0)] = sectionInfo;
    [self.gView setDelegate:self.gDelegate andDataSource:self.gDelegate];
    [self.gDelegate loadData:self.gOriginDic];
    [self.gView reloadData];
}

- (WVRBaseViewSection *)sectionInfo:(WVRSectionModel *)sectionModel {
    
//    NSLog(@"recommendAreaType:%ld", (long)sectionModel.sectionType);
    WVRBaseViewSection * sectionInfo = nil;
    NSInteger type = sectionModel.sectionType;
    sectionInfo = [WVRViewModelDispatcher dispatchSection:[NSString stringWithFormat:@"%d", (int)type] args:sectionModel];//[self getADSectionInfo:sectionModel type:type];
    [sectionInfo registerNibForCollectionView:[self.gView getCollectionView]];
//    sectionInfo.viewController = self;
    return sectionInfo;
}

- (void)failBlock:(NSString *)msg {
    [self.gView hidenLoading];
    [self.gView stopHeaderRefresh];
    kWeakSelf(self);
    if (self.gOriginDic.count==0) {
        [self.gView showNetErrorVWithreloadBlock:^{
            [weakself fetchData];
        }];
    }else{
        SQToastInKeyWindow(kNoNetAlert);
    }
    
}


@end
