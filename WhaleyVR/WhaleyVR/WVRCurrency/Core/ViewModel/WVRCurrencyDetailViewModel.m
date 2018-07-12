//
//  WVRCurrencyDetailViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyDetailViewModel.h"
#import "WVRCurrencyOrderListUseCase.h"
#import "WVRTableViewAdapter.h"
#import "WVRCurrencyOrderListModel.h"
#import "WVRCurrencyDetailItemViewModel.h"
#import "WVRCurrencyDetailTitleViewModel.h"

@interface WVRCurrencyDetailViewModel()

@property (nonatomic, strong) WVRCurrencyOrderListUseCase * gCurrencyOrderListUC;
@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@property (nonatomic, strong) NSMutableDictionary * gOriginDic;

@end

@implementation WVRCurrencyDetailViewModel
@synthesize isEmpty = _isEmpty;
@synthesize mCompleteSignal = _mCompleteSignal;
@synthesize mFailSignal = _mFailSignal;
@synthesize gTableViewAdapter = _gTableViewAdapter;

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

-(WVRTableViewAdapter *)gTableViewAdapter
{
    if(!_gTableViewAdapter){
        _gTableViewAdapter = [[WVRTableViewAdapter alloc] init];
    }
    return _gTableViewAdapter;
}

-(WVRCurrencyOrderListUseCase *)gCurrencyOrderListUC
{
    if (!_gCurrencyOrderListUC) {
        _gCurrencyOrderListUC = [[WVRCurrencyOrderListUseCase alloc] init];
    }
    return _gCurrencyOrderListUC;
}

-(NSMutableDictionary *)gOriginDic
{
    if(!_gOriginDic){
        _gOriginDic = [[NSMutableDictionary alloc] init];
    }
    return _gOriginDic;
}

- (void)setUpRAC {
    self.gCurrencyOrderListUC.page = 0;
    self.gCurrencyOrderListUC.size = 10000;
    @weakify(self);
    [[self.gCurrencyOrderListUC buildUseCase] subscribeNext:^(WVRCurrencyOrderListModel*  value) {
        @strongify(self);
        [self parserRespnose:value];
    }];
    [[self.gCurrencyOrderListUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x.errorMsg];
    }];
}

- (void)parserRespnose:(WVRCurrencyOrderListModel *)model {
    
    if (model.totalNum == 0 && model.priceAmount == 0) {
        
        _isEmpty = YES;
        
    } else {
        _isEmpty = NO;
        SQTableViewSectionInfo * sectionInfo = [[SQTableViewSectionInfo alloc] init];
        NSMutableArray * cellArray = [[NSMutableArray alloc] init];
        WVRCurrencyDetailTitleViewModel * titleViewM = [[WVRCurrencyDetailTitleViewModel alloc] init];
        titleViewM.totalNum = model.totalNum;
        titleViewM.whaleyCurrencyAmount = model.whaleyCurrencyAmount;
        titleViewM.priceAmount = model.priceAmount;
        [cellArray addObject:titleViewM];
        for (WVRCurrencyOrderListItem* item in model.orderListPageCache.content) {
            WVRCurrencyDetailItemViewModel * cellViewModel = [[WVRCurrencyDetailItemViewModel alloc] init];
            cellViewModel.orderItem = item;
            [cellArray addObject:cellViewModel];
        }
        sectionInfo.cellDataArray = cellArray;
        self.gOriginDic[@(0)] = sectionInfo;
        [self.gTableViewAdapter loadData:^NSDictionary *{
            return self.gOriginDic;
        }];
    }
    [self.gCompleteSubject sendNext:nil];
}

-(RACSignal *)mCompleteSignal
{
    if (!_mCompleteSignal) {
        @weakify(self);
        _mCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _mCompleteSignal;
}

-(RACSignal *)mFailSignal
{
    if (!_mFailSignal) {
        @weakify(self);
        _mFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gFailSubject = subscriber;
            return nil;
        }];
    }
    return _mFailSignal;
}

- (RACCommand*)getCurrencyOrderListCmd
{
    return [self.gCurrencyOrderListUC getRequestCmd];
}

@end

