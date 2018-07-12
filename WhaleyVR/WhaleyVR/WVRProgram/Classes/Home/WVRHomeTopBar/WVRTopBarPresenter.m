//
//  WVRFindTopBarPresenterImpl.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTopBarPresenter.h"
#import "WVRTopTabViewProtocol.h"

#import "WVRBaseViewCProtocol.h"
#import "WVRSectionModel.h"
#import "WVRTopBarViewModel.h"
#import "WVRHttpRecommendPageDetailModel.h"

@interface WVRTopBarPresenter ()

@property (nonatomic, weak) id<WVRTopTabViewProtocol, WVRBaseViewCProtocol> mTopBarView;

@property (nonatomic, strong) WVRTopBarViewModel * gTopBarViewModel;

@property (nonatomic, assign) NSInteger gMixPageIndex;

@end


@implementation WVRTopBarPresenter

- (instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view
{
    self = [super init];
    if (self) {
        if ([view conformsToProtocol:@protocol(WVRTopTabViewProtocol)] && [view conformsToProtocol:@protocol(WVRBaseViewCProtocol)]) {
            self.args = params;
            self.mTopBarView = (id <WVRTopTabViewProtocol,WVRBaseViewCProtocol>)view;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
        [self installRAC];
    }
    return self;
}

- (WVRTopBarViewModel *)gTopBarViewModel
{
    if (!_gTopBarViewModel) {
        _gTopBarViewModel = [[WVRTopBarViewModel alloc] init];
    }
    return _gTopBarViewModel;
}

- (void)installRAC
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

- (void)fetchData
{
    [self requestInfo];
}

- (void)requestInfo:(id)requestParams
{
    self.args = requestParams;
    [self requestInfo];
}

- (void)requestInfo
{
    [self http_recommendPageWithCode:self.args];
}

#pragma mark - http movie

- (void)http_recommendPageWithCode:(NSString*)code
{
    if (self.mItemModels.count==0) {
        [self.mTopBarView showLoadingWithText:nil];
    }
    self.gTopBarViewModel.code = code;
    [[self.gTopBarViewModel getTopBarListCmd] execute:nil];
}

- (void)filterModelType:(NSArray*)originModels
{
    for (WVRItemModel * cur in originModels) {
        
        switch (cur.linkType_) {
            case WVRLinkTypeMix:
                [self.mItemModels addObject:cur];
                self.gMixPageIndex = [self.mItemModels indexOfObject:cur];
                break;
            case WVRLinkTypeList:
                [self.mItemModels addObject:cur];
                break;
            case WVRLinkTypePage:
                [self.mItemModels addObject:cur];
                break;
//            case WVRLinkTypeTitle:
//                [self.mItemModels addObject:cur];
//                break;
            default:
                break;
        }
    }
}

- (void)httpSuccessBlock:(WVRHttpRecommendPageDetailModel *)args {
    [self.mTopBarView hidenLoading];
    NSArray * recommendAreas = [args  recommendAreas];
    WVRSectionModel * sectionModel = [self parseSectionHttpModel:[recommendAreas firstObject]];
    _mItemModels = [NSMutableArray new];
    [self filterModelType:sectionModel.itemModels];
    if (self.mItemModels.count == 0) {
        @weakify(self);
        [self.mTopBarView showNullViewWithTitle:nil icon:nil withreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
    } else {
        NSMutableArray * curTitles = [NSMutableArray new];
        for (WVRItemModel* cur in self.mItemModels) {
            NSLog(@"linkArrangeType%@", cur.linkArrangeType);
            NSLog(@"linkType:%ld", (long)cur.linkType_);
            [curTitles addObject:cur.name];
        }
        [self.mTopBarView updateWithTitles:curTitles andItemModels:self.mItemModels];
    }
}

- (void)failBlock:(NSString*)msg
{
    [self.mTopBarView hidenLoading];
    if (self.mItemModels.count == 0) {
        @weakify(self);
        [self.mTopBarView showNetErrorVWithreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
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

-(NSInteger)gMixPageIndex
{
    return _gMixPageIndex;
}

@end
