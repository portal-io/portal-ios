//
//  WVRProgramMemberModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRProgramMemberModel : NSObject
/*
 "memberCode": "d2acd07b886c438bb7ad3667a139fc02",
 "memberName": "自动化测试003",
 "smallPic": "http://test-image.tvmore.com.cn/image/get-image/10000004/1502158310308438029.jpg/zoom/800/551",
 "sort": 5
 */

@property (nonatomic, strong) NSString * memberCode;
@property (nonatomic, strong) NSString * memberName;
@property (nonatomic, strong) NSString * smallPic;
@property (nonatomic, strong) NSString * sort;

@end
