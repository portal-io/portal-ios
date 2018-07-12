//
//  WVRAccountGetUserInfoTest.m
//  WhaleyVR
//
//  Created by XIN on 23/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpGetUserInfo.h"
#import "WVRUserModel.h"
#import "WVRHttpUserModel.h"

@interface WVRAccountGetUserInfoTest : XCTestCase

@end

@implementation WVRAccountGetUserInfoTest

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

- (void)testGetUserInfo {
    WVRApiHttpGetUserInfo * cmd = [[WVRApiHttpGetUserInfo alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_userInfo_device_id] = [WVRUserModel sharedInstance].deviceId;
    httpDic[kHttpParams_userInfo_accesstoken] = [WVRUserModel sharedInstance].sessionId;
    
    cmd.bodyParams = httpDic;
    
    cmd.successedBlock = ^(id data) {
        NSLog(@"%@", data);
    };
    cmd.failedBlock = ^(id data) {
        NSLog(@"%@", data);
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
