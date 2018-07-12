//
//  WVRProgramPackageModel.h
//  WhaleyVR
//
//  Created by qbshen on 17/4/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRItemModel.h"
#import "WVRContentPackageQueryDto.h"
//#import "WVRPayGoodsType.h"

@interface WVRProgramPackageModel : WVRItemModel

@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSString * currency;

// "type": //包类型(1:支持单个收费和包收费；0：包独立收费)

//@property (nonatomic, copy) NSString  *type;      // 此属性已经存在于父类

- (NSInteger)packageType;

@end
