//
//  WVRRecommendFollowModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 推荐关注

#import "WVRRecommendFollowModel.h"
#import "WVRWhaleyHTTPManager.h"
#import "WVRHttpArrangeElementsPageModel.h"

@implementation WVRRecommendFollowModel

+ (void)requestForRecommendFollowList:(void (^)(WVRRecommendFollowModel * model, NSError *error))block {
    
    NSString *uid = [WVRUserModel sharedInstance].accountId;
    
    NSString *apiName = [NSString stringWithFormat:@"recommendPage/findPageByCode/tuijian_guanzhu/ios/%@", [WVRUserModel kAPI_VERSION]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kAPI_SERVICE, apiName];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid.length > 0) { params[@"uid"] = uid; }
    
    [WVRWhaleyHTTPManager GETService:urlStr withParams:params completionBlock:^(id responseObj, NSError *error) {
        NSDictionary *dic = responseObj;
        int code = [dic[@"code"] intValue];
        NSString *msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
        NSDictionary *resDict = dic[@"data"];
        NSMutableArray *areaArr = [resDict[@"recommendAreas"] mutableCopy];
        
        if (!error && code == 200) {

            WVRRecommendFollowModel *dataModel = [[WVRRecommendFollowModel alloc] init];

            NSMutableArray *dataArr = [NSMutableArray array];

            NSDictionary *header = [areaArr firstObject];
            NSDictionary *headerItem = [header[@"recommendElements"] firstObject];

            WVRRecommendFollowItemModel *hModel = [WVRRecommendFollowItemModel yy_modelWithDictionary:headerItem];

            dataModel.headerModel = hModel;

            if (areaArr.count > 1) {

                NSDictionary *itemsDict = [areaArr lastObject];
                
                NSArray *items = itemsDict[@"recommendElements"];
                for (NSDictionary *itemDic in items) {
                    WVRRecommendFollowItemModel *model = [WVRRecommendFollowItemModel yy_modelWithDictionary:itemDic];
                    
                    [dataArr addObject:model];
                }
            }
            dataModel.listArray = dataArr;
            
            block(dataModel, nil);
        } else {
            if (error) {
                block(nil, error);
            } else {
                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
                block(nil, err);
            }
        }
    }];
}

@end


@implementation WVRRecommendFollowItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"picUrl_" : @"newPicUrl" };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"cpProgramDtos" : [WVRPublisherListItemModel class], };
}

@end

