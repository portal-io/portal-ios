//
//  WVRHttpArrangeElementModel.h
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/28.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatQueryDto : NSObject

@property (nonatomic) NSString *srcCode;
@property (nonatomic) NSString *srcDisplayName;
@property (nonatomic) NSString *viewCount;
@property (nonatomic) NSString *playCount;
@property (nonatomic) NSString *playSeconds;

@end


@interface WVRHttpArrangeElementModel : NSObject

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

@property (nonatomic) NSString * linkId;
@property (nonatomic) NSString * linkType;
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

@property (nonatomic) NSString * renderType;
@property (nonatomic) NSString * programType;

@property (nonatomic, strong) NSString * introduction;
@property (nonatomic, strong) NSString * detailCount;
@property (nonatomic) NSString * displayMode;
@property (nonatomic) StatQueryDto * statQueryDto;

@end

/*
 "id": 23,
 "createTime": 1478945818000,
 "updateTime": 1479112810000,
 "publishTime": 1479113151783,
 "name": "蒙面唱将第八期",
 "code": "MaskSinger_8th",
 "position": 0,
 "businessVersion": "null",
 "appType": "null",
 "type": 3,
 "parentId": 3,
 "isLeaf": true,
 "bigImageUrl": "http://image.aginomoto.com/image/get-image/10000004/14791127902672382433.jpg/zoom/1080/608",
 "introduction": "
 */
@interface WVRHttpArrangeEleFByCModel : NSObject

@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * bizType;
@property (nonatomic, copy) NSString * bigImageUrl;
@property (nonatomic, copy) NSString * introduction;

@property (nonatomic, strong) NSArray<WVRHttpArrangeElementModel *> *arrangeTreeElements;

@end
