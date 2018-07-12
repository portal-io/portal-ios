//
//  WVRHttpTVElementModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRHttpTVElementModel : NSObject

@property (nonatomic) NSString * Id;
@property (nonatomic) NSString * createTime;
@property (nonatomic) NSString * updateTime;
@property (nonatomic) NSString * publishTime;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * position;
@property (nonatomic) NSString * itemName;
@property (nonatomic) NSString * picUrl;
@property (nonatomic) NSString * flagUrl;
@property (nonatomic) NSString * videoUrl;
@property (nonatomic) NSString * linkArrangeValue;
@property (nonatomic) NSString * linkArrangeType;
@property (nonatomic) NSString * status;
@property (nonatomic) NSString * treeNodeCode;
@property (nonatomic) NSString * version;
@property (nonatomic) NSString * subtitle;
@property (nonatomic, assign) int isChargeable;
@property (nonatomic, assign) long price;
@property (nonatomic) NSString * videoType;
@property (nonatomic) NSString * duration;

@property (nonatomic) NSString * programType;

@end
