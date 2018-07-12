//
//  WVRProgramPackagePresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRProgramPackagePresenter.h"
#import "WVRProgramPackageViewModel.h"
//#import "WVRMyOrderItemModel.h"

#import "WVRSectionModel.h"

#import "WVRMediator+PayActions.h"
#import "WVRProgramPackageViewModel.h"
#import "WVRProgramPackageCProtocol.h"

@interface WVRProgramPackagePresenter ()

@property (nonatomic, strong) NSMutableDictionary * gOriginDic;

@property (nonatomic, strong) WVRProgramPackageViewModel * gViewModel;

@end


@implementation WVRProgramPackagePresenter

- (WVRProgramPackageViewModel *)gViewModel
{
    if (!_gViewModel) {
        _gViewModel = [[WVRProgramPackageViewModel alloc] init];
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
    
    [self requestData];
}

#pragma mark - request

- (void)requestData {
    
    [self.gView showLoadingWithText:nil];
    self.gViewModel.code = [self.args linkArrangeValue];
    [[self.gViewModel getManualArrangeCmd] execute:nil];
}

- (void)refresh
{
    [self.gOriginDic removeAllObjects];
    [self.gCollectionDelegate loadData:self.gOriginDic];
    [self.gView reloadData];
    [self requestData];
}

- (void)httpSuccessBlock:(WVRSectionModel *)args {
    // 普通专题（手动编排）
    if (![args isChargeable]) {
        [super httpSuccessBlock:args];
        return;
    }
    if (!args.haveCharged) {
        [args setHaveCharged:[args programPackageHaveCharged]];
    }
    
    if ([args haveCharged]||[args programPackageHaveCharged]) {
        [super httpSuccessBlock:args];
        [(id<WVRProgramPackageCProtocol>)self.gView updatePayStatus:args];
    } else {
        [[WVRMediator sharedInstance] WVRMediator_CheckVideoIsPaied:[self createCheckPayedParams:args]];
    }
}

- (NSDictionary *)createCheckPayedParams:(WVRSectionModel *)sctionModel {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            BOOL isCharged = [input boolValue];
            sctionModel.haveCharged = isCharged;
                            // 只能购买合集，单个节目没有对应券，不需要判断其是否已购买
            if (isCharged || [[sctionModel type] isEqualToString:@"0"]) {
                [super httpSuccessBlock:sctionModel];
                [(id<WVRProgramPackageCProtocol>)self.gView updatePayStatus:sctionModel];
            } else {
                [self requestForListItemCharged:sctionModel];
            }
            
            return nil;
        }];
    }];
    
//    param[@"item"] = sctionModel;
    param[@"goodNo"] = sctionModel.linkArrangeValue;
    param[@"goodType"] = @"content_packge";
    param[@"cmd"] = cmd;
    return param;
}

- (void)httpFailBlock:(NSString *)args {
    kWeakSelf(self);
    [self.gView showNetErrorVWithreloadBlock:^{
        [weakself fetchData];
    }];
}

- (void)requestForListItemCharged:(WVRSectionModel *)args {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSArray *  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            [self dealWithCheckGoodPayList:input args:args];
            
            return nil;
        }];
    }];
    
    param[@"cmd"] = cmd;
    NSMutableArray *arr = [NSMutableArray array];
    for (WVRItemModel *item in args.itemModels) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"goodNo"] = item.sid;
        dict[@"goodType"] = item.contentType;
        
        [arr addObject:dict];
    }
    param[@"items"] = arr;
    
    [[WVRMediator sharedInstance] WVRMediator_CheckVideosIsPaied:param];
}

- (void)dealWithCheckGoodPayList:(NSArray *)list args:(WVRSectionModel *)args {
    
    int count = 0;
    for (NSDictionary *resDic in list) {
        
        if (args.itemModels.count > count) {
            int isCharged = [resDic[@"result"] intValue];
            NSString *goodsNo = resDic[@"goodsNo"];
            WVRItemModel *itemModel = [args.itemModels objectAtIndex:count];
            
            if ([goodsNo isEqualToString:itemModel.linkArrangeValue]) {
                
                itemModel.packageItemCharged = @(isCharged);
            }
        }
        
        count += 1;
    }
    
    [super httpSuccessBlock:args];
    
    [(id<WVRProgramPackageCProtocol>)self.gView updatePayStatus:args];
}

@end
