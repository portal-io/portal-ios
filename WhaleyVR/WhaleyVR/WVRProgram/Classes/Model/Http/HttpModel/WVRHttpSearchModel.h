//
//  WVRHttpSearchModel.h
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
/*{
 "status": 200,
 "message": "success",
 "useTime": "5ms",
 "arrange": [{
 "code" : "6d7ff7516890422499141fec774e68cc",
 "name" : "测试编排",
 "big_image_url" : "http://aaa.com/a.jpg",
 "is_leaf" : "0"
 }],
 "program": [{
 "code": "6d7ff7516890422499141fec774e68cc",
 "display_name": "测试",
 "type": "",
 "director": "",
 "actors": "",
 "tags": "",
 "area": "",
 "big_pic": "",
 "description": "",
 "subtitle": "测试"
 }, {
 "code": "7289652a2bc3463ebd0bfcc707a612e8",
 "display_name": "测试1",
 "type": "MOVIE",
 "director": "",
 "actors": "",
 "tags": "",
 "area": "",
 "big_pic": "",
 "description": "",
 "subtitle": "test"
 }]
 }*/
@interface WVRHttpSimpleProgramModel : NSObject

@property (nonatomic) NSString* code;
@property (nonatomic) NSString* display_name;
@property (nonatomic) NSString* type;
@property (nonatomic) NSString* video_type;
@property (nonatomic) NSString* director;
@property (nonatomic) NSString* actors;
@property (nonatomic) NSString* tags;
@property (nonatomic) NSString* area;
@property (nonatomic) NSString* big_pic;
@property (nonatomic) NSString* desc;
@property (nonatomic) NSString* subtitle;
@property (nonatomic, copy) NSString *program_type;

@end


@interface WVRHttpSimpleArrangeModel : NSObject

@property (nonatomic) NSString* code;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* big_image_url;
@property (nonatomic) NSString* is_leaf;

@end


@interface WVRHttpSearchModel : NSObject

@property (nonatomic) NSInteger status;
@property (nonatomic) NSString* message;
@property (nonatomic) NSString* useTime;
@property (nonatomic) NSArray <WVRHttpSimpleArrangeModel*>* arrange;
@property (nonatomic) NSArray <WVRHttpSimpleProgramModel*>* program;

@end
