//
//  WVRHttpRecommendPageDetailModel.h
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpLiveDetailModel.h"

/*
 [cur objectForKey:@"itemName"];
 curModel.thubImageUrl = [cur objectForKey:@"picUrl"];
 curModel.playUrl = [cur objectForKey:@"videoUrl"];
 curModel.downloadUrl = [cur objectForKey:@"downloadUrl"];
 curModel.subTitle = [cur objectForKey:@"subtitle"];
 curModel.linkArrangeValue = [cur objectForKey:@"linkId"];
 curModel.linkArrangeType = [cur objectForKey:@"linkType"];
 curModel.duration = [cur objectForKey:@"duration"];
 curModel.programType = [cur objectForKey:@"programType"];
 NSDictionary * statQueryDto = [cur objectForKey:@"statQueryDto"];
 curModel.playCount = [statQueryDto objectForKey:@"playCount"];
 */
@interface WVRHttpArrangeElement : NSObject
@property (nonatomic) NSString * itemName;
@property (nonatomic) NSString * picUrl;
@property (nonatomic) NSString * videoUrl;
@property (nonatomic) NSString * downloadUrl;

@property (nonatomic) NSString * subtitle;
@property (nonatomic) NSString * linkId;
@property (nonatomic) NSString * linkType;
@property (nonatomic) NSString * duration;
@property (nonatomic) NSString * programType;
@property (nonatomic) NSString * renderType;
@property (nonatomic) WVRHttpLiveStatModel * statQueryDto;

@end


@interface WVRHttpRecommendElement : NSObject

@property (nonatomic) NSString * Id;
@property (nonatomic) NSString * picUrlNew;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * createTime;
@property (nonatomic) NSString * updateTime;
@property (nonatomic) NSString * publishTime;
@property (nonatomic) NSString * style;
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * linkArrangeType;
@property (nonatomic) NSString * linkArrangeValue;
@property (nonatomic) NSString * flagUrl;
@property (nonatomic) NSString * flagCode;
@property (nonatomic) NSString * flagStatus;
@property (nonatomic) NSString * position;
@property (nonatomic) NSString * recommendAreaCode;
@property (nonatomic) NSString * status;
@property (nonatomic) NSString * version;
@property (nonatomic) NSString * appType;
@property (nonatomic) NSString * businessVersion;
@property (nonatomic) NSString * subtitle;
@property (nonatomic) NSString * introduction;
@property (nonatomic) NSString * secondJumpType;
@property (nonatomic) NSString * secondJumpValue;
@property (nonatomic) NSString * secondJumpText;
@property (nonatomic) NSString * infAuthorImageUrl;
@property (nonatomic) NSString * infAuthorName;
@property (nonatomic) NSString * infImageUrl;
@property (nonatomic) NSString * infTitle;
@property (nonatomic) NSString * infIntroduction;
@property (nonatomic) NSString * infUrl;
@property (nonatomic) NSString * infBrowseCount;
@property (nonatomic) NSString * detailCount;
@property (nonatomic) NSString * logoImageUrl;
@property (nonatomic) NSString * videoType;

@property (nonatomic) NSString * programType;

@property (nonatomic) NSString * type;

@property (nonatomic) int liveStatus;
@property (nonatomic) NSString * videoUrl;
@property (nonatomic) NSString * liveOrderCount;

@property (nonatomic, assign) int isChargeable;
@property (nonatomic, assign) long price;

@property (nonatomic) NSString * recommendPageType;

@property (nonatomic) NSArray* recommendAreaCodes;

@property (nonatomic) WVRHttpLiveStatModel * statQueryDto;

@property (nonatomic) NSString * programPlayTime;

@property (nonatomic) NSString* arrangeShowFlag;
@property (nonatomic) NSArray<WVRHttpArrangeElement*>* arrangeElements;

@property (nonatomic) NSString * duration;

@property (nonatomic) NSString * liveBeginTime;

@property (nonatomic) NSString * renderType;

@property (nonatomic, strong) NSString * behavior;

@property (nonatomic, strong) NSString * displayMode;

@property (nonatomic, strong) NSString * contentType;

@property (nonatomic, strong) WVRContentPackageQueryDto * contentPackageDto;

@end

/**
 * 推荐位{
 * 1：正常
 * 2：轮播
 * 3：广告
 * 4：品牌专区
 * 5：热门频道
 * 6：标题
 * }
 */

@interface WVRHttpRecommendArea : NSObject

@property (nonatomic) NSString * Id;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * createTime;
@property (nonatomic) NSString * updateTime;
@property (nonatomic) NSString * publishTime;
@property (nonatomic) NSString * type;
@property (nonatomic) NSString * position;
@property (nonatomic) NSString * style;
@property (nonatomic) NSString * recommendPageCode;
@property (nonatomic) NSString * status;
@property (nonatomic) NSString * version;
@property (nonatomic) NSArray<WVRHttpRecommendElement *>* recommendElements;

@end


@interface WVRHttpRecommendPageDetailModel : NSObject

@property (nonatomic) NSString * Id;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * createTime;
@property (nonatomic) NSString * updateTime;
@property (nonatomic) NSString * publishTime;
@property (nonatomic) NSString * status;
@property (nonatomic) NSString * isPage;
@property (nonatomic) NSString * version;
@property (nonatomic) NSArray<WVRHttpRecommendArea *>* recommendAreas;

@end
