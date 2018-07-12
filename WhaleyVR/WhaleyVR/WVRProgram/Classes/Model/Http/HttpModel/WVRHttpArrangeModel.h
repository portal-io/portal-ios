//
//  WVRHttpArrangeModel.h
//  WhaleyVR
//
//  Created by qbshen on 16/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
/*
 "code": "a07a8c72cb644e42bcd89ad435cc9617",
 "name": "xx",
 "orderNum": 3,
 "type": "ARRANGE"
 */
@interface WVRHttpArrangeModel : NSObject
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * orderNum;
@property (nonatomic) NSString * type;
@end
