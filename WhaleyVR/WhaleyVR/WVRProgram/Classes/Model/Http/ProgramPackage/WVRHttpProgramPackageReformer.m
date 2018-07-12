//
//  WVRHttpAllChannelReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpProgramPackageReformer.h"
#import "WVRHttpRecommendPageDetailModel.h"
#import "WVRItemModel.h"
#import "WVRProgramPackageModel.h"
#import "WVRSectionModel.h"

@implementation WVRHttpProgramPackageReformer

#pragma mark - WVRAPIManagerDataReformer protocol

- (WVRSectionModel *)reformData:(NSDictionary *)data {
    
    NSDictionary *dataDic = [super reformData:data];
    NSDictionary * packDic = [dataDic valueForKey:@"pack"];
    
    WVRProgramPackageModel * packModel = [WVRProgramPackageModel new];
    packModel.name = [packDic valueForKey:@"displayName"];
    packModel.code = [packDic valueForKey:@"code"];
    packModel.intrDesc = [packDic valueForKey:@"description"];
    packModel.liveStatus = [[packDic valueForKey:@"status"] integerValue];
    packModel.price = [[packDic valueForKey:@"price"] integerValue];
    packModel.isChargeable = [[packDic valueForKey:@"isChargeable"] intValue];
    packModel.totalCount = packDic[@"totalCount"];
    packModel.currency = packDic[@"currency"];
    packModel.thubImageUrl = packDic[@"pic"];
    packModel.type = [NSString stringWithFormat:@"%@", packDic[@"type"]];
    
    NSMutableArray * itemModels = [NSMutableArray new];
    NSDictionary * itemsDic = [dataDic valueForKey:@"items"];
    NSArray * contents = [itemsDic valueForKey:@"content"];
    for (NSDictionary * dic in contents) {
        WVRItemModel * itemModel = nil;
        if ([itemModel.programType isEqualToString:PROGRAMTYPE_LIVE]) {
            itemModel = [WVRLiveItemModel new];
            [(WVRLiveItemModel*)itemModel setDisplayMode:[dic[@"displayMode"] integerValue]];
        }else{
            itemModel = [WVRItemModel new];
        }
        itemModel.name = dic[@"displayName"];
        itemModel.thubImageUrl = dic[@"pic"];
        itemModel.code = dic[@"contentCode"];
        itemModel.linkArrangeValue = itemModel.code;
        itemModel.playCount = dic[@"playCount"];
        itemModel.duration = dic[@"duration"];
        itemModel.programType = dic[@"contentType"];
        itemModel.contentType = dic[@"contentType"];
        itemModel.liveStatus = [dic[@"liveStatus"] integerValue];
        
        [itemModels addObject:itemModel];
    }
    
    WVRSectionModel* sectionModel = [WVRSectionModel new];
    sectionModel.name = packModel.name;
    sectionModel.linkArrangeValue = packModel.code;
    sectionModel.subTitle = packModel.intrDesc;
    sectionModel.intrDesc = packModel.intrDesc;
    sectionModel.thubImageUrl = packModel.thubImageUrl;
    sectionModel.itemCount = packModel.totalCount;
    sectionModel.packModel = packModel;
    sectionModel.itemModels = itemModels;
    sectionModel.isChargeable = packModel.isChargeable;
    sectionModel.discountPrice = packDic[@"discountPrice"];
    
    NSDictionary *dtoDic = packDic[@"couponDto"];
    sectionModel.packModel.couponDto = [WVRCouponDto yy_modelWithDictionary:dtoDic];
    
    return sectionModel;
}

@end
