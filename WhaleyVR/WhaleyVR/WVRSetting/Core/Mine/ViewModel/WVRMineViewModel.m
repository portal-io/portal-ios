//
//  WVRMineViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMineViewModel.h"
#import "WVRUserModel.h"
#import "WVRTableViewSectionViewModel.h"
#import "WVRTableViewCellViewModel.h"
#import "WVRMineAvatarCellViewModel.h"
#import "WVRMineCommonCellViewModel.h"
#import "WVRMineSplitCellViewModel.h"
//#import "WVRGetUserInfoUseCase.h"

#import "WVRMediator+AccountActions.h"

@interface WVRMineViewModel ()

@property (nonatomic, strong) RACSubject * gGotoSubject;

@property (nonatomic, strong) RACSubject * gAvatarClickSubject;

@property (nonatomic, strong) NSMutableDictionary * gOriginDic;

//@property (nonatomic, strong) WVRGetUserInfoUseCase * gGetUserInfoUC;

@end


@implementation WVRMineViewModel
@synthesize gotoSignal = _gotoSignal;
@synthesize avatarClickSignal = _avatarClickSignal;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
//    @weakify(self);
//    RAC(self, nickName) = RACObserve([WVRUserModel sharedInstance], username);
//    RAC(self, avatar) = RACObserve([WVRUserModel sharedInstance], loginAvatar);
//    [[self.gGetUserInfoUC buildUseCase] subscribeNext:^(id  _Nullable x) {
////        @strongify(self);
//        
//    }];
    
//    [[self.gGetUserInfoUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *  _Nullable x) {
////        @strongify(self);
//        if (x.errorMsg.length>0) {
//            SQToastInKeyWindow(x.errorMsg);
//        }
//    }];
//    
}

//- (WVRGetUserInfoUseCase *)gGetUserInfoUC
//{
//    if (!_gGetUserInfoUC) {
//        _gGetUserInfoUC = [[WVRGetUserInfoUseCase alloc] init];
//    }
//    return _gGetUserInfoUC;
//}

- (WVRTableViewAdapter *)gTableViewAdapter
{
    if (!_gTableViewAdapter) {
        _gTableViewAdapter = [[WVRTableViewAdapter alloc] init];
    }
    return _gTableViewAdapter;
}

- (RACSubject *)updateModelSingal
{
    if (!_updateModelSingal) {
        _updateModelSingal = [RACSubject subject];
    }
    return _updateModelSingal;
}

- (void)fetchData
{
    [self updateOriginDic];
    [self.updateModelSingal sendNext:self.gOriginDic];
//    [[WVRMediator sharedInstance] WVRMediator_GetUserInfo];
}

- (void)updateOriginDic
{
    self.gOriginDic[@(0)] = [self getSectionViewModel];
    [self.gTableViewAdapter loadData:^NSDictionary *{
        return self.gOriginDic;
    }];
}

- (WVRTableViewSectionViewModel *)getSectionViewModel
{
    WVRTableViewSectionViewModel * sectionViewModel = [[WVRTableViewSectionViewModel alloc] init];
    NSMutableArray * cellViewModels = [[NSMutableArray alloc] init];
    
//    [cellViewModels addObject:[self getHeaderCellViewModel]];
//    [cellViewModels addObject:[self getSplitCellViewModel]];
    
    [cellViewModels addObject:[self getLocalCellViewModel]];
    [cellViewModels addObject:[self getCollectionCellViewModel]];
    [cellViewModels addObject:[self getSplitCellViewModel]];
    
//    [cellViewModels addObject:[self getRewardCellViewModel]];
    
    
    [cellViewModels addObject:[self getOfficelCellViewModel]];
    [cellViewModels addObject:[self getHelperCellViewModel]];
//    [cellViewModels addObject:[self getFeedBackCellViewModel]];
    [cellViewModels addObject:[self getSocreCellViewModel]];
    [cellViewModels addObject:[self getSplitCellViewModel]];
    
    [cellViewModels addObject:[self getSettingCellViewModel]];
    [cellViewModels addObject:[self getAbountCellViewModel]];
    
    sectionViewModel.cellDataArray = cellViewModels;
    return sectionViewModel;
}


- (WVRTableViewCellViewModel *)getHeaderCellViewModel
{
    WVRMineAvatarCellViewModel * cellVM = [[WVRMineAvatarCellViewModel alloc] initWithParams:nil];
    cellVM.gAvatarClickSubject = self.gAvatarClickSubject;
//    @weakify(self);
//    [cellVM.clickSignal subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
////        [self.gAvatarClickSubject sendNext:@(viewModel.clickType)];
//    }];
//    @weakify(self);
//    cellVM.clickBlock = ^(WVRMineAvatarCellViewModel* viewModel) {
//        @strongify(self);
//        [self.gAvatarClickSubject sendNext:@(viewModel.clickType)];
//    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getLocalCellViewModel
{
    WVRMineCommonCellViewModel * cellVM = [[WVRMineCommonCellViewModel alloc] initWithParams:nil];
    cellVM.icon = @"icon_local_account";
    cellVM.title = @"本地缓存";
    cellVM.subTitle = @"万能VR播放器";
    cellVM.bLineHidden = NO;
    @weakify(self);
    cellVM.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeLocal)];
    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getCollectionCellViewModel
{
    WVRMineCommonCellViewModel * cellVM = [[WVRMineCommonCellViewModel alloc] initWithParams:nil];
    cellVM.icon = @"icon_collection";
    cellVM.title = @"我的播单";
    cellVM.bLineHidden = YES;
    @weakify(self);
    cellVM.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeCollection)];
    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getRewardCellViewModel
{
    WVRMineCommonCellViewModel * cellVM = [[WVRMineCommonCellViewModel alloc] initWithParams:nil];
    cellVM.icon = @"icon_reward";
    cellVM.title = @"我的奖品";
    @weakify(self);
    cellVM.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeReward)];
    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getFeedBackCellViewModel
{
    WVRMineCommonCellViewModel * cellVM = [[WVRMineCommonCellViewModel alloc] initWithParams:nil];
    cellVM.icon = @"icon_report_answer";
    cellVM.title = @"问题反馈";
    cellVM.bLineHidden = NO;
    @weakify(self);
    cellVM.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeFeedBack)];
    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getOfficelCellViewModel
{
    WVRMineCommonCellViewModel * cellVM = [[WVRMineCommonCellViewModel alloc] initWithParams:nil];
    cellVM.icon = @"icon_officel";
    cellVM.title = @"官方论坛";
    cellVM.bLineHidden = NO;
    @weakify(self);
    cellVM.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeOfficel)];
    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getHelperCellViewModel
{
    WVRMineCommonCellViewModel * cellVM = [[WVRMineCommonCellViewModel alloc] initWithParams:nil];
    cellVM.icon = @"icon_helper_account";
    cellVM.title = @"使用帮助";
    cellVM.bLineHidden = NO;
    @weakify(self);
    cellVM.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeHelper)];
    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getSocreCellViewModel
{
    WVRMineCommonCellViewModel * cellVM = [[WVRMineCommonCellViewModel alloc] initWithParams:nil];
    cellVM.icon = @"score";
    cellVM.title = @"去评分";
    cellVM.bLineHidden = YES;
    @weakify(self);
    cellVM.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeSocre)];
    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getSettingCellViewModel
{
    WVRMineCommonCellViewModel * cellVM = [[WVRMineCommonCellViewModel alloc] initWithParams:nil];
    cellVM.icon = @"icon_setting";
    cellVM.title = @"设置";
    cellVM.subTitle = @"";
    cellVM.bLineHidden = NO;
    @weakify(self);
    cellVM.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeSetting)];
    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getAbountCellViewModel
{
    WVRMineCommonCellViewModel * cellVM = [[WVRMineCommonCellViewModel alloc] initWithParams:nil];
    cellVM.icon = @"icon_abount";
    cellVM.title = @"关于";
    cellVM.subTitle = @"加入官方粉丝群";
    cellVM.bLineHidden = YES;
    @weakify(self);
    cellVM.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeAbount)];
    };
    return cellVM;
}

- (WVRTableViewCellViewModel *)getSplitCellViewModel
{
    WVRMineSplitCellViewModel * cellVM = [[WVRMineSplitCellViewModel alloc] initWithParams:nil];
    return cellVM;
}


- (NSMutableDictionary *)gOriginDic
{
    if (!_gOriginDic) {
        _gOriginDic = [[NSMutableDictionary alloc] init];
    }
    return _gOriginDic;
}

- (RACSignal *)gotoSignal
{
    if (!_gotoSignal) {
        @weakify(self);
        RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gGotoSubject = subscriber;
            return nil;
        }];
        _gotoSignal = signal;
    }
    
    return _gotoSignal;
}

- (RACSignal *)avatarClickSignal
{
    if (!_avatarClickSignal) {
        @weakify(self);
        _avatarClickSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gAvatarClickSubject = subscriber;
            return nil;
        }];
    }
    return _avatarClickSignal;
}


- (NSArray *)mineResource
{
    @weakify(self);
    NSArray * array = @[@{@"icon":@"icon_local_account",@"title":@"本地缓存",@"subTitle":@"万能VR播放器",@"bLineHidden":@NO,@"gotoNextBlock":^(id args) {
        @strongify(self);
        [self.gGotoSubject sendNext:@(WVRMineCellTypeLocal)];
    }},
                        @{@"icon":@"icon_collection",@"title":@"我的播单",@"subTitle":@"",@"bLineHidden":@NO,@"gotoNextBlock":^(id args){
                            @strongify(self);
                            [self.gGotoSubject sendNext:@(WVRMineCellTypeCollection)];
                        }},
                        
                        @{@"icon":@"icon_reward",@"title":@"我的奖品",@"subTitle":@"",@"bLineHidden":@YES,@"gotoNextBlock":^(id args){
                            @strongify(self);
                            [self.gGotoSubject sendNext:@(WVRMineCellTypeReward)];
                        }},
                        ];
    
    return array;
}

@end
