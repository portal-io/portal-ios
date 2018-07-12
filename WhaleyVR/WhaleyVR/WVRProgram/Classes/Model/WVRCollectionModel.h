//
//  WVRCollectionModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseModel.h"

@interface WVRCollectionModel : WVRBaseModel

@property (nonatomic) NSString * userLoginId;
@property (nonatomic) NSString * userName;
@property (nonatomic) NSString * programName;
@property (nonatomic) NSString * programCode;

@property (nonatomic) NSString * status;
@property (nonatomic) NSString * duration;

@property (nonatomic) NSString * playCount;

@end
