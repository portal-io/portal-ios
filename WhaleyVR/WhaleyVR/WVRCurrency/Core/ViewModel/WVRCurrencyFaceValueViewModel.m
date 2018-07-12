//
//  WVRCurrencyFaceValueViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyFaceValueViewModel.h"
#import "WVRCurrencyBuyConfigListUseCase.h"
#import "WVRTableViewAdapter.h"
#import "WVRCurrencyBuyConfigListModel.h"
#import "WVRCurrencyFaceValueCellViewModel.h"
#import "WVRCurrencyBalanceFootViewModel.h"
#import "WVRMediator+PayActions.h"
#import "WVRMediator+Currency.h"

@interface WVRCurrencyFaceValueViewModel()

@property (nonatomic, strong) WVRCurrencyBuyConfigListUseCase * gCurrencyByConfigLUC;
@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@property (nonatomic, strong) NSMutableDictionary * gOriginDic;

@property (nonatomic, assign) BOOL gIsPaying;

@end

@implementation WVRCurrencyFaceValueViewModel

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

-(WVRCurrencyBuyConfigListUseCase *)gCurrencyByConfigLUC
{
    if (!_gCurrencyByConfigLUC) {
        _gCurrencyByConfigLUC = [[WVRCurrencyBuyConfigListUseCase alloc] init];
    }
    return _gCurrencyByConfigLUC;
}

-(NSMutableDictionary *)gOriginDic
{
    if(!_gOriginDic){
        _gOriginDic = [[NSMutableDictionary alloc] init];
    }
    return _gOriginDic;
}

-(void)setUpRAC
{
    @weakify(self);
    [[self.gCurrencyByConfigLUC buildUseCase] subscribeNext:^(WVRCurrencyBuyConfigListModel*  value) {
        @strongify(self);
        [self parserRespnose:value];
//        NSInteger code = [value.content[@"code"] integerValue];
//        NSString *msg = value.content[@"msg"];
//        if (200 == code){
//            [self.gCompleteSubject sendNext:value];
//        }else{
//            [self.gFailSubject sendNext:msg];
//        }
    }];
    [[self.gCurrencyByConfigLUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x.errorMsg];
        
    }];
    
}

-(void)parserRespnose:(WVRCurrencyBuyConfigListModel*)model
{
    SQTableViewSectionInfo * sectionInfo = [[SQTableViewSectionInfo alloc] init];
    sectionInfo.footViewInfo = [self getFootViewModel];
    NSMutableArray * cellArray = [[NSMutableArray alloc] init];
    @weakify(self);
    for (WVRCurrencyBuyConfigItemModel* item in model.list) {
        WVRCurrencyFaceValueCellViewModel * cellViewModel = [[WVRCurrencyFaceValueCellViewModel alloc] init];
        cellViewModel.configModel = item;
        cellViewModel.gotoNextBlock = ^(id args) {
            @strongify(self);
            [self startPayWCurrency:item];
        };
        [cellArray addObject:cellViewModel];
    }
    sectionInfo.cellDataArray = cellArray;
    self.gOriginDic[@(0)] = sectionInfo;
    [self.gTableViewAdapter loadData:^NSDictionary *{
        return self.gOriginDic;
    }];
    [self.gCompleteSubject sendNext:nil];
}

-(WVRCurrencyBalanceFootViewModel*)getFootViewModel
{
    WVRCurrencyBalanceFootViewModel * vm = [[WVRCurrencyBalanceFootViewModel alloc] init];
    @weakify(self);
    vm.gotoNextBlock = ^(id args) {
        @strongify(self);
        [self.gGotoWCDescrCmd execute:nil];
    };
    return vm;
}

- (void)startPayWCurrency:(WVRCurrencyBuyConfigItemModel *)model
{
    if (self.gIsPaying) {
        SQToastInKeyWindow(@"正在获取支付结果...");
        return;
    }
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            NSInteger payResult = [input[@"success"] integerValue];
            if (payResult == 1) {
                [[WVRMediator sharedInstance] WVRMediator_GetUserWCBalance];
            } else if (payResult == 3) {
                
            }
            self.gIsPaying = NO;
            return nil;
        }];
    }];
    NSInteger price = model.preferPrice > 0 ? model.preferPrice : model.price;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"goodsCode"] = model.code;
    params[@"goodsPrice"] = @(price);
    params[@"originPrice"] = @(model.price);
    params[@"preferPrice"] = @(model.preferPrice);
    params[@"giveWCurrency"] = @(model.whaleyCurrencyGiveNumber);
    params[@"goodsName"] = [NSString stringWithFormat:@"%ld鲸币充值", (long)model.whaleyCurrencyNumber];
    params[@"cmd"] = cmd;
    self.gIsPaying = YES;
    [[WVRMediator sharedInstance] WVRMediator_PayForWCurrency:params];
}

- (RACSignal *)mCompleteSignal
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

-(RACCommand*)getCurrencyBuyConfigLCmd
{
    return [self.gCurrencyByConfigLUC getRequestCmd];
}
@end
