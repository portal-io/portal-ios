//
//  WVRHttpHistoryListModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "id": 4,
 "uid": 123456789,
 "playTime": "1234",
 "playStatus": 1,
 "programCode": "mt_43d2078adff6438fb440399883bedd5a",
 "programType": "moretv",
 "programName": "红酒俏佳人[8]",
 "programStatus": 1,
 "status": 1,
 "reportTime": 1488526749000,
 "createTime": 1488523607000,
 "updateTime": 1488522100000,
 "parentCode": "mt_348340c56ffc4ecf82bfb4e02b628893",//剧头code
 "parentDisplayName": "红酒俏佳人",//剧头名称
 "curEpisode": 8,//当前集数
 "totalEpisode": 42,//总集数
 "totalPlayTime": "666666",//总播放时间
 "type": "code",//内容类型code，当为电视猫节目类型时的值（movie:电影;tv:电视剧）
 "videoType": "moretv_2d"//视频格式（2d,3d,vr,moretv_2d）
 */
@class WVRHttpHistoryItemModel;

@interface WVRHttpHistoryListModel : NSObject

/*
 "total": 2,
 "size": 0,
 "number": 0,
 "first": true,
 "totalElements": 2,
 "last": true,
 "totalPages": 1,
 "numberOfElements": 2
 */

@property (nonatomic, strong) NSArray<WVRHttpHistoryItemModel*>* content;
@property (nonatomic, strong) NSString * total;
@property (nonatomic, strong) NSString * size;

@property (nonatomic, strong) NSString * number;
@property (nonatomic, strong) NSString * first;


@property (nonatomic, strong) NSString * totalElements;
@property (nonatomic, strong) NSString * last;
@property (nonatomic, strong) NSString * totalPages;
@property (nonatomic, strong) NSString * numberOfElements;


@end

@interface WVRHttpHistoryItemModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * uid;

@property (nonatomic, strong) NSString * playTime;
@property (nonatomic, strong) NSString * playStatus;


@property (nonatomic, strong) NSString * programCode;
@property (nonatomic, strong) NSString * programType;
@property (nonatomic, strong) NSString * programName;
@property (nonatomic, strong) NSString * programStatus;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * reportTime;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * parentCode;
@property (nonatomic, strong) NSString * parentDisplayName;
@property (nonatomic, strong) NSString * curEpisode;
@property (nonatomic, strong) NSString * totalEpisode;
@property (nonatomic, strong) NSString * totalPlayTime;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * videoType;

@property (nonatomic, strong) NSString * programImgUrl;
@end
