//
//  WVRSQFindMoreBrandModel.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBrandZoneVCModel.h"
#import "WVRApiHttpRecommendPageElements.h"
#import "WVRHttpRecommendPaginationContentModel.h"

#define SQStrWithNSInteger(NUM) ([NSString stringWithFormat:@"%ld", (NUM)])

@interface WVRBrandZoneVCModel ()

@end


@implementation WVRBrandZoneVCModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionModel = [WVRSectionModel new];
        self.sectionModel.pageSize = 18;
        self.sectionModel.pageNum = 0;
    }
    return self;
}

-(void)http_recommendPageWithCode:(NSString*)code successBlock:(void(^)(WVRSectionModel*))successBlock failBlock:(void(^)(NSString*))failBlock
{
    kWeakSelf(self);
    WVRApiHttpRecommendPageElements * cmd = [[WVRApiHttpRecommendPageElements alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    
    httpDic[kHttpParams_RecommendPageElements_code] = @"pinpaizhuanqu";
    httpDic[kHttpParams_RecommendPageElements_subCode] = @"brand_list";
//    httpDic[kHTTPPageSize]= = SQStrWithNSInteger(self.sectionModel.pageNum = 0);
//    cmd.pageSize = SQStrWithNSInteger(self.sectionModel.pageSize); //[NSString stringWithFormat:@"%d",++
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpRecommendPaginationContentModel * data){
        [weakself httpSuccessBlock:data successBlock:^(WVRSectionModel *args) {
            successBlock(args);
        } isMore:NO];
    };
    cmd.failedBlock = ^(NSString* errMsg) {
        NSLog(@"fail msg: %@",errMsg);
        
    };
    [cmd loadData];
}

-(void)http_recommendPageMoreWithCode:(NSString*)code successBlock:(void(^)(WVRSectionModel*))successBlock failBlock:(void(^)(NSString*))failBlock
{
    kWeakSelf(self);
    WVRApiHttpRecommendPageElements * cmd = [[WVRApiHttpRecommendPageElements alloc] init];
        NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_RecommendPageElements_code] = @"pinpaizhuanqu";
    httpDic[kHttpParams_RecommendPageElements_subCode] = @"brand_list";
//    cmd.pageNum = SQStrWithNSInteger(++self.sectionModel.pageNum);
//    cmd.pageSize = SQStrWithNSInteger(self.sectionModel.pageSize); //[NSString stringWithFormat:@"%d",++
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    params[@"v"] = @"1";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpRecommendPaginationContentModel * data){
        [weakself httpSuccessBlock:data successBlock:^(WVRSectionModel *args) {
            successBlock(args);
        } isMore:YES];
    };
    cmd.failedBlock = ^(NSString* errMsg){
        NSLog(@"fail msg: %@",errMsg);
        
    };
    [cmd loadData];
}


-(void)httpSuccessBlock:(WVRHttpRecommendPaginationContentModel* )args successBlock:(void(^)(WVRSectionModel*))successBlock isMore:(BOOL)isMore
{
    self.sectionModel.totalPages = [args.totalPages integerValue];
    NSMutableArray * itemModels = [NSMutableArray new];
    NSArray * recommendAreas = [args  content];
    for (WVRHttpRecommendElement* element in recommendAreas) {
        WVRItemModel * model = [WVRItemModel new];
        model.code = element.code;
        model.name = element.name;
        model.thubImageUrl = element.picUrlNew;
        model.subTitle = element.subtitle;
        model.intrDesc = element.introduction;
        model.unitConut = element.detailCount;
        model.logoImageUrl = element.logoImageUrl;
        model.linkArrangeValue= element.linkArrangeValue;
        model.linkArrangeType= element.linkArrangeType;
        model.videoType = element.videoType;
        model.programType = element.programType;
        [itemModels addObject:model];
    }
    if (isMore) {
        if (!self.sectionModel.itemModels) {
            self.sectionModel.itemModels = [NSMutableArray new];
        }
        [self.sectionModel.itemModels addObjectsFromArray:itemModels];
    }else{
        self.sectionModel.itemModels = itemModels;
    }
    successBlock(self.sectionModel);
}
@end
