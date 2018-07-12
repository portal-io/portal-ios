//
//  WVRHttpSearchRecommendModel.h
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WVRHttpMediaDtosModel, WVRHttpDownloadDtosModel, WVRHttpStatModel;

@interface WVRHttpSearchRecommendModel : NSObject

@property (nonatomic) NSString* Id;
@property (nonatomic) NSString* createTime;
@property (nonatomic) NSString* updateTime;
@property (nonatomic) NSString* publishTime;
@property (nonatomic) NSString* code;
@property (nonatomic) NSString* displayName;
@property (nonatomic) NSString* subtitle;
@property (nonatomic) NSString* director;
@property (nonatomic) NSString* actors;
@property (nonatomic) NSString* age;
@property (nonatomic) NSString* tags;
@property (nonatomic) NSString* tagCode;
@property (nonatomic) NSString* superscript;
@property (nonatomic) NSString* language;
@property (nonatomic) NSString* area;
@property (nonatomic) NSString* lunboPic;
@property (nonatomic) NSString* smallPic;
@property (nonatomic) NSString* bigPic;
@property (nonatomic) NSString* source;
@property (nonatomic) NSString* descriptionStr;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSString* pubStatus;
@property (nonatomic) NSArray<WVRHttpMediaDtosModel *>* mediaDtos;
@property (nonatomic) NSArray<WVRHttpDownloadDtosModel *>* downloadDtos;
@property (nonatomic) WVRHttpStatModel* stat;

@end


@interface WVRHttpMediaDtosModel : NSObject

@property (nonatomic) NSString* Id;
@property (nonatomic) NSString* createTime;
@property (nonatomic) NSString* updateTime;
@property (nonatomic) NSString* parentCode;
@property (nonatomic) NSString* source;
@property (nonatomic) NSString* playUrl;
@property (nonatomic) NSString* videoType;
@property (nonatomic) NSString* threedType;
@property (nonatomic) NSString* renderType;
@property (nonatomic) NSString* resolution;
@property (nonatomic) NSInteger status;

@end


@interface WVRHttpDownloadDtosModel : NSObject

@property (nonatomic) NSString* Id;
@property (nonatomic) NSString* createTime;
@property (nonatomic) NSString* updateTime;
@property (nonatomic) NSString* parentCode;
@property (nonatomic) NSString* downloadUrl;
@property (nonatomic) NSString* videoType;
@property (nonatomic) NSString* threedType;
@property (nonatomic) NSString* renderType;
@property (nonatomic) NSString* resolution;
@property (nonatomic) NSInteger status;

@end


@interface WVRHttpStatModel : NSObject

@property (nonatomic) NSString* srcCode;
@property (nonatomic) NSString* srcDisplayName;
@property (nonatomic) NSString* srcType;
@property (nonatomic) NSString* viewCount;
@property (nonatomic) NSString* playCount;
@property (nonatomic) NSString* playSeconds;

@end

