//
//  WVRCollectionModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSetViewModel.h"
#import "WVRBaseViewSection.h"
#import "WVRHttpRPageElements.h"
#import "WVRHttpRPageElementsReformer.h"
#import <ReactiveObjC.h>

@interface WVRSetViewModel ()<WVRAPIManagerDataSource>

@property (nonatomic, assign) NSInteger gPageSize;
@property (nonatomic, assign) NSInteger gPageNum;
@property (nonatomic, assign) NSInteger gTotalPages;
@property (nonatomic, strong) NSMutableArray * gCurItems;

@property (nonatomic, strong) WVRHttpRPageElements * gHttpPageElements;

@end


@implementation WVRSetViewModel
//@synthesize title = _title;
@synthesize gDelegate = _gDelegate;
@synthesize gOriginDic = _gOriginDic;
@synthesize haveMore = _haveMore;
@synthesize isMore = _isMore;

- (instancetype)init {
    self = [super init];
    if (self) {
        _haveMore = YES;
        self.gPageSize = 18;
        self.gPageNum = 0;
        [self setupRAC];
    }
    return self;
}

- (SQCollectionViewDelegate *)gDelegate
{
    if (!_gDelegate) {
        _gDelegate = [[SQCollectionViewDelegate alloc] init];
    }
    return _gDelegate;
}

- (WVRHttpRPageElements *)gHttpPageElements {
    if (_gHttpPageElements == nil) {
        _gHttpPageElements = [[WVRHttpRPageElements alloc] init];
        _gHttpPageElements.dataSource = self;
    }
    return _gHttpPageElements;
}

- (void)setupRAC
{
    @weakify(self);
    [self.gHttpPageElements.executionSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self successBlock];
    }];
    [self.gHttpPageElements.requestErrorSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        @strongify(self);
        [self failBlock];
    }];
}

- (RACCommand *)refreshCmd {
    _haveMore=YES;
    _isMore = NO;
    self.gPageNum = 0;
    
    return self.gHttpPageElements.requestCmd;
}

- (RACCommand *)moreCmd {
    _isMore = YES;
    self.gPageNum ++;
    
    return self.gHttpPageElements.requestCmd;
}

// WVRAPIManagerDataSource delegate
- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.gHttpPageElements) {
        params = @{
                   kHttpParams_RPageElements_code:self.code,
                   kHttpParams_RPageElements_subCode:self.subCode,
                   @"pageSize":@(self.gPageSize),
                   @"pageNum":@(self.gPageNum)
                   };
    }
    return params;
}

- (void)successBlock
{
    WVRSectionModel* sectionModel = [self.gHttpPageElements fetchDataWithReformer:[[WVRHttpRPageElementsReformer alloc] init]];
    sectionModel.sectionType = WVRSectionModelTypeSet;
    self.gTotalPages = sectionModel.totalPages;
    if (self.gPageNum == self.gTotalPages-1) {
        _haveMore = NO;
    }
    if (self.isMore) {
        if (sectionModel.itemModels.count==0&&self.gOriginDic.count==0) {
            if (self.gPageNum == self.gTotalPages-1) {
                _haveMore = NO;
            }
            [self.gDelegate loadData:nil];
            self.gOriginDic = nil;
            return;
        }else{
            [self appendItems:sectionModel.itemModels];
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            dic[@(0)] = self.gOriginDic[@(0)];
            [self.gDelegate loadData:dic];
            self.gOriginDic = dic;
        }
    }else{
        if (sectionModel.itemModels.count==0) {
            
        }
        NSMutableDictionary * dic = [NSMutableDictionary new];
        dic[@(0)] = [self sectionInfo:sectionModel];
        [self.gDelegate loadData:dic];
        self.gOriginDic = dic;
    }
}

- (void)failBlock
{
    self.gError = [[WVRError alloc] init];
}

- (WVRBaseViewSection *)sectionInfo:(WVRSectionModel *)sectionModel {
    
    //    NSLog(@"recommendAreaType:%ld", (long)sectionModel.sectionType);
    WVRBaseViewSection * sectionInfo = nil;
    NSInteger type = sectionModel.sectionType;
    sectionInfo = [WVRViewModelDispatcher dispatchSection:[NSString stringWithFormat:@"%d", (int)type] args:sectionModel];//[self getADSectionInfo:sectionModel type:type];
    
    return sectionInfo;
}

- (void)appendItems:(NSArray *)itemModels
{
    WVRBaseViewSection * sectionInfo = self.gOriginDic[@(0)];
    [sectionInfo moreItems:itemModels];
}

@end
