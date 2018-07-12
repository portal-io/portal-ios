//
//  WVRFootballViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFootballViewModel.h"
#import "WVRHttpFootballList.h"
#import "WVRHttpFootballListModel.h"
#import "WVRSectionModel.h"
#import "WVRFootballUseCase.h"
#import "WVRErrorViewModel.h"
#import "WVRRecommendPageModel.h"

@interface WVRFootballViewModel ()

@property (nonatomic, copy) void(^successBlock)(NSDictionary<NSNumber*, WVRSectionModel*>*);
@property (nonatomic, copy) void(^failBlock)(NSString *);

@property (nonatomic, strong) WVRFootballUseCase * gFootballUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@property (nonatomic, strong) WVRSectionModel * gSectionModel;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;


@end


@implementation WVRFootballViewModel
@synthesize mCompleteSignal = _mCompleteSignal;
@synthesize mFailSignal = _mFailSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

-(WVRFootballUseCase *)gFootballUC
{
    if (!_gFootballUC) {
        _gFootballUC = [[WVRFootballUseCase alloc] init];
    }
    return _gFootballUC;
}


-(void)setUpRAC
{
    RAC(self.gFootballUC, code) = RACObserve(self, code);
    @weakify(self);
    [[self.gFootballUC buildUseCase] subscribeNext:^(WVRRecommendPageModel*  _Nullable x) {
        @strongify(self);
        for (NSNumber* key in x.sectionModels.allKeys) {
            WVRSectionModel* sectionModel = x.sectionModels[key];
            switch (sectionModel.sectionType) {
                case WVRSectionModelTypeBanner:
                    sectionModel.sectionType = WVRSectionModelTypeFootballBanner;
                    break;
                case WVRSectionModelTypeHot:
                    sectionModel.sectionType = WVRSectionModelTypeFootballLive;
                    break;
                case WVRSectionModelTypeDefault:
                    sectionModel.sectionType = WVRSectionModelTypeFootballRecord;
                    break;
                default:
                    break;
            }
        }

        [self.gCompleteSubject sendNext:x.sectionModels];
    }];
    [[self.gFootballUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
//        if ([x isKindOfClass:[WVRErrorViewModel class]]) {
//            [self.gFailSubject sendNext:x.errorMsg];
//        }else if([x isKindOfClass:[NSString class]]){
//            [self.gFailSubject sendNext:x];
//        }else{
            [self.gFailSubject sendNext:kNetError];
//        }
    }];
    
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

-(RACCommand*)getFootballCmd
{
    return [self.gFootballUC getRequestCmd];
}

//- (instancetype)initWithSuccessBlock:(void(^)(NSDictionary<NSNumber*, NSArray *>* resultDic))successBlock failBlock:(void(^)(NSString *errMsg))failBlock
//{
//    self = [super init];
//    if (self) {
//        self.successBlock = successBlock;
//        self.failBlock = failBlock;
//    }
//    return self;
//}
//
//- (void)http_footballListWithCode:(NSString *)code {
//    
//    kWeakSelf(self);
//    WVRHtttpRecommendPage  * cmd = [WVRHtttpRecommendPage new];
//    cmd.code = code;    // kHttpParams_RecommendPage_code_movie;
//    //    if (self.haveTV) {
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    params[kHttpParams_HaveTV] = @"1";
//    cmd.bodyParams = params;
//    //    }
//    cmd.successedBlock = ^(WVRHttpRecommendPageDetailParentModel* args) {
//        [weakself httpSuccessBlock:args];
//    };
//    
//    cmd.failedBlock = ^(id args) {
//        if ([args isKindOfClass:[NSString class]]) {
//            weakself.failBlock(args);
//        }
//    };
//    [cmd execute];
//}
//
//- (void)httpSuccessBlock:(WVRHttpRecommendPageDetailParentModel *)args {
//    NSMutableDictionary * dic = [NSMutableDictionary new];
//    NSArray * recommendAreas = [[args data] recommendAreas];
//    for (WVRHttpRecommendArea* recommendArea in recommendAreas) {
//        WVRSectionModel * sectionModel = [self parseSectionHttpModel:recommendArea];
//        switch (sectionModel.sectionType) {
//            case WVRSectionModelTypeBanner:
//                sectionModel.sectionType = WVRSectionModelTypeFootballBanner;
//                break;
//            case WVRSectionModelTypeHot:
//                sectionModel.sectionType = WVRSectionModelTypeFootballLive;
//                break;
//            case WVRSectionModelTypeDefault:
//                sectionModel.sectionType = WVRSectionModelTypeFootballRecord;
//                break;
//            default:
//                break;
//        }
//        dic[@([recommendAreas indexOfObject:recommendArea])] = sectionModel;
//
//    }
//    _gSctionDic = dic;
//    self.successBlock(_gSctionDic);
//}
//
//- (WVRSectionModel *)parseSectionHttpModel:(WVRHttpRecommendArea *)recommendArea {
//    
//    WVRSectionModel* sectionModel = [WVRSectionModel new];
//    WVRSectionModelType sectionType = [sectionModel parseSectionTypeWithHttpRecAreaType:recommendArea.type];
//    sectionModel.sectionType = sectionType;
//    
//    if (sectionType == WVRSectionModelTypeTag) {
//        sectionModel.itemModels = [self parseTagHttpRecommendArea:recommendArea];
//    } else if (sectionType == WVRSectionModelTypeHot ) {//后台填写hot和tag类型的元素都是文本格式的，这儿要兼容这个两个（实际应该填图片格式的）
//        sectionModel.itemModels = [self parseHotHttpRecommendArea:recommendArea sectionModel:sectionModel];
//    } else {
//        sectionModel.itemModels = [self parseDefaultHttpRecommendArea:recommendArea sectionModel:sectionModel];
//    }
//    return sectionModel;
//}
//
//- (NSMutableArray*)parseTagHttpRecommendArea:(WVRHttpRecommendArea *)recommendArea {
//    
//    NSMutableArray * models = [NSMutableArray array];
//    for (WVRHttpRecommendElement* element in [recommendArea recommendElements]) {
//        WVRItemModel * model = [self parseHttpPngElement:element];
//        if (model) {
//            [models addObject:model];
//        }
//    }
//    return models;
//}
//
//- (NSMutableArray*)parseHotHttpRecommendArea:(WVRHttpRecommendArea*)recommendArea sectionModel:(WVRSectionModel*)sectionModel {
//    
//    NSMutableArray * models = [NSMutableArray array];
//    WVRHttpRecommendElement* element = [[recommendArea recommendElements] firstObject];
//    if (element) {
//        [self parseHttpTextElement:element recommendArea:recommendArea sectionModel:sectionModel];
//    }
//    for (WVRHttpRecommendElement* element in [recommendArea recommendElements]) {
//        
//        WVRItemModel * model = [self parseHttpPngElement:element];
//        if (model) {
//            [models addObject:model];
//        }
//    }
//    return models;
//}
//
//- (NSMutableArray *)parseDefaultHttpRecommendArea:(WVRHttpRecommendArea *)recommendArea sectionModel:(WVRSectionModel *)sectionModel {
//    
//    NSMutableArray * models = [NSMutableArray array];
//    for (WVRHttpRecommendElement* element in [recommendArea recommendElements]) {
//        if ([element.type isEqualToString:@"1"]) {//是文本格式（头或尾）后台管理需要对应填入相应类型
//            [self parseHttpTextElement:element recommendArea:recommendArea sectionModel:sectionModel];
//        } else {
//            WVRItemModel * model = [self parseHttpPngElement:element];
//            if (model) {
//                [models addObject:model];
//            }
//        }
//    }
//    return models;
//}
//
//- (void)parseHttpTextElement:(WVRHttpRecommendElement *)element recommendArea:(WVRHttpRecommendArea *)recommendArea sectionModel:(WVRSectionModel *)sectionModel {
//    
//    if (element == [[recommendArea recommendElements] firstObject]) {
//        [self parseHttpTextHeader:element recommendArea:recommendArea sectionModel:sectionModel];
//    }
//    if (element == [[recommendArea recommendElements] lastObject]) {
//        if (element.linkArrangeValue.length > 0) {
//            WVRSectionModel* footModel = [self parseHttpTextFooter:element recommendArea:recommendArea sectionModel:sectionModel];
//            sectionModel.footerModel = footModel;
//        }
//    }
//}
//
//- (void)parseHttpTextHeader:(WVRHttpRecommendElement *)element recommendArea:(WVRHttpRecommendArea *)recommendArea sectionModel:(WVRSectionModel *)sectionModel {
//    
//    sectionModel.recommendAreaCode = [element.recommendAreaCodes firstObject];
//    
//    sectionModel.name = element.name;
//    sectionModel.subTitle = element.subtitle;
//    sectionModel.linkArrangeValue = element.linkArrangeValue;
//    sectionModel.linkArrangeType = element.linkArrangeType;
//    sectionModel.videoType = element.videoType;
//    sectionModel.type = sectionModel.type;
//    sectionModel.thubImageUrl = element.picUrlNew;
//    sectionModel.recommendPageType = element.recommendPageType;
//    sectionModel.recommendAreaCodes = element.recommendAreaCodes;
//}
//
//- (WVRSectionModel *)parseHttpTextFooter:(WVRHttpRecommendElement *)element recommendArea:(WVRHttpRecommendArea *)recommendArea sectionModel:(WVRSectionModel *)sectionModel {
//    
//    WVRSectionModel * footerModel = [WVRSectionModel new];
//    footerModel.recommendAreaCode = [element.recommendAreaCodes firstObject];
//    footerModel.name = element.name;
//    footerModel.subTitle = element.subtitle;
//    footerModel.linkArrangeValue = element.linkArrangeValue;
//    footerModel.linkArrangeType = element.linkArrangeType;
//    footerModel.videoType = element.videoType;
//    footerModel.type = sectionModel.type;
//    footerModel.thubImageUrl = element.picUrlNew;
//    footerModel.recommendPageType = element.recommendPageType;
//    footerModel.recommendAreaCodes = element.recommendAreaCodes;
//    
//    return footerModel;
//}
//
//- (WVRItemModel *)parseHttpPngElement:(WVRHttpRecommendElement *)element {
//    
//    WVRItemModel *itemModel = nil;
//    WVRFootballModel * curFootModel = [WVRFootballModel new];
//    curFootModel.liveStatus = element.liveStatus;
//    
//    curFootModel.liveOrderCount = element.liveOrderCount;
//    curFootModel.startDateFormat = element.liveBeginTime;
//    curFootModel.behavior = element.behavior;
//    curFootModel.displayMode = [element.displayMode integerValue];
//    itemModel= curFootModel;
////    }
//    itemModel.playUrl = element.videoUrl;
//    itemModel.code = element.code;
//    itemModel.name = element.name;
//    itemModel.subTitle = element.subtitle;
//    itemModel.thubImageUrl = element.picUrlNew;
//    itemModel.intrDesc = element.introduction;
//    itemModel.linkArrangeValue = element.linkArrangeValue;
//    itemModel.linkArrangeType = element.linkArrangeType;
//    itemModel.unitConut = element.detailCount;
//    itemModel.logoImageUrl = element.logoImageUrl;
//    itemModel.infUrl = element.infUrl;
//    itemModel.infTitle = element.infTitle;
//    itemModel.price = element.price;
//    itemModel.isChargeable = element.isChargeable;
//    itemModel.recommendPageType = element.recommendPageType;
//    itemModel.videoType = element.videoType;
//    itemModel.programType = element.programType;
//    itemModel.recommendAreaCodes = element.recommendAreaCodes;
//    itemModel.arrangeShowFlag = element.arrangeShowFlag;
//    itemModel.duration = element.duration;
//    itemModel.contentType = element.contentType;
//    
//    itemModel.renderType = element.renderType;
//    
//    itemModel.srcDisplayName = element.statQueryDto.srcDisplayName;
//    if (itemModel.duration.length == 0) {
//        itemModel.duration = element.programPlayTime;
//    }
//    itemModel.type = element.type;
//    
//    itemModel.playCount = element.statQueryDto.playCount;
//    
//    return itemModel;
//}

@end
