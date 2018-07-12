//
//  WVRBrandZonePresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBrandZonePresenter.h"
#import "WVRBrandZoneVCModel.h"
#import "WVRSQMoreReusableHeader.h"
#import "WVRSQBrandCell.h"
#import "WVRSQFindUIStyleHeader.h"
#import "WVRBrandZoneViewCProtocol.h"
#import "WVRBaseViewSection.h"

@interface WVRBrandZonePresenter ()

@property (nonatomic, strong) id args;

@property (nonatomic, weak) id<WVRBrandZoneViewCProtocol> gView;

@property (nonatomic, strong) NSMutableDictionary * gOriginDic;

@property (nonatomic, strong) SQCollectionViewDelegate * gDelegate;

@property (nonatomic) WVRBrandZoneVCModel *mBrandModel;

@end

@implementation WVRBrandZonePresenter


-(instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view
{
    self = [super initWithParams:params attchView:view];
    if (self) {
        if ([view conformsToProtocol:@protocol(WVRBrandZoneViewCProtocol)]) {
            self.gView = (id<WVRBrandZoneViewCProtocol>)view;
        }else{
            NSException *exception = [[NSException alloc] initWithName:[self description] reason:@"view not conformsTo WVRBrandZoneViewCProtocol" userInfo:nil];
            @throw exception;
        }
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

-(NSMutableDictionary *)gOriginDic
{
    if (!_gOriginDic) {
        _gOriginDic = [[NSMutableDictionary alloc] init];
    }
    return _gOriginDic;
}

-(WVRBrandZoneVCModel *)mBrandModel
{
    if(!_mBrandModel){
        _mBrandModel = [[WVRBrandZoneVCModel alloc] init];
        
    }
    return _mBrandModel;
}

-(void)fetchData
{
    [self httpRequest];
}

-(void)fetchRefreshData
{
    [self httpRequest];
}

-(void)fetchMoreData
{
    if (self.mBrandModel.sectionModel.pageNum == self.mBrandModel.sectionModel.totalPages-1) {
        [self endRefreshNoMore];
        return;
    }
    [self.gView showLoadingWithText:nil];
    [self httpRequest];
}

-(void)httpRequest
{
    kWeakSelf(self);
    [self.gView showLoadingWithText:nil];
    [self.mBrandModel http_recommendPageWithCode:[(WVRBaseModel*)self.args linkArrangeValue] successBlock:^(WVRSectionModel *args) {
        [weakself httpSuccessBlock:args];
    } failBlock:^(NSString *args) {
        [weakself httpFailBlock:args];
    }];
}

- (void)httpSuccessBlock:(WVRSectionModel*)args
{
    if (args.itemModels.count == 0) {
        [self.gView showToast:@"暂无内容"];
    }else{
        self.gOriginDic[@(0)] = [self sectionInfo:args];
        [self.gView setDelegate:self.gDelegate andDataSource:self.gDelegate];
        [self.gView reloadData];
    }
    WVRSectionModel* sectionModel = args;
    if (sectionModel.pageNum == sectionModel.totalPages) {
        [self endRefreshNoMore];
    }else{
        [self endRefresh];
    }

}

-(void)httpFailBlock:(NSString*)args
{
    [self.gView hidenLoading];
    if (self.gOriginDic.count>0) {
        SQToastInKeyWindow(kNoNetAlert);
        return ;
    }
    kWeakSelf(self);
    [self.gView showNetErrorVWithreloadBlock:^{
        [weakself fetchData];
    }];
}



-(void)endRefresh
{
    [self.gView stopHeaderRefresh];
    [self.gView stopFooterMore:NO];
}

-(void)endRefreshNoMore
{
    [self.gView stopFooterMore:YES];
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



@end
