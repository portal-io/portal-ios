//
//  WVRCollectionViewPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAutoArrangePresenter.h"
#import "SQCollectionViewDelegate.h"
#import "WVRAutoArrangeControllerProtocol.h"
#import "WVRAutoArrangeViewModel.h"

#import "WVRBaseViewSection.h"
#import "WVRViewModelDispatcher.h"
#import "WVRSectionModel.h"

@interface WVRAutoArrangePresenter ()

@property (nonatomic) UIView<WVRAutoArrangeControllerProtocol>* gView;
@property (nonatomic) WVRAutoArrangeViewModel *gAutoArrangeViewModel;

@property (nonatomic, strong) SQCollectionViewDelegate * gDelegate;

@property (nonatomic) NSMutableDictionary * mOriginDic;

@property (nonatomic) WVRSectionModel * mSectionModel;
@property (nonatomic, strong) WVRSectionModel * gParams;

@property (nonatomic, copy) void(^endRefreshBlock)(void);
@property (nonatomic, copy) void(^endBlock)(BOOL isNoMore);

@end
@implementation WVRAutoArrangePresenter

-(instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view
{
    self = [super init];
    if (self) {
        if ([view conformsToProtocol:@protocol(WVRAutoArrangeControllerProtocol)]) {
            self.gView = (UIView<WVRAutoArrangeControllerProtocol>*)view;
        }else{
            NSException *exception = [[NSException alloc] initWithName:@"" reason:@"view not conformsTo WVRAutoArrangeViewCProtocol" userInfo:nil];
            @throw exception;
        }
        self.gParams = params;
        
        self.mOriginDic = [NSMutableDictionary new];
        [self installRAC];
    }
    return self;
}


-(SQCollectionViewDelegate *)gDelegate
{
    if (!_gDelegate) {
        _gDelegate = [[SQCollectionViewDelegate alloc] init];
    }
    return _gDelegate;
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


#pragma mark - WVRPresenterProtocol

-(void)fetchData
{
    [self requestInfo];
}

#pragma mark - WVRListPresenterProtocol

-(void)fetchRefreshData
{
    [self headerRefresh];
}

-(void)fetchMoreData
{
    [self footerMore];
}


- (void)requestInfo {
    
    if (self.mSectionModel.itemModels.count==0) {
        [self.gView showLoadingWithText:@""];
        [self headerRefresh];
    }
}

- (void)headerRefresh{
    
    if (self.mSectionModel.itemModels.count==0) {
        
    }
    [self httpRequest];
}

- (void)httpRequest {
    self.gAutoArrangeViewModel.code = self.gParams.linkArrangeValue;
    [[self.gAutoArrangeViewModel getAutoArrangeCmd] execute:nil];

}

- (void)httpTVRequest {
    

}

- (void)headerRefreshSuccessBlock:(WVRSectionModel*)sectionModel {
    
    [self.gView hidenLoading];
    self.mSectionModel = sectionModel;
    if (self.mSectionModel.itemModels.count==0) {
        @weakify(self);
        [self.gView showNullViewWithTitle:nil icon:nil withreloadBlock:^{
            @strongify(self);
            [self fetchData];
        }];
        return ;
    }
    self.mSectionModel.sectionType = WVRSectionModelTypeArrange;
    self.mOriginDic[@(0)] = [self sectionInfo:self.mSectionModel];
    [self.gDelegate loadData:self.mOriginDic];
    if (!self.gView.getCollectionView.delegate) {
        [self.gView setDelegate:self.gDelegate andDataSource:self.gDelegate];
    }
    [self.gView reloadData];
    [self endRefresh];
}

- (void)footerMore {
    
    
    if (self.mSectionModel.pageNum == self.mSectionModel.totalPages-1) {
        [self endRefreshNoMore];
        return;
    }
    if (self.mSectionModel.itemModels.count==0) {
        [self.gView showLoadingWithText:@""];
    }
    [self httpMoreRequest];
}

- (void)httpMoreRequest {
    
    [[self.gAutoArrangeViewModel getAutoArrangeMoreCmd] execute:nil];

}

- (void)footerMoreSuccessBlock:(WVRSectionModel*)sectionModel {
    
    [self.gView hidenLoading];
    self.mSectionModel = sectionModel;
    self.mSectionModel.sectionType = WVRSectionModelTypeArrange;
    self.mOriginDic[@(0)] = [self sectionInfo:self.mSectionModel];
    [self.gDelegate loadData:self.mOriginDic];
    if (!self.gView.getCollectionView.delegate) {
        [self.gView setDelegate:self.gDelegate andDataSource:self.gDelegate];
    }
    [self.gView reloadData];
    if (self.mSectionModel.pageNum == self.mSectionModel.totalPages) {
        [self endRefreshNoMore];
    }else{
        [self endRefresh];
    }
}

- (WVRBaseViewSection *)sectionInfo:(WVRSectionModel *)sectionModel {
    
    //    NSLog(@"recommendAreaType:%ld",(long)sectionModel.sectionType);
    WVRBaseViewSection * sectionInfo = nil;
    NSInteger type = sectionModel.sectionType;
    sectionInfo = [WVRViewModelDispatcher dispatchSection:[NSString stringWithFormat:@"%d",(int)type] args:sectionModel];//[self getADSectionInfo:sectionModel type:type];
    [sectionInfo registerNibForCollectionView:[self.gView getCollectionView]];
//    sectionInfo.viewController = (UIViewController*)self.gView;
    return sectionInfo;
}

- (void)endRefresh {
    [self.gView stopHeaderRefresh];
    [self.gView stopFooterMore:NO];
}

- (void)endRefreshNoMore {
    [self.gView stopFooterMore:YES];
    
}

- (void)networkFaild {
    [self endRefresh];
    [self.gView hidenLoading];
    kWeakSelf(self);
    if (self.mOriginDic.count==0) {
        [self.gView showNetErrorVWithreloadBlock:^{
            [weakself requestInfo];
        }];
    }else{
        SQToastInKeyWindow(kNoNetAlert);
    }
}

@end
