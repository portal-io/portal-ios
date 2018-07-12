//
//  WVRRewardReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRewardReformer.h"
#import "WVRAddressModel.h"
#import "WVRRewardModel.h"
#import "WVRRewardVCModel.h"
#import "SQDateTool.h"

@implementation WVRRewardReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (WVRRewardVCModel*)reformData:(NSDictionary *)data {
//    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpRewardListModel * model = [WVRHttpRewardListModel yy_modelWithDictionary:data];
    
    return [self parseModel:model];
}

-(WVRRewardVCModel*)parseModel:(WVRHttpRewardListModel*)args
{
    WVRRewardVCModel * vcModel = [[WVRRewardVCModel alloc] init];
    //        args.prizesdata = [vcModel revokeData];
     vcModel.addressModel = [[WVRAddressModel alloc] initWithHttpModel:args.addressdata];
    
    if (args.prizesdata.count==0) {
        
    }else{
        NSArray<WVRRewardSectionModel*>* sectionModels = [self parseRewardList:args.prizesdata];
        vcModel.sectionRewards = sectionModels;
    }
    return vcModel;
}

- (NSArray<WVRRewardSectionModel *> *)parseRewardList:(NSArray<WVRHttpRewardModel *> *)list
{
    NSMutableArray * rewardSections = [NSMutableArray array];
    //    list = [list sortedArrayUsingComparator:^NSComparisonResult(WVRHttpRewardModel*  _Nonnull obj1, WVRHttpRewardModel*  _Nonnull obj2) {
    //        if (obj1.dateline.doubleValue > obj2.dateline.doubleValue) {
    //            return NSOrderedDescending;
    //        }else{
    //            return NSOrderedAscending;
    //        }
    //    }];
    NSMutableArray * resultList = [NSMutableArray array];
    NSMutableArray * rewardTimekeys = [NSMutableArray array];
    for (WVRHttpRewardModel* cur in list) {
        WVRRewardModel * model = [WVRRewardModel new];
        model.title = cur.name;
        model.formatDateStr = [SQDateTool month_day_hour_minute:[cur.dateline doubleValue]*1000 withFormatStr:@"MM月dd日 HH:mm"];
        model.formatDateKey = [SQDateTool month:[cur.dateline doubleValue]*1000];
        model.thubImageStr = cur.picture;
        model.rewardType = [cur.goodstype integerValue];
        model.rewardInfo = cur.info;
        
        [resultList addObject:model];
        if (![rewardTimekeys containsObject:model.formatDateKey]) {
            [rewardTimekeys addObject:model.formatDateKey];
        }
    }
    
    for (NSString * key in rewardTimekeys) {
        WVRRewardSectionModel * sectionModel = [WVRRewardSectionModel new];
        NSMutableArray * rewards = [NSMutableArray array];
        sectionModel.formatDateKey = key;
        for (WVRRewardModel* model in resultList) {
            if ([model.formatDateKey isEqualToString:key]) {
                [rewards addObject:model];
            }
        }
        sectionModel.rewards = rewards;
        [rewardSections addObject:sectionModel];
    }
    return rewardSections;
}

@end
@implementation WVRHttpRewardListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"prizesdata" : WVRHttpRewardModel.class};
}
@end
