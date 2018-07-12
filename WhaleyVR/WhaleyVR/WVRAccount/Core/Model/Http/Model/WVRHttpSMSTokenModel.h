//
//  WVRHttpSMSTokenModel.h
//  WhaleyVR
//
//  Created by qbshen on 16/10/20.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "YYModel.h"

@interface WVRHttpSMSTokenModel : NSObject

@property (nonatomic) NSString * sms_token;
@property (nonatomic) NSString * expiration_time;
@property (nonatomic) NSString * now_time;

@end
