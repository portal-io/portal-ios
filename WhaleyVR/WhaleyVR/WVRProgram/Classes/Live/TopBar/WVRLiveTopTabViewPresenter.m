//
//  WVRLiveTopTabViewPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveTopTabViewPresenter.h"
#import "WVRLiveTopTabViewImpl.h"
#import "WVRMyReservationController.h"
#import "WVRLiveTopTabViewPresenter.h"

#import "WVRSectionModel.h"

#import "WVRMediator+AccountActions.h"

#import "WVRTopBarViewModel.h"
#import "WVRHttpRecommendPageDetailModel.h"

@interface WVRLiveTopTabViewPresenter ()<WVRLiveTopTabVDelegate>

@property (nonatomic) WVRLiveTopTabViewImpl * mTTView;
@property (nonatomic) NSArray * itemArray;

@property (nonatomic, strong) WVRTopBarViewModel * gTopBarViewModel;


@end


@implementation WVRLiveTopTabViewPresenter

+ (instancetype)createPresenter:(id)createArgs
{
    WVRLiveTopTabViewPresenter * presenter = [[WVRLiveTopTabViewPresenter alloc] init];
    
    [presenter loadViews];
    [presenter installRAC];
    return presenter;
}

- (void)loadViews
{
    self.titles = @[];
    WVRLiveTopTabViewImpl * ttView = [WVRLiveTopTabViewImpl loadViewWithFrame:CGRectZero viewPresenter:self];
    ttView.backgroundColor = [UIColor whiteColor];
    self.mTTView = ttView;
}

- (UIView *)getView
{
    return self.mTTView;
}

- (void)reloadData{
    [self requestInfo];
}

-(WVRTopBarViewModel *)gTopBarViewModel
{
    if (!_gTopBarViewModel) {
        _gTopBarViewModel = [[WVRTopBarViewModel alloc] init];
    }
    return _gTopBarViewModel;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gTopBarViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:x];
    }];
    [[self.gTopBarViewModel mFailSignal] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self failBlock:x.errorMsg];
    }];
}

-(void)failBlock:(NSString*)msg
{
//    [self.mTopBarView hidenLoading];
//    if (self.mItemModels.count == 0) {
//        @weakify(self);
//        [self.mTopBarView showNetErrorVWithreloadBlock:^{
//            @strongify(self);
//            [self requestInfo];
//        }];
//    }
    if ([msg isKindOfClass:[NSString class]]) {
        if (self.refreshFaileBlock) {
            self.refreshFaileBlock(msg);
        }
    }
}

#pragma mark - WVRLiveTopTabVDelegate

- (void)didSelectSegmentItem:(NSInteger)index
{
    if ([self.controller respondsToSelector:@selector(didSelectItem:)]) {
        [self.controller didSelectItem:index];
    }
}

- (void)onClickMineReserveBtn
{
    if ([[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:nil]) {
        WVRMyReservationController * vc = [WVRMyReservationController new];
        vc.title = @"我的预约";
        vc.hidesBottomBarWhenPushed = YES;
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
}

- (void)updateSegmentSelectIndex:(NSInteger)index
{
    [self.mTTView updateSegmentSelectIndex:index];
}

- (NSInteger)getSelectIndex
{
    return [self.mTTView getSelectIndex];
}

- (void)requestInfo
{
    [self http_recommendPageWithCode:@"live_tab"];
}

#pragma http movie
- (void)http_recommendPageWithCode:(NSString*)code
{
    self.gTopBarViewModel.code = code;
    [[self.gTopBarViewModel getTopBarListCmd] execute:nil];
//    kWeakSelf(self);
//    WVRHtttpRecommendPage  * cmd = [WVRHtttpRecommendPage new];
//    cmd.code = code;//kHttpParams_RecommendPage_code_movie;
//    //    if (self.haveTV) {
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    params[kHttpParams_HaveTV] = @"1";
//    cmd.bodyParams = params;
//    //    }
//    cmd.successedBlock = ^(WVRHttpRecommendPageDetailParentModel* args){
//        [weakself httpSuccessBlock:args];
//    };
//    
//    cmd.failedBlock = ^(id args){
//        if ([args isKindOfClass:[NSString class]]) {
//            if (weakself.refreshFaileBlock) {
//                weakself.refreshFaileBlock(args);
//            }
//        }
//    };
//    [cmd execute];
}

- (void)httpSuccessBlock:(WVRHttpRecommendPageDetailModel* )args{
    NSArray * recommendAreas = [args  recommendAreas];
    WVRSectionModel * sectionModel = [self parseSectionHttpModel:[recommendAreas firstObject]];
    self.itemArray = sectionModel.itemModels;
    if (sectionModel.itemModels.count == 0) {
        self.refreshFaileBlock(@"无内容");
    }else{
        NSMutableArray * curTitles = [NSMutableArray new];
        for (WVRItemModel* cur in self.itemArray) {
            [curTitles addObject:cur.name];
        }
        self.titles = curTitles;
        [self.mTTView updateData:self.scrollView];
        if (self.refreshSuccessBlock) {
            self.refreshSuccessBlock(self.itemArray);
        }
    }
}

- (WVRSectionModel*)parseSectionHttpModel:(WVRHttpRecommendArea*)recommendArea
{
    WVRSectionModel* sectionModel = [WVRSectionModel new];
    WVRSectionModelType sectionType = [sectionModel parseSectionTypeWithHttpRecAreaType:recommendArea.type];
    sectionModel.sectionType = sectionType;
    
    sectionModel.itemModels = [self parseHotHttpRecommendArea:recommendArea];
    return sectionModel;
}

- (NSMutableArray*)parseHotHttpRecommendArea:(WVRHttpRecommendArea*)recommendArea
{
    NSMutableArray * models = [NSMutableArray array];
    for (WVRHttpRecommendElement* element in [recommendArea recommendElements]) {
        WVRItemModel * model = [self parseHttpTextElement:element];
        [models addObject:model];
    }
    return models;
}

- (WVRItemModel *)parseHttpTextElement:(WVRHttpRecommendElement* )element
{
    WVRItemModel * model = [WVRItemModel new];
    model.name = element.name;
    model.linkArrangeType = element.linkArrangeType;
    model.linkArrangeValue = element.linkArrangeValue;
    model.recommendPageType = element.recommendPageType;
    model.code = element.code;
    model.recommendAreaCodes = element.recommendAreaCodes;
    return model;
}

- (void)dealloc
{
    DDLogDebug(@"");
}


@end
