//
//  WVRHttpFindStat.h
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//
/* {
 "srcCode": "test1",
 "srcDisplayName": "aaa",
 "srcType": "VR",
 "viewCount": 145,
 "playCount": 112,
 "playSeconds": 770
 } */
@interface WVRHttpFindStatModel : NSObject
@property(nonatomic) NSString* srcCode;
@property(nonatomic) NSString* srcDisplayName;
@property(nonatomic) NSString* srcType;
@property(nonatomic) NSString* viewCount;
@property(nonatomic) NSString* playCount;
@property(nonatomic) NSString* playSeconds;

@end
