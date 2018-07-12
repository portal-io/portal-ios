//
//  WVRHttpMyReserveModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRHttpLiveDetailModel.h"

@interface WVRHttpMyReserveItemModel : NSObject

@property (nonatomic) NSString * displayName;

@property (nonatomic) NSString * poster;

@property (nonatomic) NSString * beginTime;

@property (nonatomic) int liveStatus;

@property (nonatomic) NSString * code;

@property (nonatomic) NSString * displayMode;

@property (nonatomic) NSString * programType;

@property (nonatomic) NSArray<WVRMediaDto*> * liveMediaDtos;

@property (nonatomic) WVRHttpLiveStatModel * stat;

@end


@interface WVRHttpMyReserveModel : NSObject

@property (nonatomic) NSArray<WVRHttpMyReserveItemModel *>* data;

@end
