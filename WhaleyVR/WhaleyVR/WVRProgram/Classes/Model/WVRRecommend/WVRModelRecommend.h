//
//  WVRModelRecommend.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRModelLiveStatModel : NSObject

@property (nonatomic) NSString * srcCode;
@property (nonatomic) NSString * srcDisplayName;
@property (nonatomic) NSString * srcType;
@property (nonatomic) NSString * viewCount;
@property (nonatomic) NSString * playCount;
@property (nonatomic) NSString * playSeconds;

@end

@interface WVRModelRecommendElement : NSObject

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

@property (nonatomic) WVRModelLiveStatModel * statQueryDto;

@end

@interface WVRModelRecommendArea : NSObject

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
@property (nonatomic) NSArray<WVRModelRecommendElement *>* recommendElements;

@end

@interface WVRModelRecommend : NSObject
@property (nonatomic) NSString * id;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * createTime;
@property (nonatomic) NSString * updateTime;
@property (nonatomic) NSString * publishTime;
@property (nonatomic) NSString * status;
@property (nonatomic) NSString * isPage;
@property (nonatomic) NSString * version;
@property (nonatomic) NSArray<WVRModelRecommendArea *>* recommendAreas;

@end
