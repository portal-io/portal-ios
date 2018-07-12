//
//  WVRHttpGiftModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRProgramMemberModel.h"

@interface WVRHttpProgramMembersModel : NSObject
/*
 "giftTemplateCode": "0db7387d64287b0d70b05380775f2abe",
 "platform": "all",
 "project": "entertainment",
 "title": "默认",
 "intro": "",
 "pic": "",
 "status": 1,
 "giftList":
 */

@property (nonatomic) NSArray<WVRProgramMemberModel*> *memberTemplateRelDtos;

@end
