//
//  WVRAddressModel.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBaseModel.h"

@class WVRHttpAddressModel;

@interface WVRAddressModel : WVRBaseModel

@property (nonatomic) NSString* mobile;
@property (nonatomic) NSString* username;
@property (nonatomic) NSString* province;
@property (nonatomic) NSString* city;
@property (nonatomic) NSString* county;
@property (nonatomic) NSString* address;

- (instancetype)initWithHttpModel:(WVRHttpAddressModel*)httpModel;
- (instancetype)copyNewModel;

@end
