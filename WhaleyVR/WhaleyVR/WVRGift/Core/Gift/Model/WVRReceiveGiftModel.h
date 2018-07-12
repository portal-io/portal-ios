//
//  WVRReceiveGiftModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 giftCode = 0d1aa515128b070dcbdfe93036529607;
 giftIcon = "http://store.whaley-vr.com/props/gift/2017-11-02/11872127111509611916048";
 giftName = "\U5c0f\U9ec4\U74dc";
 giftPic = "http://store.whaley-vr.com/props/gift/2017-11-02/11872127111509611911449";
 liveCode = a64909f3bc264d1ca0ffc5fa912fc18f;
 memberCode = "";
 memberHeadUrl = "";
 memberName = "";
 nickName = "=_=\U5566D.C.wuusaasds";
 "response_dateline" = 1511947195;
 uid = 89785691;
 userHeadUrl = "http://image.aginomoto.com/whaley?acid=89785691&width=0&height=0&retate=0";
 }];
 */
@interface WVRReceiveGiftModel : NSObject

@property (nonatomic, copy) NSString * giftCode;

@property (nonatomic, copy) NSString * giftIcon;

@property (nonatomic, copy) NSString * giftName;

@property (nonatomic, copy) NSString * giftPic;

@property (nonatomic, copy) NSString * liveCode;
@property (nonatomic, copy) NSString * memberCode;
@property (nonatomic, copy) NSString * memberHeadUrl;

@property (nonatomic, copy) NSString * memberName;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * userHeadUrl;


@end
