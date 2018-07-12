//
//  WVRManualArrangePresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRManualArrangePresenter.h"
#import "WVRManualArrangeViewCProtocol.h"
#import "WVRManualArrangeViewModel.h"
#import "WVRProgramBIModel.h"
#import "WVRBaseViewSection.h"
#import "WVRSectionModel.h"
#import "WVRSQArrangeMAHeader.h"

@interface WVRManualArrangePresenter () {
    
    BOOL _isFirstIn;
    int _isChargeable;
    BOOL _isProgramSet;
}

@property (nonatomic, strong) NSMutableDictionary * gOriginDic;

@property (nonatomic, strong) WVRManualArrangeViewModel * gViewModel;

@end


@implementation WVRManualArrangePresenter

- (instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view
{
    self = [super initWithParams:params attchView:view];
    if (self) {
        if ([view conformsToProtocol:@protocol(WVRManualArrangeViewCProtocol)]) {
            _args = params;
            _gView = (id<WVRManualArrangeViewCProtocol>)view;
            [self installRAC];
        } else {
            NSException *exception = [[NSException alloc] initWithName:[self description] reason:@"view not conformsTo WVRManualArrangeViewCProtocol" userInfo:nil];
            @throw exception;
        }
    }
    return self;
}

- (SQCollectionViewDelegate *)gCollectionDelegate
{
    if (!_gCollectionDelegate) {
        _gCollectionDelegate = [SQCollectionViewDelegate new];
        kWeakSelf(self);
        _gCollectionDelegate.scrollDidScrolling = ^(CGFloat y) {
            [weakself scrollDidScrollingBlock:y];
            [weakself.gView scrollDidScrollingBlock:y];
        };

    }
    return _gCollectionDelegate;
}

- (void)scrollDidScrollingBlock:(CGFloat)y {
    
    if (y > 0) {

        SQCollectionViewSectionInfo* sectionInfo = self.gOriginDic[@(0)];
        WVRSQArrangeMAHeaderInfo * headerInfo = (WVRSQArrangeMAHeaderInfo *)sectionInfo.headerInfo;
        if (headerInfo.playStatusBlock) {
            headerInfo.playStatusBlock(1 - fabs(y) / (fitToWidth(211) - kNavBarHeight));
        }
    }
    else {
        SQCollectionViewSectionInfo* sectionInfo = self.gOriginDic[@(0)];
        WVRSQArrangeMAHeaderInfo * headerInfo = (WVRSQArrangeMAHeaderInfo *)sectionInfo.headerInfo;
        if (headerInfo.playStatusBlock) {
            headerInfo.playStatusBlock(1);
        }
    }
}

- (WVRManualArrangeViewModel *)gViewModel
{
    if (!_gViewModel) {
        _gViewModel = [[WVRManualArrangeViewModel alloc] init];
    }
    return _gViewModel;
}

- (void)installRAC
{
    @weakify(self);
    [[self.gViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:x];
    }];
    [[self.gViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self httpFailBlock:x];
    }];
}

- (void)fetchData {
    
    if ([self.args isKindOfClass:[WVRSectionModel class]] && [(WVRSectionModel *)self.args isActivity]) {
        
        [self httpSuccessBlock:self.args];
    } else {
        
        [self requestData];
    }
}

#pragma mark - request

- (void)requestData {
//    kWeakSelf(self);
    [self.gView showLoadingWithText:nil];
    self.gViewModel.code = [self.args linkArrangeValue];
    [[self.gViewModel getManualArrangeCmd] execute:nil];
//    [self.gViewModel requestData:[self.args linkArrangeValue] successBlock:^(id<WVRModelProtocol>args) {
//        [weakself httpSuccessBlock:args];
//    } failBlock:^(id<WVRErrorProtocol> error) {
//        [weakself httpFailBlock:@""];
//    }];
}

- (void)httpSuccessBlock:(WVRSectionModel *)args {
    
    [self.gView hidenLoading];
    if (args.isActivity && [NSStringFromClass(self.gView.class) isEqualToString:@"WVRManualArrangeController"]) {
        
        [self.gView gotoSpring2018TopicVC:args];
        
    } else {
        
        [self parseInfoToOriginDic:args];
    }
}

- (void)parseInfoToOriginDic:(WVRSectionModel *)args {
    
    if (!self.gOriginDic) {
        self.gOriginDic = [NSMutableDictionary dictionary];
    }
    [self.gOriginDic removeAllObjects];
    
    [self.gView hidenLoading];
    
    [self.args setName:args.name];
    [self.args setThubImageUrl:args.thubImageUrl];
    [self.args setIntrDesc:args.intrDesc];
    _isChargeable = args.isChargeable;
    _isProgramSet = ([args.packModel packageType] == WVRPackageTypeProgramSet);
    
    args.sectionType = WVRSectionModelTypeManualArrange;
    
    self.gOriginDic[@(0)] = [self sectionInfo:args];
    [self installShareSectionInfo];
    
//    [self requestForMobLinkId];
    
    [self.gView updateTitle:args.name];
    [self.gView setDelegate:self.gCollectionDelegate andDataSource:self.gCollectionDelegate];
    [self.gCollectionDelegate loadData:self.gOriginDic];
    [self.gView reloadData];
    
    if (!_isFirstIn) {
        
        [self.biDelegate trackEventForPackBrowse];
        
        _isFirstIn = YES;
    }
}

- (void)installShareSectionInfo {
    
    NSMutableArray * array = [NSMutableArray new];
    
    for (NSString * cur in [self iconStrs]) {
        WVRItemModel * model = [WVRItemModel new];
        model.name = cur;
        model.thubImageUrl = cur;
        [array addObject:model];
    }
    WVRSectionModel * sectionModel = [WVRSectionModel new];
    sectionModel.itemModels = array;
    sectionModel.linkArrangeValue = [self.args linkArrangeValue];
    sectionModel.linkArrangeType = [self.args linkArrangeType];
    sectionModel.name = [self.args name];
    sectionModel.thubImageUrl = [self.args thubImageUrl];
    sectionModel.intrDesc = [self.args intrDesc];
    sectionModel.sectionType = WVRSectionModelTypeManualArrangeShare;
    self.gOriginDic[@(1)] = [self sectionInfo:sectionModel];
}

- (NSArray *)iconStrs {
    
    return [NSArray arrayWithObjects:@"share_icon_sina", @"share_icon_wechat", @"share_icon_friends", @"share_icon_qq", @"share_icon_qzone", nil];
}

- (WVRBaseViewSection *)sectionInfo:(WVRSectionModel *)sectionModel {
    
//    NSLog(@"recommendAreaType:%ld", (long)sectionModel.sectionType);
    WVRBaseViewSection * sectionInfo = nil;
    NSInteger type = sectionModel.sectionType;
    sectionInfo = [WVRViewModelDispatcher dispatchSection:[NSString stringWithFormat:@"%d", (int)type] args:sectionModel];//[self getADSectionInfo:sectionModel type:type];
    [sectionInfo registerNibForCollectionView:[self.gView getCollectionView]];
//    sectionInfo.viewController = self.viewController;
    return sectionInfo;
}

- (void)httpFailBlock:(NSString *)args {
    kWeakSelf(self);
    [self.gView showNetErrorVWithreloadBlock:^{
        [weakself fetchData];
    }];
}

- (void)requestForMobLinkId {
    
//#warning waiting done
//    MLSDKScene *scene = [[MLSDKScene alloc] initWithMLSDKPath:@"" source:@"" params:@{}];
//
//    kWeakSelf(self);
//    [MobLink getMobId:scene result:^(NSString *mobid) {
//        weakself.mobLinkId = mobid;
//    }];
}

#pragma mark - BI getter

- (NSString *)biPageId {

    return [self.args linkArrangeValue];
}

- (NSString *)biPageTitle {
    
    return [self.args name];
}

- (int)biIsChargeable {
    
    return _isChargeable;
}

- (BOOL)isProgramSet {
    
    return _isProgramSet;
}

@end
