//
//  WVRShowFieldRoomModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "WVRNetConst.h"
@class WVRShowFieldRoomData;

@interface WVRShowFieldRoomModel : NSObject

@property (nonatomic, copy) NSString               * posttime;
@property (nonatomic, copy) NSString               * roomid;
@property (nonatomic, copy) NSString               * posid;
@property (nonatomic, copy) NSString               * order;
@property (nonatomic, copy) NSString               * titlepic;
@property (nonatomic, copy) NSString               * title;
@property (nonatomic, copy) NSString               * intro;
@property (nonatomic, strong) WVRShowFieldRoomData * roomdata;

@end


@interface WVRShowFieldRoomData : NSObject

@property (nonatomic, copy) NSString              * image;     // 图片
@property (nonatomic, assign) WVRLiveStatus     status;    // 状态
@property (nonatomic, copy) NSString              * title;
@property (nonatomic, copy) NSString              * intro;
@property (nonatomic, copy) NSString              * nickname;
@property (nonatomic, copy) NSString              * posid;
@property (nonatomic, copy) NSString              * roomid;
@property (nonatomic, copy) NSString              * avatar;
@property (nonatomic, copy) NSString              * follownum;
@property (nonatomic, copy) NSString              * charm;
@property (nonatomic, copy) NSString              * credits1;
@property (nonatomic, copy) NSString              * starttime;
@property (nonatomic, copy) NSString              * cateid;
@property (nonatomic, copy) NSString              * livenum;
@property (nonatomic, copy) NSString              * name;
@property (nonatomic, copy) NSString              * credits2;
@property (nonatomic, copy) NSString              * uid;
@property (nonatomic, copy) NSString              * dateline;
@property (nonatomic, copy) NSString              * disabled;
@property (nonatomic, copy) NSString              * votedata;
@property (nonatomic, copy) NSString              * order;
@property (nonatomic, copy) NSString              * content;
@property (nonatomic, copy) NSString              * memberrankcsv;

@end
