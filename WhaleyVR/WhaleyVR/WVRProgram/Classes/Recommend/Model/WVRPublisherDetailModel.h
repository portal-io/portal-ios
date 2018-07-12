//
//  WVRPublisherDetailModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 发布者详情

#import <Foundation/Foundation.h>
#import "YYModel.h"
@class WVRPublisherModel;

@interface WVRPublisherDetailModel : NSObject

@property (nonatomic, strong) WVRPublisherModel *cp;
@property (nonatomic, assign) long follow;

+ (void)requestForPublisherDetailWithCode:(NSString *)code block:(void (^)(WVRPublisherDetailModel * model, NSError *error))block;

@end


@interface WVRPublisherModel : NSObject

@property (nonatomic, assign) long Id;
@property (nonatomic, assign) long available;
@property (nonatomic, assign) long fansCount;
@property (nonatomic, assign) long updateTime;
@property (nonatomic, assign) long createTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *backgroundPic;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *info;

@end
