//
//  WVRWebSocketConfig.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRAuthModel.h"
#import "WVRRoomModel.h"
#import "WVRLoginModel.h"

@interface WVRWebSocketConfig : NSObject

@property (nonatomic, strong) NSString * programId;
@property (nonatomic, strong) NSString * programName;

@property (nonatomic, strong) WVRAuthModel * authModel;

@property (nonatomic, strong) WVRRoomModel * roomModel;

@property (nonatomic, copy) void(^receiveGiftMsgCallback)(NSDictionary *msg);

@end
