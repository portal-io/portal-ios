//
//  WVRHttpRoomLoginReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpRoomLoginReformer.h"
#import "WVRRoomModel.h"

@implementation WVRHttpRoomLoginReformer

- (WVRRoomModel*)reformData:(NSDictionary *)data {
    WVRRoomModel * model = [WVRRoomModel yy_modelWithDictionary:data];
    NSDictionary * roomData = data[@"roomdata"];
    NSDictionary * msgservice = data[@"msgservice"];
    model.roomId = roomData[@"roomid"];
    
    model.host = msgservice[@"host"];
    model.port = msgservice[@"port"];
    model.lhost = msgservice[@"lhost"];
    NSDictionary * dic = data[@"noticedata"];
    NSString * color = dic[@"color"];
    NSString * duration = dic[@"duration"];
    NSString * msg = dic[@"message"];
    WVRwebSocketMsgType msgType = WVRwebSocketMsgTypeTop;
    WVRWebSocketMsg * webSocketMsg = [WVRWebSocketMsg new];
    webSocketMsg.msgStayDuration = [NSString stringWithFormat:@"%@",duration? duration:@""];
    webSocketMsg.content = [NSString stringWithFormat:@"%@",msg? msg:@""];;
    webSocketMsg.msgType = msgType;
    webSocketMsg.colorStr = color;
    model.noticeMsg = webSocketMsg;
    return model;
}

@end
