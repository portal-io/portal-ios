//
//  WVRLiveReserveModel.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLiveNoticeViewModel.h"
#import "WVRLiveNoticeUseCase.h"
//#import "WVRHttpLiveList.h"
#import "SQDateTool.h"
//#import "WVRHttpLiveOrder.h"
//#import "WVRHttpLiveOrderList.h"

@interface WVRLiveNoticeViewModel()

@property (nonatomic, strong) WVRLiveNoticeUseCase * gLiveNoticeUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@property (nonatomic, strong) RACSubject * gAddCompleteSubject;
@property (nonatomic, strong) RACSubject * gAddFailSubject;

@property (nonatomic, strong) RACSubject * gCancleCompleteSubject;
@property (nonatomic, strong) RACSubject * gCancleFailSubject;

@end


@implementation WVRLiveNoticeViewModel
@synthesize mCompleteSignal = _mCompleteSignal;
@synthesize mFailSignal = _mFailSignal;
@synthesize gAddCompleteSignal = _gAddCompleteSignal;
@synthesize gAddFailSignal = _gAddFailSignal;
@synthesize gCancleCompleteSignal = _gCancleCompleteSignal;
@synthesize gCancleFailSignal = _gCancleFailSignal;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

- (WVRLiveNoticeUseCase *)gLiveNoticeUC
{
    if (!_gLiveNoticeUC) {
        _gLiveNoticeUC = [[WVRLiveNoticeUseCase alloc] init];
    }
    return _gLiveNoticeUC;
}


- (void)setUpRAC
{
    [self.gLiveNoticeUC getRequestCmd].allowsConcurrentExecution = YES;
    RAC(self.gLiveNoticeUC,code) = RACObserve(self, code);
    RAC(self.gLiveNoticeUC,action) = RACObserve(self, action);
    @weakify(self);
    [[self.gLiveNoticeUC buildUseCase] subscribeNext:^(NSArray<WVRItemModel*>*  _Nullable x) {
        @strongify(self);
        if ([self.action isEqualToString:@"list"]) {
            [self.gCompleteSubject sendNext:x];
        } else if ([self.action isEqualToString:@"add"]) {
            [self.gAddCompleteSubject sendNext:x];
        } else if ([self.action isEqualToString:@"cancel"]) {
            [self.gCancleCompleteSubject sendNext:x];
        }
        
    }];
    [[self.gLiveNoticeUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        
        if ([self.action isEqualToString:@"list"]) {
            [self.gFailSubject sendNext:x.errorMsg];
        }else if ([self.action isEqualToString:@"add"]){
            [self.gAddFailSubject sendNext:x.errorMsg];
        }else if ([self.action isEqualToString:@"cancel"]){
            [self.gCancleFailSubject sendNext:x.errorMsg];
        }
    }];
    
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

- (RACSignal *)mFailSignal
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

- (RACSignal *)gAddCompleteSignal
{
    if (!_gAddCompleteSignal) {
        @weakify(self);
        _gAddCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gAddCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _gAddCompleteSignal;
}

- (RACSignal *)gAddFailSignal
{
    if (!_gAddFailSignal) {
        @weakify(self);
        _gAddFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gAddFailSubject = subscriber;
            return nil;
        }];
    }
    return _gAddFailSignal;
}

- (RACSignal *)gCancleCompleteSignal
{
    if (!_gCancleCompleteSignal) {
        @weakify(self);
        _gCancleCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCancleCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _gCancleCompleteSignal;
}

- (RACSignal *)gCancleFailSignal
{
    if (!_gCancleFailSignal) {
        @weakify(self);
        _gCancleFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCancleFailSubject = subscriber;
            return nil;
        }];
    }
    return _gCancleFailSignal;
}

- (RACCommand *)getLiveNoticeListCmd
{
    self.action = @"list";
    return [self.gLiveNoticeUC getRequestCmd];
}

- (RACCommand *)getLiveNoticeaddCmd
{
    self.action = @"add";
    return [self.gLiveNoticeUC getRequestCmd];
}

- (RACCommand *)getLiveNoticecancelCmd
{
    self.action = @"cancel";
    return [self.gLiveNoticeUC getRequestCmd];
}


//- (void)http_liveOrder_listSuccessBlock:(void(^)(NSArray*))successBlock failBlock:(void(^)(NSString*))failBlock
//{
//    WVRHttpLiveOrderList *cmd = [[WVRHttpLiveOrderList alloc] init];
//    kWeakSelf(self);
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    params[kHttpParams_liveOrderList_uid] = [WVRUserModel sharedInstance].accountId;
//    params[kHttpParams_liveOrderList_token] = [WVRUserModel sharedInstance].sessionId;
//    params[kHttpParams_liveOrderList_device_id] = [WVRUserModel sharedInstance].deviceId;
//    cmd.bodyParams = params;
//    cmd.successedBlock = ^(WVRHttpLiveOrderListModel *data) {
//        [weakself httpLiveOrderListSuccessBlock:data successBlock:^(NSArray *args) {
//            successBlock(args);
//        }];
//    };
//    cmd.failedBlock = ^(NSString* errMsg) {
//        NSLog(@"fail msg: %@",errMsg);
//        failBlock(errMsg);
//    };
//    [cmd execute];
//}
//
//- (void)httpLiveOrderListSuccessBlock:(WVRHttpLiveOrderListModel *)args successBlock:(void(^)(NSArray *))successBlock
//{
//    NSMutableArray * originArray = [NSMutableArray array];
//    for (WVRHttpLiveDetailModel* item in args.data) {
//        WVRSQLiveItemModel * itemModel = [self parseLiveDetail:item];
//        itemModel.thubImageUrl = item.poster;
//        if (itemModel.liveStatus != WVRLiveStatusNotStart) {
//            continue;
//        }
//        [originArray addObject:itemModel];
//    }
//    successBlock(originArray);
//}
//
//+ (void)http_liveOrder:(BOOL)isAdd itemId:(NSString *)itemId successBlock:(void(^)())successBlock failBlock:(void(^)(NSString *err))failBlock {
//    
//    WVRHttpLiveOrder *cmd = [[WVRHttpLiveOrder alloc] initIsadd:isAdd];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[kHttpParams_liveOrder_uid] = [WVRUserModel sharedInstance].accountId;
//    params[kHttpParams_liveOrder_token] = [WVRUserModel sharedInstance].sessionId;
//    params[kHttpParams_liveOrder_device_id] = [WVRUserModel sharedInstance].deviceId;
//    params[kHttpParams_liveOrder_code] = itemId;
//    cmd.bodyParams = params;
//    
//    cmd.successedBlock = ^(WVRHttpLiveListParentModel* args) {
//        successBlock();
//    };
//    
//    cmd.failedBlock = ^(id args) {
//        if ([args isKindOfClass:[NSString class]]) {
//            failBlock(args);
//        }
//    };
//    
//    [cmd execute];
//}
//
////临时在直播未开始的直播详情界面获取已预约列表，以筛选此直播是否已预约
//- (void)http_liveOrderForLiveDetailCheckReserve_listSuccessBlock:(void(^)(NSArray *))successBlock failBlock:(void(^)(NSString *))failBlock
//{
//    WVRHttpLiveOrderList * cmd = [[WVRHttpLiveOrderList alloc] init];
//    kWeakSelf(self);
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    params[kHttpParams_liveOrderList_uid] = [WVRUserModel sharedInstance].accountId;
//    params[kHttpParams_liveOrderList_token] = [WVRUserModel sharedInstance].sessionId;
//    params[kHttpParams_liveOrderList_device_id] = [WVRUserModel sharedInstance].deviceId;
//    cmd.bodyParams = params;
//    cmd.successedBlock = ^(WVRHttpLiveOrderListModel *data) {
//        [weakself httpLiveOrderListForLiveDetailCheckReserveSuccessBlock:data successBlock:^(NSArray *args) {
//            successBlock(args);
//        }];
//    };
//    cmd.failedBlock = ^(NSString *errMsg) {
//        NSLog(@"fail msg: %@", errMsg);
//        failBlock(errMsg);
//    };
//    [cmd execute];
//}
//
//- (void)httpLiveOrderListForLiveDetailCheckReserveSuccessBlock:(WVRHttpLiveOrderListModel *)args successBlock:(void(^)(NSArray *))successBlock
//{
//    NSMutableArray * originArray = [NSMutableArray array];
//    for (WVRHttpLiveDetailModel* item in args.data) {
//        WVRSQLiveItemModel * itemModel = [self parseLiveDetail:item];
//        itemModel.thubImageUrl = item.poster;
//        if (itemModel.liveStatus != WVRLiveStatusNotStart) {
//            continue;
//        }
//        if ([itemModel.hasOrder intValue] != 1) {
//            continue;
//        }
//        [originArray addObject:itemModel];
//    }
//    successBlock(originArray);
//}

@end


@implementation WVRLReSectionModel

@end


@implementation WVRLiveReserveDayInfo

@end
