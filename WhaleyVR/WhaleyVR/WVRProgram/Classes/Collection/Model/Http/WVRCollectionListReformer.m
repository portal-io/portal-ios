//
//  WVRCollectionListReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCollectionListReformer.h"
#import "WVRHttpCollectionListModel.h"
#import "WVRCollectionModel.h"

@implementation WVRCollectionListReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (NSArray<WVRCollectionModel*>*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpCollectionListModel * model = [WVRHttpCollectionListModel yy_modelWithDictionary:businessDictionary];
    
    return [self parserModel:model];
}


-(NSArray<WVRCollectionModel*>*)parserModel:(WVRHttpCollectionListModel*)args
{
//    WVRCollectionVCModel * vcModel = [WVRCollectionVCModel new];
    NSMutableArray* collections = [NSMutableArray array];
    for (WVRHttpCollectionModel* cur in args.content) {
        WVRCollectionModel * model = [WVRCollectionModel new];
        model.userName = cur.userName;
        model.programCode = cur.programCode;
        model.programName = cur.programName;
        model.programType = cur.programType;
        model.duration = cur.duration;
        model.status = cur.status;
        model.videoType = cur.videoType;
        model.thubImageUrl = cur.picUrl;
        [collections addObject:model];
    }
    return collections;
}
@end
