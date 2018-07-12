//
//  WVRRoomModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRWebSocketMsg.h"

@interface WVRRoomModel : NSObject

@property (nonatomic, strong) NSString * roomauth;

@property (nonatomic, strong) NSString * roomId;

@property (nonatomic, strong) NSString * host;

@property (nonatomic, strong) NSString * port;
@property (nonatomic, strong) NSString * lhost;

@property (nonatomic, strong) NSString * status;

@property (nonatomic, strong) WVRWebSocketMsg * noticeMsg;

//msgservice": {
//"serid": "1",
//"livemax": "1000",
//"status": "1",
//"title": "开发测试服务器",
//"host": "106.75.84.232",
//"lhost": "10.19.120.161",
//"port":
@end
