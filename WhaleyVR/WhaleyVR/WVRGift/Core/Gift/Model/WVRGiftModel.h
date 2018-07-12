//
//  WVRGiftModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRGiftModel : NSObject

//"giftCode": "0d1aa515128b070dcbdfe93036529607",
//"type": 1,
//"title": "小黄瓜",
//"intro": "小黄瓜",
//"price": 1,
//"priceUnit": 1,
//"pic": "http://store.whaley-vr.com/props/gift/2017-11-02/11872127111509611911449",
//"icon": "http://store.whaley-vr.com/props/gift/2017-11-02/11872127111509611916048"

@property (nonatomic, strong) NSString * giftCode;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * priceUnit;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSString * icon;

@end
