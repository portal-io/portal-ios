//
//  WVRHttpFootballListReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpFootballListReformer.h"
#import "WVRHttpFootballListModel.h"

@implementation WVRHttpFootballListReformer
- (WVRHttpFootballListModel*)reformData:(NSDictionary *)data {
    NSDictionary * contentDic = data[@"Data"];
    WVRHttpFootballListModel * listModel = [WVRHttpFootballListModel yy_modelWithDictionary:contentDic];
        
    return listModel;
}

@end
