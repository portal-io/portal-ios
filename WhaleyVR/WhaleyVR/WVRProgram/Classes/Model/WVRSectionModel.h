//
//  WVRSectionModel.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRItemModel.h"
#import "WVRLiveItemModel.h"
#import "WVRProgramPackageModel.h"

@interface WVRSectionModel : WVRItemModel

@property (nonatomic) NSString * itemCount;

/// 标记手动编排是否为活动类型 bizType="ACTIVITY"
@property (nonatomic, assign) BOOL isActivity;

@property (nonatomic) WVRSectionModelType  sectionType;

@property (nonatomic) NSMutableArray<WVRItemModel *> *itemModels;

@property (nonatomic) NSMutableDictionary * itemModelDic;
@property (nonatomic) NSMutableArray * itemModelDicKeys;

@property (nonatomic) long totalPages;
@property (nonatomic) long pageNum;
@property (nonatomic) long pageSize;

@property (nonatomic, strong) NSString * formatDateKey;

@property (nonatomic) WVRSectionModel* footerModel;

@property (nonatomic, strong) WVRProgramPackageModel * packModel;

/// 节目包所有节目已付费则为 "0"
@property (nonatomic, copy) NSString *discountPrice;

/// 节目包或者其中所有节目已付费则为 true
- (BOOL)programPackageHaveCharged;

@end
