//
//  WVRHttpProgramModel.h
//  WhaleyVR
//
//  Created by qbshen on 16/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRHttpProgramMediasModel : NSObject

@property (nonatomic) NSString * Id;
@property (nonatomic) NSString * createTime;
@property (nonatomic) NSString * updateTime;
@property (nonatomic) NSString * parentCode;
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * source;
@property (nonatomic) NSString * playUrl;

@property (nonatomic) NSString * videoType;
@property (nonatomic) NSString * threedType;
@property (nonatomic) NSString * resolution;
@property (nonatomic) NSString * prefer;
@property (nonatomic) NSString * status;

@end


@interface WVRHttpProgramDownloadDtoModel : NSObject

@property (nonatomic) NSString * Id;
@property (nonatomic) NSString * createTime;
@property (nonatomic) NSString * updateTime;
@property (nonatomic) NSString * parentCode;
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * source;
@property (nonatomic) NSString * downloadUrl;
@property (nonatomic) NSString * renderType;
@property (nonatomic) NSString * videoType;
@property (nonatomic) NSString * threedType;
@property (nonatomic) NSString * resolution;
@property (nonatomic) NSString * prefer;
@property (nonatomic) NSString * status;


@end

@interface WVRHttpProgramStatModel : NSObject

@property (nonatomic) NSString * srcCode;
@property (nonatomic) NSString * srcDisplayName;
@property (nonatomic) NSString * srcType;
@property (nonatomic) NSString * viewCount;
@property (nonatomic) NSString * playCount;
@property (nonatomic) NSString * playSeconds;

@end

@interface WVRHttpProgramModel : NSObject

@property (nonatomic) NSString * Id;
@property (nonatomic) NSString * createTime;
@property (nonatomic) NSString * updateTime;
@property (nonatomic) NSString * publishTime;
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * parentCode;
@property (nonatomic) NSString * displayName;

@property (nonatomic) NSString * curEpisode;

@property (nonatomic) NSString * subtitle;

@property (nonatomic) NSString * type;
@property (nonatomic) NSString * director;
@property (nonatomic) NSString * actors;
@property (nonatomic) NSString * age;
@property (nonatomic) NSString * tags;
@property (nonatomic) NSString * superscript;
@property (nonatomic) NSString * language;

@property (nonatomic) NSString * area;
@property (nonatomic) NSString * year;
@property (nonatomic) NSString * lunboPic;
@property (nonatomic, strong) NSString * pics;
@property (nonatomic) NSString * smallPic;
@property (nonatomic) NSString * bigPic;
@property (nonatomic) NSString * desc;
@property (nonatomic) NSString * status;
@property (nonatomic) NSString * pubStatus;

@property (nonatomic) NSString * duration;
@property (nonatomic) float  score;
@property (nonatomic) NSString * relatedCode;
@property (nonatomic, strong) NSArray<WVRHttpProgramMediasModel *> *medias;
@property (nonatomic, strong) NSArray<WVRHttpProgramDownloadDtoModel *> *downloadDtos;
@property (nonatomic) WVRHttpProgramStatModel * stat;

@property (nonatomic, strong) NSArray<WVRHttpProgramModel *> *series;

@end
