//
//  WVRApiHttpAccountBindThirdPartyTest.m
//  WhaleyVR
//
//  Created by XIN on 23/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpBindThirdPary.h"
#import "WVRUserModel.h"

@interface WVRApiHttpAccountBindThirdPartyTest : XCTestCase

@end

@implementation WVRApiHttpAccountBindThirdPartyTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testBindThirdParty {
    WVRApiHttpBindThirdPary * cmd = [[WVRApiHttpBindThirdPary alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[Params_thirdPartyBind_origin] = @"origin";
    httpDic[Params_thirdPartyBind_accesstoken] = [WVRUserModel sharedInstance].sessionId;
    httpDic[Params_thirdPartyBind_device_id] = [WVRUserModel sharedInstance].deviceId;
    httpDic[Params_thirdPartyBind_open_id] = [WVRUserModel sharedInstance].openIdForBinding;
    httpDic[Params_thirdPartyBind_unionid] = [WVRUserModel sharedInstance].wechatUnionid;
    httpDic[Params_thirdPartyBind_nickname] = @"nickName";
    httpDic[Params_thirdPartyBind_avatar] = @"avatar";
    
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(id data){
        NSLog(@"data: %@", data);
    };
    cmd.failedBlock = ^(id data){
        NSLog(@"data: %@", data);
    };
    [cmd loadData];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
